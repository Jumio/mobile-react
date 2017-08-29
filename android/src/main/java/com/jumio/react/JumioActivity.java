/*
 * Copyright 2017 Jumio Corporation
 * All rights reserved
 */

package com.jumio.react;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.support.annotation.NonNull;
import android.util.Log;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import com.facebook.react.ReactActivity;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.jumio.MobileSDK;
import com.jumio.bam.BamCardInformation;
import com.jumio.bam.BamSDK;
import com.jumio.core.exceptions.MissingPermissionException;
import com.jumio.dv.DocumentVerificationSDK;
import com.jumio.nv.NetverifyDocumentData;
import com.jumio.nv.NetverifySDK;
import com.jumio.nv.enums.EMRTDStatus;

public class JumioActivity extends ReactActivity {
    
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        boolean allGranted = true;
        for (int grantResult : grantResults) {
            if (grantResult != PackageManager.PERMISSION_GRANTED) {
                allGranted = false;
                break;
            }
        }
        
        if (allGranted) {
            if (requestCode == JumioModule.PERMISSION_REQUEST_CODE_BAM) {
                startSdk(JumioModule.bamSDK);
            } else if (requestCode == JumioModule.PERMISSION_REQUEST_CODE_NETVERIFY) {
                startSdk(JumioModule.netverifySDK);
            } else if (requestCode == JumioModule.PERMISSION_REQUEST_CODE_DOCUMENT_VERIFICATION) {
                startSdk(JumioModule.documentVerificationSDK);
            }
        } else {
            Toast.makeText(this, "You need to grant all required permissions to start the Jumio SDK", Toast.LENGTH_LONG).show();
            super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }
    
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == BamSDK.REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                BamCardInformation cardInformation = data.getParcelableExtra(BamSDK.EXTRA_CARD_INFORMATION);
                JSONObject result = new JSONObject();
                try {
                    result.put("cardType", cardInformation.getCardType());
                    result.put("cardNumber", String.valueOf(cardInformation.getCardNumber()));
                    result.put("cardNumberGrouped", String.valueOf(cardInformation.getCardNumberGrouped()));
                    result.put("cardNumberMasked", String.valueOf(cardInformation.getCardNumberMasked()));
                    result.put("cardExpiryMonth", String.valueOf(cardInformation.getCardExpiryDateMonth()));
                    result.put("cardExpiryYear", String.valueOf(cardInformation.getCardExpiryDateYear()));
                    result.put("cardExpiryDate", String.valueOf(cardInformation.getCardExpiryDateYear()));
                    result.put("cardCVV", String.valueOf(cardInformation.getCardCvvCode()));
                    result.put("cardHolderName", String.valueOf(cardInformation.getCardHolderName()));
                    result.put("cardSortCode", String.valueOf(cardInformation.getCardSortCode()));
                    result.put("cardAccountNumber", String.valueOf(cardInformation.getCardAccountNumber()));
                    result.put("cardSortCodeValid", cardInformation.isCardSortCodeValid());
                    result.put("cardAccountNumberValid", cardInformation.isCardAccountNumberValid());
                    
                    sendEvent(this.getReactInstanceManager().getCurrentReactContext(), "EventCardInformation", result);
                    cardInformation.clear();
                } catch (JSONException e) {
                    showErrorMessage("Result could not be sent. Try again.");
                }
            } else if (resultCode == Activity.RESULT_CANCELED) {
                String errorMessage = data.getStringExtra(BamSDK.EXTRA_ERROR_MESSAGE);
                showErrorMessage(errorMessage);
            }
        } else if (requestCode == NetverifySDK.REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                NetverifyDocumentData documentData = (NetverifyDocumentData) data.getParcelableExtra(NetverifySDK.EXTRA_SCAN_DATA);
                JSONObject result = new JSONObject();
                try {
                    result.put("selectedCountry", documentData.getSelectedCountry());
                    result.put("selectedDocumentType", documentData.getSelectedDocumentType());
                    result.put("idNumber", documentData.getIdNumber());
                    result.put("personalNumber", documentData.getPersonalNumber());
                    result.put("issuingDate", documentData.getIssuingDate());
                    result.put("expiryDate", documentData.getExpiryDate());
                    result.put("issuingCountry", documentData.getIssuingCountry());
                    result.put("lastName", documentData.getLastName());
                    result.put("firstName", documentData.getFirstName());
                    result.put("middleName", documentData.getMiddleName());
                    result.put("dob", documentData.getDob());
                    result.put("gender", documentData.getGender());
                    result.put("originatingCountry", documentData.getOriginatingCountry());
                    result.put("addressLine", documentData.getAddressLine());
                    result.put("city", documentData.getCity());
                    result.put("subdivision", documentData.getSubdivision());
                    result.put("postCode", documentData.getPostCode());
                    result.put("optionalData1", documentData.getOptionalData1());
                    result.put("optionalData2", documentData.getOptionalData2());
                    result.put("placeOfBirth", documentData.getPlaceOfBirth());
                    result.put("extractionMethod", documentData.getExtractionMethod());
                    
                    // MRZ data if available
                    if (documentData.getMrzData() != null) {
                        JSONObject mrzData = new JSONObject();
                        mrzData.put("format", documentData.getMrzData().getFormat());
                        mrzData.put("line1", documentData.getMrzData().getMrzLine1());
                        mrzData.put("line2", documentData.getMrzData().getMrzLine2());
                        mrzData.put("line3", documentData.getMrzData().getMrzLine3());
                        mrzData.put("idNumberValid", documentData.getMrzData().idNumberValid());
                        mrzData.put("dobValid", documentData.getMrzData().dobValid());
                        mrzData.put("expiryDateValid", documentData.getMrzData().expiryDateValid());
                        mrzData.put("personalNumberValid", documentData.getMrzData().personalNumberValid());
                        mrzData.put("compositeValid", documentData.getMrzData().compositeValid());
                        result.put("mrzData", mrzData);
                    }
                    
                    // EMRTD data if available
                    if (documentData.getEMRTDStatus() != null) {
                        result.put("emrtdStatus", documentData.getEMRTDStatus());
                    }
                    
                    sendEvent(this.getReactInstanceManager().getCurrentReactContext(), "EventDocumentData", result);
                } catch (JSONException e) {
                    showErrorMessage("Result could not be sent. Try again.");
                }
            } else if (resultCode == Activity.RESULT_CANCELED) {
                String errorMessage = data.getStringExtra(NetverifySDK.EXTRA_ERROR_MESSAGE);
                showErrorMessage(errorMessage);
            }
        } else if (requestCode == DocumentVerificationSDK.REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                this.getReactInstanceManager().getCurrentReactContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("EventDocumentVerification", "Document-Verification finished successfully.");
            } else if (resultCode == Activity.RESULT_CANCELED) {
                String errorMessage = data.getStringExtra(DocumentVerificationSDK.EXTRA_ERROR_MESSAGE);
                showErrorMessage(errorMessage);
            }
        }
    }
    
    // Helper methods
    
    private void sendEvent(ReactContext reactContext, String eventName, JSONObject params) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
        .emit(eventName, params.toString());
    }
    
    public void startSdk(MobileSDK sdk) {
        try {
            sdk.start();
        } catch (MissingPermissionException e) {
            showErrorMessage(e.getLocalizedMessage());
        }
    }
    
    private void showErrorMessage(String msg) {
        Log.e("Error", msg);
        getReactInstanceManager().getCurrentReactContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("EventError", msg);
    }
}
