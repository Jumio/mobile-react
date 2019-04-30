/*
 * Copyright 2017 Jumio Corporation
 * All rights reserved
 */

package com.jumio.react;

import androidx.core.app.ActivityCompat;
import android.util.Log;

import com.facebook.react.bridge.*;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.jumio.MobileSDK;
import com.jumio.bam.BamSDK;
import com.jumio.bam.enums.CreditCardType;
import com.jumio.core.enums.*;
import com.jumio.core.exceptions.MissingPermissionException;
import com.jumio.core.exceptions.PlatformNotSupportedException;

import java.util.ArrayList;

public class JumioModuleBamCheckout extends ReactContextBaseJavaModule {

    private final static String TAG = "JumioMobileSDKBamCheckout";
    public static final int PERMISSION_REQUEST_CODE_BAM = 300;

	public static BamSDK bamSDK;

    JumioModuleBamCheckout(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "JumioMobileSDKBamCheckout";
    }

    @Override
    public boolean canOverrideExistingModule() {
        return true;
    }

    // BAM Checkout

    @ReactMethod
    public void initBAM(String apiToken, String apiSecret, String dataCenter, ReadableMap options) {
        if (BamSDK.isRooted(getReactApplicationContext())) {
            showErrorMessage("The BAM SDK can't run on a rooted device.");
            return;
        }

        if (!BamSDK.isSupportedPlatform(this.getCurrentActivity())) {
            showErrorMessage("This platform is not supported.");
            return;
        }

        try {
            if (apiToken.isEmpty() || apiSecret.isEmpty() || dataCenter.isEmpty()) {
                showErrorMessage("Missing required parameters apiToken, apiSecret or dataCenter.");
                return;
            }

            JumioDataCenter center = (dataCenter.equalsIgnoreCase("eu")) ? JumioDataCenter.EU : JumioDataCenter.US;
            bamSDK = BamSDK.create(getCurrentActivity(), apiToken, apiSecret, center);

            this.configureBAM(options);
        } catch (Exception e) {
            showErrorMessage("Error initializing the BAM SDK: " + e.getLocalizedMessage());
        }
    }

    private void configureBAM(ReadableMap options) {
        ReadableMapKeySetIterator keys = options.keySetIterator();
        while (keys.hasNextKey()) {
            String key = keys.nextKey();

            if (key.equalsIgnoreCase("cardHolderNameRequired")) {
                bamSDK.setCardHolderNameRequired(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("sortCodeAndAccountNumberRequired")) {
                bamSDK.setSortCodeAndAccountNumberRequired(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("expiryRequired")) {
                bamSDK.setExpiryRequired(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("cvvRequired")) {
                bamSDK.setCvvRequired(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("expiryEditable")) {
                bamSDK.setExpiryEditable(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("cardHolderNameEditable")) {
                bamSDK.setCardHolderNameEditable(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("reportingCriteria")) {
                bamSDK.setMerchantReportingCriteria(options.getString(key));
            } else if (key.equalsIgnoreCase("vibrationEffectEnabled")) {
                bamSDK.setVibrationEffectEnabled(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("enableFlashOnScanStart")) {
                bamSDK.setEnableFlashOnScanStart(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("cardNumberMaskingEnabled")) {
                bamSDK.setCardNumberMaskingEnabled(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("cameraPosition")) {
                JumioCameraPosition cameraPosition = (options.getString(key).toLowerCase().equals("front")) ? JumioCameraPosition.FRONT : JumioCameraPosition.BACK;
                bamSDK.setCameraPosition(cameraPosition);
            } else if (key.equalsIgnoreCase("cardTypes")) {
                ReadableArray jsonTypes = options.getArray(key);
                ArrayList<String> types = new ArrayList<String>();
                if (jsonTypes != null) {
                    int len = jsonTypes.size();
                    for (int i = 0; i < len; i++) {
                        types.add(jsonTypes.getString(i));
                    }
                }

                ArrayList<CreditCardType> creditCardTypes = new ArrayList<CreditCardType>();
                for (String type : types) {
                    if (type.toLowerCase().equals("visa")) {
                        creditCardTypes.add(CreditCardType.VISA);
                    } else if (type.toLowerCase().equals("master_card")) {
                        creditCardTypes.add(CreditCardType.MASTER_CARD);
                    } else if (type.toLowerCase().equals("american_express")) {
                        creditCardTypes.add(CreditCardType.AMERICAN_EXPRESS);
                    } else if (type.toLowerCase().equals("china_unionpay")) {
                        creditCardTypes.add(CreditCardType.CHINA_UNIONPAY);
                    } else if (type.toLowerCase().equals("diners_club")) {
                        creditCardTypes.add(CreditCardType.DINERS_CLUB);
                    } else if (type.toLowerCase().equals("discover")) {
                        creditCardTypes.add(CreditCardType.DISCOVER);
                    } else if (type.toLowerCase().equals("jcb")) {
                        creditCardTypes.add(CreditCardType.JCB);
                    }
                }

                bamSDK.setSupportedCreditCardTypes(creditCardTypes);
            }
        }
    }

    @ReactMethod
    public void startBAM() {
        if (bamSDK == null) {
            showErrorMessage("The BAM SDK is not initialized yet. Call initBAM() first.");
            return;
        }

        try {
            checkPermissionsAndStart(bamSDK);
        } catch(IllegalArgumentException e) {
            showErrorMessage("Error starting the BAM SDK: " + e.getLocalizedMessage());
        }
    }

    // Permissions

    private void checkPermissionsAndStart(MobileSDK sdk) {
        if (!MobileSDK.hasAllRequiredPermissions(getReactApplicationContext())) {
            //Acquire missing permissions.
            String[] mp = MobileSDK.getMissingPermissions(getReactApplicationContext());

            int code;
            if (sdk instanceof BamSDK)
                code = PERMISSION_REQUEST_CODE_BAM;
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

