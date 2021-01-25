/*
 * Copyright 2017 Jumio Corporation
 * All rights reserved
 */

package com.jumio.react;

import android.app.Activity;
import android.content.Intent;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.WritableMap;
import com.jumio.MobileSDK;
import com.jumio.core.enums.JumioCameraPosition;
import com.jumio.core.enums.JumioDataCenter;
import com.jumio.core.exceptions.MissingPermissionException;
import com.jumio.dv.DocumentVerificationSDK;

import org.jetbrains.annotations.NotNull;

public class JumioModuleDocumentVerification extends JumioBaseModule {

	private final static String TAG = "JumioMobileSDKDocumentVerification";
	private final String ERROR_KEY = "EventErrorDocumentVerification";

	public static DocumentVerificationSDK documentVerificationSDK;

	JumioModuleDocumentVerification(ReactApplicationContext context) {
		super(context);
	}

	@Override
	public String getErrorKey() {
		return ERROR_KEY;
	}


	private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {
		@Override
		public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
			if (requestCode == DocumentVerificationSDK.REQUEST_CODE) {
				if (data == null) {
					return;
				}
				String scanReference = data.getStringExtra(DocumentVerificationSDK.EXTRA_SCAN_REFERENCE) != null ? data.getStringExtra(DocumentVerificationSDK.EXTRA_SCAN_REFERENCE) : "";

				if (resultCode == Activity.RESULT_OK) {
					WritableMap result = Arguments.createMap();
					result.putString("successMessage", "Document-Verification finished successfully.");
					result.putString("scanReference", scanReference);

					sendEvent("EventDocumentVerification", result);

				} else if (resultCode == Activity.RESULT_CANCELED) {
					String errorMessage = data.getStringExtra(DocumentVerificationSDK.EXTRA_ERROR_MESSAGE);
					String errorCode = data.getStringExtra(DocumentVerificationSDK.EXTRA_ERROR_CODE);
					sendErrorObject(errorCode, errorMessage, scanReference);
				}
				if (JumioModuleDocumentVerification.documentVerificationSDK != null) {
					JumioModuleDocumentVerification.documentVerificationSDK.destroy();
				}
				reactContext.removeActivityEventListener(mActivityEventListener);
			}
		}
	};

	@NotNull
	@Override
	public String getName() {
		return "JumioMobileSDKDocumentVerification";
	}

	// Document Verification

	@ReactMethod
	public void initDocumentVerification(String apiToken, String apiSecret, String dataCenter, ReadableMap options) {
		try {
			if (apiToken.isEmpty() || apiSecret.isEmpty() || dataCenter.isEmpty()) {
				showErrorMessage("Missing required parameters apiToken, apiSecret or dataCenter.");
				return;
			}


			JumioDataCenter center = null;
			try {
				center = JumioDataCenter.valueOf(dataCenter.toUpperCase());
			} catch (Exception e) {
				throw new Exception("Datacenter not valid: "+dataCenter);            
			}
			documentVerificationSDK = DocumentVerificationSDK.create(getCurrentActivity(), apiToken, apiSecret, center);

			// Configuration options
			ReadableMapKeySetIterator keys = options.keySetIterator();
			while (keys.hasNextKey()) {
				String key = keys.nextKey();

				if (key.equalsIgnoreCase("type")) {
					documentVerificationSDK.setType(options.getString(key));
				} else if (key.equalsIgnoreCase("customDocumentCode")) {
					documentVerificationSDK.setCustomDocumentCode(options.getString(key));
				} else if (key.equalsIgnoreCase("country")) {
					documentVerificationSDK.setCountry(options.getString(key));
				} else if (key.equalsIgnoreCase("reportingCriteria")) {
					documentVerificationSDK.setReportingCriteria(options.getString(key));
				} else if (key.equalsIgnoreCase("callbackUrl")) {
					documentVerificationSDK.setCallbackUrl(options.getString(key));
				} else if (key.equalsIgnoreCase("enableExtraction")) {
					documentVerificationSDK.setEnableExtraction(options.getBoolean(key));
				} else if (key.equalsIgnoreCase("customerInternalReference")) {
					documentVerificationSDK.setCustomerInternalReference(options.getString(key));
				} else if (key.equalsIgnoreCase("userReference")) {
					documentVerificationSDK.setUserReference(options.getString(key));
				} else if (key.equalsIgnoreCase("documentName")) {
					documentVerificationSDK.setDocumentName(options.getString(key));
				} else if (key.equalsIgnoreCase("cameraPosition")) {
					JumioCameraPosition cameraPosition = (options.getString(key).toLowerCase().equals("front")) ? JumioCameraPosition.FRONT : JumioCameraPosition.BACK;
					documentVerificationSDK.setCameraPosition(cameraPosition);
				}
			}
		} catch (Exception e) {
			showErrorMessage("Error initializing the Document Verification SDK: " + e.getLocalizedMessage());
		}
	}

	@ReactMethod
	public void startDocumentVerification() {
		if (documentVerificationSDK == null) {
			showErrorMessage("The Document Verification SDK is not initialized yet. Call initDocumentVerification() first.");
			return;
		}

		try {
			boolean sdkStarted = checkPermissionsAndStart(documentVerificationSDK);
			if(sdkStarted){
				reactContext.addActivityEventListener(mActivityEventListener);
			}
		} catch (Exception e) {
			showErrorMessage("Error starting the Document Verification SDK: " + e.getLocalizedMessage());
		}
	}


	protected void startSdk(MobileSDK sdk) {
		try {
			sdk.start();
		} catch (MissingPermissionException e) {
			showErrorMessage(e.getLocalizedMessage());
		}
	}
}

