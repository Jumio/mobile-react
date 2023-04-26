package com.jumio.react

import android.app.Activity
import android.content.Intent
import android.os.Build
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.BaseActivityEventListener
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableMap
import com.jumio.defaultui.JumioActivity
import com.jumio.sdk.JumioSDK
import com.jumio.sdk.credentials.JumioCredentialCategory.FACE
import com.jumio.sdk.credentials.JumioCredentialCategory.ID
import com.jumio.sdk.enums.JumioDataCenter
import com.jumio.sdk.result.JumioIDResult
import com.jumio.sdk.result.JumioResult

/*
* Copyright (c) 2022. Jumio Corporation All rights reserved.
*/

class JumioModule(context: ReactApplicationContext) : JumioBaseModule(context) {
    companion object {
        private const val REQUEST_CODE = 101
    }

    private val mActivityEventListener =
        object : BaseActivityEventListener() {
            override fun onActivityResult(activity: Activity?, requestCode: Int, resultCode: Int, data: Intent?) {
                if (requestCode == REQUEST_CODE) {
                    data?.let {
                        val jumioResult = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                            it.getSerializableExtra(JumioActivity.EXTRA_RESULT, JumioResult::class.java)
                        } else {
                            @Suppress("DEPRECATION")
                            it.getSerializableExtra(JumioActivity.EXTRA_RESULT) as JumioResult?
                        }

                        if (jumioResult?.isSuccess == true) sendScanResult(jumioResult) else sendCancelResult(jumioResult)

                        reactContext.removeActivityEventListener(this)
                    }
                }
            }
        }

    @ReactMethod
    fun isRooted(promise: Promise) = promise.resolve(JumioSDK.isRooted(reactContext))

    @ReactMethod
    fun initialize(authorizationToken: String, dataCenter: String) {
        val hasPermissions = checkPermissions()
        val jumioDataCenter = getJumioDataCenter(dataCenter)

        when {
            !hasPermissions -> showErrorMessage("Missing required app permissions.")
            jumioDataCenter == null -> showErrorMessage("Invalid Datacenter value.")
            authorizationToken.isEmpty() -> showErrorMessage("Missing required parameters one-time session authorization token.")
            else -> {
                try {
                    initSdk(dataCenter, authorizationToken)
                } catch (e: Exception) {
                    showErrorMessage("Error initializing the Jumio SDK: " + e.localizedMessage)
                }
            }
        }
    }

    @ReactMethod
    fun setupCustomizations(customizations: ReadableMap?) {
    }

    @ReactMethod
    fun start() {
        try {
            reactContext.addActivityEventListener(mActivityEventListener)
        } catch (e: Exception) {
            showErrorMessage("Error starting the Jumio SDK: " + e.localizedMessage)
        }
    }

    private fun initSdk(dataCenter: String, authorizationToken: String) {
        val intent = Intent(currentActivity, JumioActivity::class.java).apply {
            putExtra(JumioActivity.EXTRA_TOKEN, authorizationToken)
            putExtra(JumioActivity.EXTRA_DATACENTER, dataCenter)

            //The following intent extra can be used to customize the Theme of Default UI
            putExtra(JumioActivity.EXTRA_CUSTOM_THEME, R.style.AppThemeCustomJumio)
        }
        currentActivity?.startActivityForResult(intent, REQUEST_CODE)
    }

    private fun sendScanResult(jumioResult: JumioResult?) {
        val accountId = jumioResult?.accountId
        val workflowId = jumioResult?.workflowExecutionId
        val credentialInfoList = jumioResult?.credentialInfos

        val result = Arguments.createMap()
        val credentialArray = Arguments.createArray()

        credentialInfoList?.let {
            accountId?.let { result.putString("accountId", it) }
            workflowId?.let { result.putString("workflowId", it) }

            credentialInfoList.forEach {
                val eventResultMap = Arguments.createMap().apply {
                    putString("credentialId", it.id)
                    putString("credentialCategory", it.category.toString())
                }
                when (it.category) {
                    ID -> {
                        val idResult = jumioResult.getIDResult(it)

                        idResult?.let { handleIdResult(idResult, eventResultMap) }
                    }
                    FACE -> {
                        val faceResult = jumioResult.getFaceResult(it)

                        faceResult?.passed?.let { passed -> eventResultMap.putString("passed", passed.toString()) }
                    }
                    else -> {}
                }
                credentialArray.pushMap(eventResultMap)
            }
            result.putArray("credentials", credentialArray)
        }
        sendEvent("EventResult", result)
    }

    private fun handleIdResult(idResult: JumioIDResult, eventResultMap: WritableMap) =
        with(idResult) {
            eventResultMap.apply {
                country?.let { putString("selectedCountry", it) }
                idType?.let { putString("selectedDocumentType", it) }
                documentNumber?.let { putString("idNumber", it) }
                personalNumber?.let { putString("personalNumber", it) }
                issuingDate?.let { putString("issuingDate", it) }
                expiryDate?.let { putString("expiryDate", it) }
                issuingCountry?.let { putString("issuingCountry", it) }
                lastName?.let { putString("lastName", it) }
                firstName?.let { putString("firstName", it) }
                gender?.let { putString("gender", it) }
                nationality?.let { putString("nationality", it) }
                dateOfBirth?.let { putString("dateOfBirth", it) }
                address?.let { putString("addressLine", it) }
                city?.let { putString("city", it) }
                subdivision?.let { putString("subdivision", it) }
                postalCode?.let { putString("postCode", it) }
                placeOfBirth?.let { putString("placeOfBirth", it) }
                mrzLine1?.let { putString("mrzLine1", it) }
                mrzLine2?.let { putString("mrzLine2", it) }
                mrzLine3?.let { putString("mrzLine3", it) }
            }
        }

    private fun sendCancelResult(jumioResult: JumioResult?) =
        if (jumioResult?.error != null) {
            val errorMessage = jumioResult.error!!.message
            val errorCode = jumioResult.error!!.code
            sendErrorObject(errorCode, errorMessage)
        } else {
            showErrorMessage("There was a problem extracting the scan result")
        }

    private fun getJumioDataCenter(dataCenter: String) = try {
        JumioDataCenter.valueOf(dataCenter)
    } catch (e: IllegalArgumentException) {
        null
    }
}