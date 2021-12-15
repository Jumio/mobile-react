/*
 * Copyright (c) 2021. Jumio Corporation All rights reserved.
 */

package com.jumio.react;

import android.app.Activity;
import android.content.Intent;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.jumio.defaultui.JumioActivity;
import com.jumio.sdk.credentials.JumioCredentialInfo;
import com.jumio.sdk.result.JumioCredentialResult;
import com.jumio.sdk.result.JumioFaceResult;
import com.jumio.sdk.result.JumioIDResult;
import com.jumio.sdk.result.JumioResult;

import java.util.List;

public class JumioModule extends JumioBaseModule {

    private final static String TAG = "JumioMobileSDK";
    private final static int REQUEST_CODE = 101;

    private final String ERROR_KEY = "EventError";

    JumioModule(ReactApplicationContext context) {
        super(context);
        // Add the listener for `onActivityResult`
    }

    @Override
    public String getErrorKey() {
        return ERROR_KEY;
    }

    private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {
        @Override
        public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
            if (requestCode == REQUEST_CODE) {
                if (data == null) {
                    return;
                }

                final JumioResult jumioResult = (JumioResult) data.getSerializableExtra(JumioActivity.EXTRA_RESULT);

                if (jumioResult != null && jumioResult.isSuccess()) {
                    sendScanResult(jumioResult);
                } else {
                    sendCancelResult(jumioResult);
                }
                reactContext.removeActivityEventListener(mActivityEventListener);
            }
        }
    };

    @ReactMethod
    public void initialize(String authorizationToken, String dataCenter) {
        try {
            if (authorizationToken.isEmpty() || dataCenter.isEmpty()) {
                showErrorMessage("Missing required parameters one-time session authorization token, or dataCenter.");
                return;
            }

            final Intent intent = new Intent(getCurrentActivity(), JumioActivity.class);
            intent.putExtra(JumioActivity.EXTRA_TOKEN, authorizationToken);
            intent.putExtra(JumioActivity.EXTRA_DATACENTER, dataCenter);

//            The following intent extra can be used to customize the Theme of Default UI
//            intent.putExtra(JumioActivity.EXTRA_CUSTOM_THEME, R.style.AppThemeCustomJumio);

            getCurrentActivity().startActivityForResult(intent, REQUEST_CODE);

        } catch (Exception e) {
            showErrorMessage("Error initializing the Jumio SDK: " + e.getLocalizedMessage());
        }
    }

    @ReactMethod
    public void start() {
        try {
            boolean sdkStarted = checkPermissionsAndStart();
            if (sdkStarted) {
                reactContext.addActivityEventListener(mActivityEventListener);
            }
        } catch (Exception e) {
            showErrorMessage("Error starting the Jumio SDK: " + e.getLocalizedMessage());
        }
    }

    private void sendScanResult(final JumioResult jumioResult) {
        final String accountId = jumioResult.getAccountId();
        final List<JumioCredentialInfo> credentialInfoList = jumioResult.getCredentialInfos();

        final WritableMap result = Arguments.createMap();
        final WritableArray credentialsArray = Arguments.createArray();

        if (credentialInfoList != null) {
            if (accountId != null) {
                result.putString("accountId", accountId);
            }
            for (JumioCredentialInfo credentialInfo : credentialInfoList) {
                final JumioCredentialResult jumioCredentialResult = jumioResult.getResult(credentialInfo);
                final WritableMap credentialMap = Arguments.createMap();

                credentialMap.putString("credentialId", credentialInfo.getId());
                credentialMap.putString("credentialCategory", credentialInfo.getCategory().toString());

                if (jumioCredentialResult instanceof JumioIDResult) {
                    final JumioIDResult idResult = (JumioIDResult) jumioCredentialResult;
                    credentialMap.putString("selectedCountry", idResult.getCountry());
                    credentialMap.putString("selectedDocumentType", idResult.getIdType());
                    credentialMap.putString("idNumber", idResult.getDocumentNumber());
                    credentialMap.putString("personalNumber", idResult.getPersonalNumber());
                    credentialMap.putString("issuingDate", idResult.getIssuingDate());
                    credentialMap.putString("expiryDate", idResult.getExpiryDate());
                    credentialMap.putString("issuingCountry", idResult.getIssuingCountry());
                    credentialMap.putString("lastName", idResult.getLastName());
                    credentialMap.putString("firstName", idResult.getFirstName());
                    credentialMap.putString("gender", idResult.getGender());
                    credentialMap.putString("nationality", idResult.getNationality());
                    credentialMap.putString("dateOfBirth", idResult.getDateOfBirth());

                    credentialMap.putString("addressLine", idResult.getAddress());
                    credentialMap.putString("city", idResult.getCity());
                    credentialMap.putString("subdivision", idResult.getSubdivision());
                    credentialMap.putString("postCode", idResult.getPostalCode());
                    credentialMap.putString("placeOfBirth", idResult.getPlaceOfBirth());

                    credentialMap.putString("mrzLine1", idResult.getMrzLine1());
                    credentialMap.putString("mrzLine2", idResult.getMrzLine2());
                    credentialMap.putString("mrzLine3", idResult.getMrzLine3());
                } else if (jumioCredentialResult instanceof JumioFaceResult) {
                    //lowercase
                    credentialMap.putString("passed", String.valueOf(((JumioFaceResult) jumioCredentialResult).getPassed()));
                }
                credentialsArray.pushMap(credentialMap);
            }
            result.putArray("credentials", credentialsArray);
        }
        sendEvent("EventResult", result);
    }

    private void sendCancelResult(final JumioResult jumioResult) {
        if (jumioResult != null && jumioResult.getError() != null) {
            String errorMessage = jumioResult.getError().getMessage();
            String errorCode = jumioResult.getError().getCode();
            sendErrorObject(errorCode, errorMessage);
        } else {
            showErrorMessage("There was a problem extracting the scan result");
        }
    }
}

