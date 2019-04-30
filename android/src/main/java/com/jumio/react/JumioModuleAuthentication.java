/*
 * Copyright 2017 Jumio Corporation
 * All rights reserved
 */

package com.jumio.react;

import android.os.Build;
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
import com.jumio.auth.AuthenticationCallback;
import com.jumio.auth.AuthenticationSDK;
import com.jumio.core.enums.JumioDataCenter;
import com.jumio.core.exceptions.MissingPermissionException;

import androidx.core.app.ActivityCompat;

public class JumioModuleAuthentication extends ReactContextBaseJavaModule {

    private final static String TAG = "JumioMobileSDKAuthentication";
    public static final int PERMISSION_REQUEST_CODE_AUTHENTICATION = 302;

	public static AuthenticationSDK authenticationSDK;
	public boolean initiateSuccessful = false;

    JumioModuleAuthentication(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "JumioMobileSDKAuthentication";
    }

    @Override
    public boolean canOverrideExistingModule() {
        return true;
    }

    @ReactMethod
    public void initAuthentication(String apiToken, String apiSecret, String dataCenter, ReadableMap options) {
        if (!AuthenticationSDK.isSupportedPlatform(this.getCurrentActivity())) {
            showErrorMessage("This platform is not supported.");
            return;
        }

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.GINGERBREAD){
                if (apiToken.isEmpty() || apiSecret.isEmpty() || dataCenter.isEmpty()) {
                    showErrorMessage("Missing required parameters apiToken, apiSecret or dataCenter.");
                    return;
                }
            }

            JumioDataCenter center = (dataCenter.equalsIgnoreCase("eu")) ? JumioDataCenter.EU : JumioDataCenter.US;
            authenticationSDK = AuthenticationSDK.create(getCurrentActivity(), apiToken, apiSecret, center);

            this.configureAuthentication(options);
        } catch (Exception e) {
            showErrorMessage("Error initializing the Authentication SDK: " + e.getLocalizedMessage());
        }
    }

    private void configureAuthentication(ReadableMap options) {
        ReadableMapKeySetIterator keys = options.keySetIterator();
        String enrollmentTransactionReference = null;
        while (keys.hasNextKey()){
            String key = keys.nextKey();
            if (key.equalsIgnoreCase("userReference")){
                authenticationSDK.setUserReference(options.getString(key));
            }else if (key.equalsIgnoreCase("enrollmentTransactionReference")){
                enrollmentTransactionReference = options.getString(key);
            }else if (key.equalsIgnoreCase("callbackUrl")) {
            	authenticationSDK.setCallbackUrl(options.getString(key));
            }
        }
        try{
	        checkAndRequestPermissions();
            if (enrollmentTransactionReference != null){
                authenticationSDK.initiate(enrollmentTransactionReference, new AuthenticationCallback(){
                    @Override
                    public void onAuthenticationInitiateSuccess(){
                        initiateSuccessful = true;
	                    sendInitiateSuccessObject();
                    }

                    @Override
                    public void onAuthenticationInitiateError(String errorCode, String errorMessage, boolean retryPossible){
                        initiateSuccessful = false;
                        sendErrorObject(errorCode, errorMessage);
                    }
                });
            }

        }catch (Exception e) {
            showErrorMessage("Error during initializing the Authentication SDK");
        }

    }

	@ReactMethod
    public void startAuthentication() {
        if (authenticationSDK == null || !initiateSuccessful) {
            showErrorMessage("The Authentication SDK has not been initialized yet.");
            return;
        }

        try {
        	checkPermissionsAndStart(authenticationSDK);
        } catch (Exception e) {
            showErrorMessage("Error starting the Authentication SDK: " + e.getLocalizedMessage());
        }
    }

    // Permissions

	private boolean checkAndRequestPermissions() {
    	if (!MobileSDK.hasAllRequiredPermissions(getReactApplicationContext())){
				//Acquire missing permissions.
		    String[] mp = MobileSDK.getMissingPermissions(getReactApplicationContext());
		    ActivityCompat.requestPermissions(getReactApplicationContext().getCurrentActivity(), mp, PERMISSION_REQUEST_CODE_AUTHENTICATION);
		    return false;
    	} else {
    		return true;
	    }
	}

    private void checkPermissionsAndStart(MobileSDK sdk) {
        if (!MobileSDK.hasAllRequiredPermissions(getReactApplicationContext())) {
            //Acquire missing permissions.
            String[] mp = MobileSDK.getMissingPermissions(getReactApplicationContext());

            int code;
            if (sdk instanceof AuthenticationSDK)
                code = PERMISSION_REQUEST_CODE_AUTHENTICATION;
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

	private void startSdk(MobileSDK sdk) {
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

    private void sendErrorObject(String errorCode, String errorMsg) {
        WritableMap errorResult = Arguments.createMap();
        errorResult.putString("errorCode", errorCode != null ? errorCode : "");
        errorResult.putString("errorMessage", errorMsg != null ? errorMsg : "");
        sendEvent("EventError", errorResult);
    }

    private void sendInitiateSuccessObject(){
    	WritableMap initiateSuccess = Arguments.createMap();
    	sendEvent("EventInitiateSuccess", initiateSuccess);
    }

	// Helper methods

	private void sendEvent(String eventName, WritableMap params) {
		getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
				.emit(eventName, params);
	}
}

