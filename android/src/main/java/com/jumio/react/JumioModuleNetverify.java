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
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.jumio.MobileSDK;
import com.jumio.core.enums.JumioCameraPosition;
import com.jumio.core.enums.JumioDataCenter;
import com.jumio.core.exceptions.MissingPermissionException;
import com.jumio.nv.NetverifySDK;
import com.jumio.nv.data.document.NVDocumentType;
import com.jumio.nv.data.document.NVDocumentVariant;

import java.util.ArrayList;

import androidx.core.app.ActivityCompat;

public class JumioModuleNetverify extends ReactContextBaseJavaModule {

    private final static String TAG = "JumioMobileSDKNetverify";
    public static final int PERMISSION_REQUEST_CODE_NETVERIFY = 301;

	public static  NetverifySDK netverifySDK;

    JumioModuleNetverify(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "JumioMobileSDKNetverify";
    }

    @Override
    public boolean canOverrideExistingModule() {
        return true;
    }
    // Netverify

    @ReactMethod
    public void initNetverify(String apiToken, String apiSecret, String dataCenter, ReadableMap options) {
        if (!NetverifySDK.isSupportedPlatform(this.getCurrentActivity())) {
            showErrorMessage("This platform is not supported.");
            return;
        }

        try {
            if (apiToken.isEmpty() || apiSecret.isEmpty() || dataCenter.isEmpty()) {
                showErrorMessage("Missing required parameters apiToken, apiSecret or dataCenter.");
                return;
            }

            JumioDataCenter center = (dataCenter.equalsIgnoreCase("eu")) ? JumioDataCenter.EU : JumioDataCenter.US;
            netverifySDK = NetverifySDK.create(getCurrentActivity(), apiToken, apiSecret, center);

            this.configureNetverify(options);
        } catch (Exception e) {
            showErrorMessage("Error initializing the Netverify SDK: " + e.getLocalizedMessage());
        }
    }

    private void configureNetverify(ReadableMap options) {
        ReadableMapKeySetIterator keys = options.keySetIterator();
        while (keys.hasNextKey()) {
            String key = keys.nextKey();

            if (key.equalsIgnoreCase("enableVerification")) {
                netverifySDK.setEnableVerification(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("callbackUrl")) {
                netverifySDK.setCallbackUrl(options.getString(key));
            } else if (key.equalsIgnoreCase("enableIdentityVerification")) {
                netverifySDK.setEnableIdentityVerification(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("preselectedCountry")) {
                netverifySDK.setPreselectedCountry(options.getString(key));
            } else if (key.equalsIgnoreCase("customerInternalReference")) {
                netverifySDK.setCustomerInternalReference(options.getString(key));
            } else if (key.equalsIgnoreCase("reportingCriteria")) {
                netverifySDK.setReportingCriteria(options.getString(key));
            } else if (key.equalsIgnoreCase("userReference")) {
                netverifySDK.setUserReference(options.getString(key));
            } else if (key.equalsIgnoreCase("enableEpassport")) {
                netverifySDK.setEnableEMRTD(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("sendDebugInfoToJumio")) {
                netverifySDK.sendDebugInfoToJumio(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("dataExtractionOnMobileOnly")) {
                netverifySDK.setDataExtractionOnMobileOnly(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("cameraPosition")) {
                JumioCameraPosition cameraPosition = (options.getString(key).toLowerCase().equals("front")) ? JumioCameraPosition.FRONT : JumioCameraPosition.BACK;
                netverifySDK.setCameraPosition(cameraPosition);
            } else if (key.equalsIgnoreCase("preselectedDocumentVariant")) {
                NVDocumentVariant variant = (options.getString(key).toLowerCase().equals("paper")) ? NVDocumentVariant.PAPER : NVDocumentVariant.PLASTIC;
                netverifySDK.setPreselectedDocumentVariant(variant);
            } else if (key.equalsIgnoreCase("documentTypes")) {
                ReadableArray jsonTypes = options.getArray(key);
                ArrayList<String> types = new ArrayList<String>();
                if (jsonTypes != null) {
                    int len = jsonTypes.size();
                    for (int i=0;i<len;i++){
                        types.add(jsonTypes.getString(i));
                    }
                }

                ArrayList<NVDocumentType> documentTypes = new ArrayList<NVDocumentType>();
                for (String type : types) {
                    if (type.toLowerCase().equals("passport")) {
                        documentTypes.add(NVDocumentType.PASSPORT);
                    } else if (type.toLowerCase().equals("driver_license")) {
                        documentTypes.add(NVDocumentType.DRIVER_LICENSE);
                    } else if (type.toLowerCase().equals("identity_card")) {
                        documentTypes.add(NVDocumentType.IDENTITY_CARD);
                    } else if (type.toLowerCase().equals("visa")) {
                        documentTypes.add(NVDocumentType.VISA);
                    }
                }

                netverifySDK.setPreselectedDocumentTypes(documentTypes);
            }
        }
    }

    @ReactMethod
    public void startNetverify() {
        if (netverifySDK == null) {
            showErrorMessage("The Netverify SDK is not initialized yet. Call initNetverify() first.");
            return;
        }

        try {
            checkPermissionsAndStart(netverifySDK);
        } catch (Exception e) {
            showErrorMessage("Error starting the Netverify SDK: " + e.getLocalizedMessage());
        }
    }

    @ReactMethod
    public void enableEMRTD() {
        if (netverifySDK == null) {
            showErrorMessage("The Netverify SDK is not initialized yet. Call initNetverify() first.");
            return;
        }
        netverifySDK.setEnableEMRTD(true);
    }

    // Permissions

    private void checkPermissionsAndStart(MobileSDK sdk) {
        if (!MobileSDK.hasAllRequiredPermissions(getReactApplicationContext())) {
            //Acquire missing permissions.
            String[] mp = MobileSDK.getMissingPermissions(getReactApplicationContext());

            int code;
            if (sdk instanceof NetverifySDK)
                code = PERMISSION_REQUEST_CODE_NETVERIFY;
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

