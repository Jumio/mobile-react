/*
 * Copyright (c) 2021. Jumio Corporation All rights reserved.
 */

package com.jumio.react;

import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.jumio.sdk.JumioSDK;

import org.jetbrains.annotations.NotNull;

import java.util.Objects;

import androidx.core.app.ActivityCompat;

public class JumioBaseModule extends ReactContextBaseJavaModule {

	public static final int PERMISSION_REQUEST_CODE = 303;

	protected static ReactApplicationContext reactContext;

	JumioBaseModule(ReactApplicationContext context) {
		super(context);
		reactContext = context;
	}

	public String getErrorKey() {
		return "EventError";
	}

	@NotNull
	@Override
	public String getName() {
		return "JumioMobileSDK";
	}

	@Override
	public boolean canOverrideExistingModule() {
		return true;
	}

	// Permissions
	protected boolean checkPermissionsAndStart() {
		if (!JumioSDK.hasAllRequiredPermissions(getReactApplicationContext())) {
			//Acquire missing permissions.
			String[] mp = JumioSDK.getMissingPermissions(getReactApplicationContext());

			ActivityCompat.requestPermissions(Objects.requireNonNull(getReactApplicationContext().getCurrentActivity()), mp, PERMISSION_REQUEST_CODE);
			//The result is received in MainActivity::onRequestPermissionsResult.
			return false;
		} else {
			return true;
		}
	}

	protected void sendErrorObject(String errorCode, String errorMsg) {
		WritableMap errorResult = Arguments.createMap();
		errorResult.putString("errorCode", errorCode != null ? errorCode : "");
		errorResult.putString("errorMessage", errorMsg != null ? errorMsg : "");
		sendEvent(getErrorKey(), errorResult);
	}

	protected void showErrorMessage(String msg) {
		Log.e("Error", msg);
		WritableMap errorResult = Arguments.createMap();
		errorResult.putString("errorMessage", msg != null ? msg : "");
		sendEvent(getErrorKey(), errorResult);
	}

	protected void sendEvent(String eventName, WritableMap params) {
		getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
			.emit(eventName, params);
	}
}
