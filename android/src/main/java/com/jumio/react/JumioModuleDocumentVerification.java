/*
 * Copyright 2017 Jumio Corporation
 * All rights reserved
 */

package com.jumio.react;

import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.jumio.MobileSDK;
import com.jumio.core.enums.JumioCameraPosition;
import com.jumio.core.enums.JumioDataCenter;
import com.jumio.core.exceptions.MissingPermissionException;
import com.jumio.dv.DocumentVerificationSDK;

import androidx.core.app.ActivityCompat;

public class JumioModuleDocumentVerification extends ReactContextBaseJavaModule {

    private final static String TAG = "JumioMobileSDKDocumentVerification";
    public static final int PERMISSION_REQUEST_CODE_DOCUMENT_VERIFICATION = 303;

    public static DocumentVerificationSDK documentVerificationSDK;

	JumioModuleDocumentVerification(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "JumioMobileSDKDocumentVerification";
    }

    @Override
    public boolean canOverrideExistingModule() {
        return true;
    }

    // Document Verification

    @ReactMethod
    public void initDocumentVerification(String apiToken, String apiSecret, String dataCenter, ReadableMap options) {
        if (!DocumentVerificationSDK.isSupportedPlatform(this.getCurrentActivity())) {
            showErrorMessage("This platform is not supported.");
            return;
        }

        try {
            if (apiToken.isEmpty() || apiSecret.isEmpty() || dataCenter.isEmpty()) {
                showErrorMessage("Missing required parameters apiToken, apiSecret or dataCenter.");
                return;
            }

            JumioDataCenter center = (dataCenter.equalsIgnoreCase("eu")) ? JumioDataCenter.EU : JumioDataCenter.US;
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
            checkPermissionsAndStart(documentVerificationSDK);
        } catch (Exception e) {
            showErrorMessage("Error starting the Document Verification SDK: " + e.getLocalizedMessage());
        }
    }



    // Permissions

    private void checkPermissionsAndStart(MobileSDK sdk) {
        if (!MobileSDK.hasAllRequiredPermissions(getReactApplicationContext())) {
            //Acquire missing permissions.
            String[] mp = MobileSDK.getMissingPermissions(getReactApplicationContext());

            int code;
            if (sdk instanceof DocumentVerificationSDK)
                code = PERMISSION_REQUEST_CODE_DOCUMENT_VERIFICATION;
            else {
                showErrorMessage("Invalid SDK instance");
                return;
            }

            ActivityCompat.requestPermissions(getReactApplicationContext().getCurrentActivity(), mp, code);
            //The result is received in MainActivity::onRequestPermissionsResult.
        } else {
            startSdk(sdk);
        }
    }

    protected void startSdk(MobileSDK sdk) {
        try {
            sdk.start();
        } catch (MissingPermissionException e) {
            showErrorMessage(e.getLocalizedMessage());
        }
    }

	private void showErrorMessage(String msg) {
		Log.e("Error", msg);
		WritableMap errorResult = Arguments.createMap();
		errorResult.putString("errorMessage", msg != null ? msg : "");
		sendEvent("EventError", errorResult);
	}

	// Helper methods

	private void sendEvent(String eventName, WritableMap params) {
		getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
				.emit(eventName, params);
	}
}

