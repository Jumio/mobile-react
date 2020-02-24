/*
 * Copyright 2017 Jumio Corporation
 * All rights reserved
 */

package com.jumio.react;

import android.app.Activity;
import android.content.Intent;
import android.os.Build;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.WritableMap;
import com.jumio.auth.AuthenticationCallback;
import com.jumio.auth.AuthenticationResult;
import com.jumio.auth.AuthenticationSDK;
import com.jumio.core.enums.JumioDataCenter;

import org.jetbrains.annotations.NotNull;

public class JumioModuleAuthentication extends JumioBaseModule {

    private final static String TAG = "JumioMobileSDKAuthentication";
	private final String ERROR_KEY = "EventErrorAuthentication";

	public static AuthenticationSDK authenticationSDK;
	public boolean initiateSuccessful = false;

	JumioModuleAuthentication(ReactApplicationContext context) {
		super(context);
	}

    @NotNull
    @Override
    public String getName() {
        return "JumioMobileSDKAuthentication";
    }

	@Override
	public String getErrorKey() {
		return ERROR_KEY;
	}

	private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {
		@Override
		public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
			if (requestCode == AuthenticationSDK.REQUEST_CODE) {
				if (data == null) {
					return;
				}
				String transactionReference = data.getStringExtra(AuthenticationSDK.EXTRA_TRANSACTION_REFERENCE) != null ? data.getStringExtra(AuthenticationSDK.EXTRA_TRANSACTION_REFERENCE) : "";
				if (resultCode == Activity.RESULT_OK) {
					AuthenticationResult authenticationResult = (AuthenticationResult) data.getSerializableExtra(AuthenticationSDK.EXTRA_SCAN_DATA);
					WritableMap result = Arguments.createMap();
					result.putString("authenticationResult", authenticationResult.toString());
					result.putString("transactionReference", transactionReference);

					sendEvent("EventAuthentication", result);
				} else if (resultCode == Activity.RESULT_CANCELED) {
					String errorMessage = data.getStringExtra(AuthenticationSDK.EXTRA_ERROR_MESSAGE);
					String errorCode = data.getStringExtra(AuthenticationSDK.EXTRA_ERROR_CODE);
					sendErrorObject(errorCode, errorMessage, transactionReference);
				}
				if (JumioModuleAuthentication.authenticationSDK != null) {
					JumioModuleAuthentication.authenticationSDK.destroy();
				}
				reactContext.removeActivityEventListener(mActivityEventListener);
			}
		}
	};
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

            JumioDataCenter center = null;
            try {
                center = JumioDataCenter.valueOf(dataCenter.toUpperCase());
            } catch (Exception e) {
                throw new Exception("Datacenter not valid: "+dataCenter);            
            }
            authenticationSDK = AuthenticationSDK.create(getCurrentActivity(), apiToken, apiSecret, center);

            this.configureAuthentication(options);
        } catch (Exception e) {
            showErrorMessage("Error initializing the Authentication SDK: " + e.getLocalizedMessage());
        }
    }

    private void configureAuthentication(ReadableMap options) {
        ReadableMapKeySetIterator keys = options.keySetIterator();
        String enrollmentTransactionReference = null;
        String authenticationTransactionReference = null;
        while (keys.hasNextKey()){
            String key = keys.nextKey();
            if (key.equalsIgnoreCase("userReference")){
                authenticationSDK.setUserReference(options.getString(key));
            }else if (key.equalsIgnoreCase("enrollmentTransactionReference")){
                enrollmentTransactionReference = options.getString(key);
            }else if (key.equalsIgnoreCase("authenticationTransactionReference")){
                authenticationTransactionReference = options.getString(key);
            }else if (key.equalsIgnoreCase("callbackUrl")) {
            	authenticationSDK.setCallbackUrl(options.getString(key));
            }
        }
        try{
	        checkAndRequestPermissions();
            if (enrollmentTransactionReference != null || authenticationTransactionReference != null){
                if (authenticationTransactionReference != null) {
                    authenticationSDK.setAuthenticationTransactionReference(authenticationTransactionReference);
                } else {
                    authenticationSDK.setEnrollmentTransactionReference(enrollmentTransactionReference);
                }

                authenticationSDK.initiate(new AuthenticationCallback(){
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
        	boolean sdkStarted = checkPermissionsAndStart(authenticationSDK);
        	if(sdkStarted){
		        reactContext.addActivityEventListener(mActivityEventListener);
	        }
        } catch (Exception e) {
            showErrorMessage("Error starting the Authentication SDK: " + e.getLocalizedMessage());
        }
    }

    private void sendInitiateSuccessObject(){
    	WritableMap initiateSuccess = Arguments.createMap();
    	sendEvent("EventInitiateSuccess", initiateSuccess);
    }
}

