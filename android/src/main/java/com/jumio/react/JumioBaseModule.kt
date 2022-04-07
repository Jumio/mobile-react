package com.jumio.react

import android.util.Log
import androidx.core.app.ActivityCompat
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.WritableMap
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter
import com.jumio.sdk.JumioSDK

/*
* Copyright (c) 2022. Jumio Corporation All rights reserved.
*/
abstract class JumioBaseModule(context: ReactApplicationContext) : ReactContextBaseJavaModule(context) {
    companion object {
        private const val PERMISSION_REQUEST_CODE = 303
        private const val ERROR_KEY = "EventError"
    }

    val reactContext = context

    override fun getName() = "JumioMobileSDK"

    override fun canOverrideExistingModule() = true

    // Permissions
    fun checkPermissionsAndStart() =
        if (!JumioSDK.hasAllRequiredPermissions(reactContext)) {
            //Acquire missing permissions.
            val mp = JumioSDK.getMissingPermissions(reactContext)
            ActivityCompat.requestPermissions(reactContext.currentActivity!!, mp, PERMISSION_REQUEST_CODE)
            //The result is received in MainActivity::onRequestPermissionsResult.
            false
        } else {
            true
        }

    fun sendErrorObject(errorCode: String?, errorMsg: String?) {
        val errorResult = Arguments.createMap().apply {
            putString("errorCode", errorCode ?: "")
            putString("errorMessage", errorMsg ?: "")
        }
        sendEvent(ERROR_KEY, errorResult)
    }

    fun showErrorMessage(msg: String?) {
        Log.e("Error", msg ?: "")
        val errorResult = Arguments.createMap().apply {
            putString("errorMessage", msg ?: "")
        }
        sendEvent(ERROR_KEY, errorResult)
    }

    fun sendEvent(eventName: String, params: WritableMap) =
        reactApplicationContext.getJSModule(RCTDeviceEventEmitter::class.java)
            .emit(eventName, params)
}