package com.jumio.react;

import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.jumio.MobileSDK;
import com.jumio.bam.BamSDK;
import com.jumio.core.exceptions.MissingPermissionException;
import com.jumio.dv.DocumentVerificationSDK;
import com.jumio.nv.NetverifySDK;

import org.jetbrains.annotations.NotNull;

import java.util.Objects;

import androidx.core.app.ActivityCompat;

public class JumioBaseModule extends ReactContextBaseJavaModule {

	public static final int PERMISSION_REQUEST_CODE_BAM = 300;
	public static final int PERMISSION_REQUEST_CODE_NETVERIFY = 301;
	public static final int PERMISSION_REQUEST_CODE_AUTHENTICATION = 302;
	public static final int PERMISSION_REQUEST_CODE_DOCUMENT_VERIFICATION = 303;

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
		return "JumioBaseModule";
	}

	@Override
	public boolean canOverrideExistingModule() {
		return true;
	}


	// Permissions

	protected boolean checkPermissionsAndStart(MobileSDK sdk) {
		if (!MobileSDK.hasAllRequiredPermissions(getReactApplicationContext())) {
			//Acquire missing permissions.
			String[] mp = MobileSDK.getMissingPermissions(getReactApplicationContext());

			int code;
			if (sdk instanceof NetverifySDK) {
				code = PERMISSION_REQUEST_CODE_NETVERIFY;
			} else if (sdk instanceof DocumentVerificationSDK) {
				code = PERMISSION_REQUEST_CODE_DOCUMENT_VERIFICATION;
			} else if (sdk instanceof BamSDK) {
				code = PERMISSION_REQUEST_CODE_BAM;
			} else {
				showErrorMessage("Invalid SDK instance");
				return false;
			}

			ActivityCompat.requestPermissions(Objects.requireNonNull(getReactApplicationContext().getCurrentActivity()), mp, code);
			//The result is received in MainActivity::onRequestPermissionsResult.
			return false;
		} else {
			startSdk(sdk);
			return true;
		}
	}

	// Permissions

	protected boolean checkAndRequestPermissions() {
		if (!MobileSDK.hasAllRequiredPermissions(getReactApplicationContext())) {
			//Acquire missing permissions.
			String[] mp = MobileSDK.getMissingPermissions(getReactApplicationContext());
			ActivityCompat.requestPermissions(getReactApplicationContext().getCurrentActivity(), mp, PERMISSION_REQUEST_CODE_AUTHENTICATION);
			return false;
		} else {
			return true;
		}
	}

	protected void startSdk(MobileSDK sdk) {
		try {
			sdk.start();
		} catch (MissingPermissionException e) {
			showErrorMessage(e.getLocalizedMessage());
		}
	}

	protected void sendErrorObject(String errorCode, String errorMsg) {
		WritableMap errorResult = Arguments.createMap();
		errorResult.putString("errorCode", errorCode != null ? errorCode : "");
		errorResult.putString("errorMessage", errorMsg != null ? errorMsg : "");
		sendEvent(getErrorKey(), errorResult);
	}

	protected void sendErrorObject(String errorCode, String errorMsg, String scanReference) {
		WritableMap errorResult = Arguments.createMap();
		errorResult.putString("errorCode", errorCode != null ? errorCode : "");
		errorResult.putString("errorMessage", errorMsg != null ? errorMsg : "");
		if(scanReference != null) {
			errorResult.putString("scanReference", scanReference != null ? scanReference : "");
		}
		sendEvent(getErrorKey(), errorResult);
	}

	protected void sendErrorObjectWithArray(String errorCode, String errorMsg, WritableArray array) {
		WritableMap errorResult = Arguments.createMap();
		errorResult.putString("errorCode", errorCode != null ? errorCode : "");
		errorResult.putString("errorMessage", errorMsg != null ? errorMsg : "");
		if (array != null) {
			errorResult.putArray("scanReferences", array);
		} else {
			errorResult.putString("scanReferences", "");
		}
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
