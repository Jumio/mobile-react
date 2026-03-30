package com.jumio.react

import android.util.Log
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.WritableMap
import com.facebook.react.modules.core.DeviceEventManagerModule.RCTDeviceEventEmitter
import com.jumio.sdk.result.JumioResult

/*
* Copyright (c) 2022. Jumio Corporation All rights reserved.
*/
abstract class JumioBaseModule(context: ReactApplicationContext) : ReactContextBaseJavaModule(context) {
    companion object {
        const val PERMISSION_REQUEST_CODE = 303
        const val ERROR_KEY = "EventError"
        const val RESULT_KEY = "EventResult"

        var pendingResult: JumioResult? = null
        var pendingErrorCode: String? = null
        var pendingErrorMsg: String? = null
    }

    val reactContext = context

    override fun getName() = "JumioMobileSDK"

    override fun canOverrideExistingModule() = true

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