/*
 * Copyright 2017 Jumio Corporation
 * All rights reserved
 */

package com.jumio.react;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.support.v4.app.ActivityCompat;
import android.util.Log;
import android.widget.Toast;

import java.util.ArrayList;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.jumio.MobileSDK;
import com.jumio.bam.*;
import com.jumio.bam.enums.CreditCardType;
import com.jumio.core.enums.*;
import com.jumio.core.exceptions.*;
import com.jumio.dv.DocumentVerificationSDK;
import com.jumio.nv.*;
import com.jumio.nv.data.document.NVDocumentType;
import com.jumio.nv.data.document.NVDocumentVariant;

import org.json.JSONException;
import org.json.JSONObject;

public class JumioModule extends ReactContextBaseJavaModule implements ActivityEventListener {
    
    private final static String TAG = "JumioMobileSDK";
    public static final int PERMISSION_REQUEST_CODE_BAM = 300;
    public static final int PERMISSION_REQUEST_CODE_NETVERIFY = 301;
    public static final int PERMISSION_REQUEST_CODE_DOCUMENT_VERIFICATION = 303;
    
    public static NetverifySDK netverifySDK;
    public static BamSDK bamSDK;
    public static DocumentVerificationSDK documentVerificationSDK;
    
    public JumioModule(ReactApplicationContext reactContext) {
        super(reactContext);
        reactContext.addActivityEventListener(this);
    }
    
    @Override
    public String getName() {
        return "JumioMobileSDK";
    }

    protected static void onRequestPermissionsResult(ReactContext reactContext, int requestCode, String[] permissions, int[] grantResults) {
        boolean allGranted = true;
        for (int grantResult : grantResults) {
            if (grantResult != PackageManager.PERMISSION_GRANTED) {
                allGranted = false;
                break;
            }
        }

        if (allGranted) {
            if (requestCode == JumioModule.PERMISSION_REQUEST_CODE_BAM) {
                startSdk(reactContext, JumioModule.bamSDK);
            } else if (requestCode == JumioModule.PERMISSION_REQUEST_CODE_NETVERIFY) {
                startSdk(reactContext, JumioModule.netverifySDK);
            } else if (requestCode == JumioModule.PERMISSION_REQUEST_CODE_DOCUMENT_VERIFICATION) {
                startSdk(reactContext, JumioModule.documentVerificationSDK);
            }
        } else {
            Toast.makeText(reactContext, "You need to grant all required permissions to start the Jumio SDK", Toast.LENGTH_LONG).show();
        }
    }

    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent intent) {
        if (requestCode == BamSDK.REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                BamCardInformation cardInformation = intent.getParcelableExtra(BamSDK.EXTRA_CARD_INFORMATION);
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

                    sendEvent("EventCardInformation", result);
                    cardInformation.clear();
                } catch (JSONException e) {
                    showErrorMessage("Result could not be sent. Try again.");
                }
            } else if (resultCode == Activity.RESULT_CANCELED) {
                String errorMessage = intent.getStringExtra(BamSDK.EXTRA_ERROR_MESSAGE);
                showErrorMessage(errorMessage);
            }
        } else if (requestCode == NetverifySDK.REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                NetverifyDocumentData documentData = (NetverifyDocumentData) intent.getParcelableExtra(NetverifySDK.EXTRA_SCAN_DATA);
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

                    sendEvent("EventDocumentData", result);
                } catch (JSONException e) {
                    showErrorMessage("Result could not be sent. Try again.");
                }
            } else if (resultCode == Activity.RESULT_CANCELED) {
                String errorMessage = intent.getStringExtra(NetverifySDK.EXTRA_ERROR_MESSAGE);
                showErrorMessage(errorMessage);
            }
        } else if (requestCode == DocumentVerificationSDK.REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                sendEvent("EventDocumentVerification", "Document-Verification finished successfully.");
            } else if (resultCode == Activity.RESULT_CANCELED) {
                String errorMessage = intent.getStringExtra(DocumentVerificationSDK.EXTRA_ERROR_MESSAGE);
                showErrorMessage(errorMessage);
            }
        }
    }

    @Override
    public void onNewIntent(Intent intent) {

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
            
            JumioDataCenter center = (dataCenter.equals("eu")) ? JumioDataCenter.EU : JumioDataCenter.US;
            netverifySDK = NetverifySDK.create(getCurrentActivity(), apiToken, apiSecret, center);
            
            this.configureNetverify(options);
        } catch (PlatformNotSupportedException e) {
            showErrorMessage("Error initializing the Netverify SDK: " + e.getLocalizedMessage());
        }
    }
    
    private void configureNetverify(ReadableMap options) {
        ReadableMapKeySetIterator keys = options.keySetIterator();
        while (keys.hasNextKey()) {
            String key = keys.nextKey();
            
            if (key.equals("requireVerification")) {
                netverifySDK.setRequireVerification(options.getBoolean(key));
            } else if (key.equals("callbackUrl")) {
                netverifySDK.setCallbackUrl(options.getString(key));
            } else if (key.equals("requireFaceMatch")) {
                netverifySDK.setRequireFaceMatch(options.getBoolean(key));
            } else if (key.equals("preselectedCountry")) {
                netverifySDK.setPreselectedCountry(options.getString(key));
            } else if (key.equals("merchantScanReference")) {
                netverifySDK.setMerchantScanReference(options.getString(key));
            } else if (key.equals("merchantReportingCriteria")) {
                netverifySDK.setMerchantReportingCriteria(options.getString(key));
            } else if (key.equals("customerID")) {
                netverifySDK.setCustomerId(options.getString(key));
            } else if (key.equals("additionalInformation")) {
                netverifySDK.setAdditionalInformation(options.getString(key));
            } else if (key.equals("enableEpassport")) {
                netverifySDK.setEnableEMRTD(options.getBoolean(key));
            } else if (key.equals("sendDebugInfoToJumio")) {
                netverifySDK.sendDebugInfoToJumio(options.getBoolean(key));
            } else if (key.equals("dataExtractionOnMobileOnly")) {
                netverifySDK.setDataExtractionOnMobileOnly(options.getBoolean(key));
            } else if (key.equals("cameraPosition")) {
                JumioCameraPosition cameraPosition = (options.getString(key).toLowerCase().equals("front")) ? JumioCameraPosition.FRONT : JumioCameraPosition.BACK;
                netverifySDK.setCameraPosition(cameraPosition);
            } else if (key.equals("preselectedDocumentVariant")) {
                NVDocumentVariant variant = (options.getString(key).toLowerCase().equals("paper")) ? NVDocumentVariant.PAPER : NVDocumentVariant.PLASTIC;
                netverifySDK.setPreselectedDocumentVariant(variant);
            } else if (key.equals("documentTypes")) {
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
    
    // Document Verification
    
    @ReactMethod
    public void initDocumentVerification(String apiToken, String apiSecret, String dataCenter, ReadableMap options) {
        if (!DocumentVerificationSDK.isSupportedPlatform(this.getCurrentActivity())) {
            showErrorMessage("This platform is not supported.");
            return;
        }
        
        try {
            if (apiToken.isEmpty() || apiSecret.isEmpty() || dataCenter.isEmpty()) {
                showErrorMessage("Missing required parameters apiToken, apiSecret or dataCenter.");
                return;
            }
            
            JumioDataCenter center = (dataCenter.equals("eu")) ? JumioDataCenter.EU : JumioDataCenter.US;
            documentVerificationSDK = DocumentVerificationSDK.create(getCurrentActivity(), apiToken, apiSecret, center);
            
            // Configuration options
            ReadableMapKeySetIterator keys = options.keySetIterator();
            while (keys.hasNextKey()) {
                String key = keys.nextKey();
                
                if (key.equals("type")) {
                    documentVerificationSDK.setType(options.getString(key));
                } else if (key.equals("customDocumentCode")) {
                    documentVerificationSDK.setCustomDocumentCode(options.getString(key));
                } else if (key.equals("country")) {
                    documentVerificationSDK.setCountry(options.getString(key));
                } else if (key.equals("merchantReportingCriteria")) {
                    documentVerificationSDK.setMerchantReportingCriteria(options.getString(key));
                } else if (key.equals("callbackUrl")) {
                    documentVerificationSDK.setCallbackUrl(options.getString(key));
                } else if (key.equals("additionalInformation")) {
                    documentVerificationSDK.setAdditionalInformation(options.getString(key));
                } else if (key.equals("merchantScanReference")) {
                    documentVerificationSDK.setMerchantScanReference(options.getString(key));
                } else if (key.equals("customerId")) {
                    documentVerificationSDK.setCustomerId(options.getString(key));
                } else if (key.equals("documentName")) {
                    documentVerificationSDK.setDocumentName(options.getString(key));
                } else if (key.equals("cameraPosition")) {
                    JumioCameraPosition cameraPosition = (options.getString(key).toLowerCase().equals("front")) ? JumioCameraPosition.FRONT : JumioCameraPosition.BACK;
                    bamSDK.setCameraPosition(cameraPosition);
                }
            }
        } catch (PlatformNotSupportedException e) {
            showErrorMessage("Error initializing the Document Verification SDK: " + e.getLocalizedMessage());
        }
    }
    
    @ReactMethod
    public void startDocumentVerification() {
        if (documentVerificationSDK == null) {
            showErrorMessage("The Document Verification SDK is not initialized yet. Call initDocumentVerification() first.");
            return;
        }
        
        try {
            checkPermissionsAndStart(documentVerificationSDK);
        } catch (Exception e) {
            showErrorMessage("Error starting the Document Verification SDK: " + e.getLocalizedMessage());
        }
    }
    
    // BAM Checkout
    
    @ReactMethod
    public void initBAM(String apiToken, String apiSecret, String dataCenter, ReadableMap options) {
        if (BamSDK.isRooted(getReactApplicationContext())) {
            showErrorMessage("The BAM SDK can't run on a rooted device.");
            return;
        }
        
        if (!BamSDK.isSupportedPlatform(this.getCurrentActivity())) {
            showErrorMessage("This platform is not supported.");
            return;
        }
        
        try {
            if (apiToken.isEmpty() || apiSecret.isEmpty() || dataCenter.isEmpty()) {
                showErrorMessage("Missing required parameters apiToken, apiSecret or dataCenter.");
                return;
            }
            
            JumioDataCenter center = (dataCenter.equals("eu")) ? JumioDataCenter.EU : JumioDataCenter.US;
            bamSDK = BamSDK.create(getCurrentActivity(), apiToken, apiSecret, center);
            
            this.configureBAM(options);
        } catch (PlatformNotSupportedException e) {
            showErrorMessage("Error initializing the BAM SDK: " + e.getLocalizedMessage());
        }
    }
    
    private void configureBAM(ReadableMap options) {
        ReadableMapKeySetIterator keys = options.keySetIterator();
        while (keys.hasNextKey()) {
            String key = keys.nextKey();
            
            if (key.equals("cardHolderNameRequired")) {
                bamSDK.setCardHolderNameRequired(options.getBoolean(key));
            } else if (key.equals("sortCodeAndAccountNumberRequired")) {
                bamSDK.setSortCodeAndAccountNumberRequired(options.getBoolean(key));
            } else if (key.equals("expiryRequired")) {
                bamSDK.setExpiryRequired(options.getBoolean(key));
            } else if (key.equals("cvvRequired")) {
                bamSDK.setCvvRequired(options.getBoolean(key));
            } else if (key.equals("expiryEditable")) {
                bamSDK.setExpiryEditable(options.getBoolean(key));
            } else if (key.equals("cardHolderNameEditable")) {
                bamSDK.setCardHolderNameEditable(options.getBoolean(key));
            } else if (key.equals("merchantReportingCriteria")) {
                bamSDK.setMerchantReportingCriteria(options.getString(key));
            } else if (key.equals("vibrationEffectEnabled")) {
                bamSDK.setVibrationEffectEnabled(options.getBoolean(key));
            } else if (key.equals("enableFlashOnScanStart")) {
                bamSDK.setEnableFlashOnScanStart(options.getBoolean(key));
            } else if (key.equals("cardNumberMaskingEnabled")) {
                bamSDK.setCardNumberMaskingEnabled(options.getBoolean(key));
            } else if (key.equals("cameraPosition")) {
                JumioCameraPosition cameraPosition = (options.getString(key).toLowerCase().equals("front")) ? JumioCameraPosition.FRONT : JumioCameraPosition.BACK;
                bamSDK.setCameraPosition(cameraPosition);
            } else if (key.equals("cardTypes")) {
                ReadableArray jsonTypes = options.getArray(key);
                ArrayList<String> types = new ArrayList<String>();
                if (jsonTypes != null) {
                    int len = jsonTypes.size();
                    for (int i = 0; i < len; i++) {
                        types.add(jsonTypes.getString(i));
                    }
                }
                
                ArrayList<CreditCardType> creditCardTypes = new ArrayList<CreditCardType>();
                for (String type : types) {
                    if (type.toLowerCase().equals("visa")) {
                        creditCardTypes.add(CreditCardType.VISA);
                    } else if (type.toLowerCase().equals("master_card")) {
                        creditCardTypes.add(CreditCardType.MASTER_CARD);
                    } else if (type.toLowerCase().equals("american_express")) {
                        creditCardTypes.add(CreditCardType.AMERICAN_EXPRESS);
                    } else if (type.toLowerCase().equals("china_unionpay")) {
                        creditCardTypes.add(CreditCardType.CHINA_UNIONPAY);
                    } else if (type.toLowerCase().equals("diners_club")) {
                        creditCardTypes.add(CreditCardType.DINERS_CLUB);
                    } else if (type.toLowerCase().equals("discover")) {
                        creditCardTypes.add(CreditCardType.DISCOVER);
                    } else if (type.toLowerCase().equals("jcb")) {
                        creditCardTypes.add(CreditCardType.JCB);
                    } else if (type.toLowerCase().equals("starbucks")) {
                        creditCardTypes.add(CreditCardType.STARBUCKS);
                    }
                }
                
                bamSDK.setSupportedCreditCardTypes(creditCardTypes);
            }
        }
    }
    
    @ReactMethod
    public void startBAM() {
        if (bamSDK == null) {
            showErrorMessage("The BAM SDK is not initialized yet. Call initBAM() first.");
            return;
        }
        
        try {
            checkPermissionsAndStart(bamSDK);
        } catch(IllegalArgumentException e) {
            showErrorMessage("Error starting the BAM SDK: " + e.getLocalizedMessage());
        }
    }
    
    // Permissions
    
    private void checkPermissionsAndStart(MobileSDK sdk) {
        if (!MobileSDK.hasAllRequiredPermissions(getReactApplicationContext())) {
            //Acquire missing permissions.
            String[] mp = MobileSDK.getMissingPermissions(getReactApplicationContext());
            
            int code;
            if (sdk instanceof BamSDK)
                code = PERMISSION_REQUEST_CODE_BAM;
            else if (sdk instanceof NetverifySDK)
                code = PERMISSION_REQUEST_CODE_NETVERIFY;
            else if (sdk instanceof DocumentVerificationSDK)
                code = PERMISSION_REQUEST_CODE_DOCUMENT_VERIFICATION;
            else {
                showErrorMessage("Invalid SDK instance");
                return;
            }
            
            ActivityCompat.requestPermissions(getCurrentActivity(), mp, code);
            //The result is received in MainActivity::onRequestPermissionsResult.
        } else {
            startSdk(sdk);
        }
    }
    
    // Helper methods
    
    private static void startSdk(ReactContext reactContext, MobileSDK sdk) {
        try {
            sdk.start();
        } catch (MissingPermissionException e) {
            showErrorMessage(reactContext, e.getLocalizedMessage());
        }
    }

    private void startSdk(MobileSDK sdk) {
        startSdk(getReactApplicationContext(), sdk);
    }

    private static void showErrorMessage(ReactContext reactContext, String msg) {
        Log.e("Error", msg);
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("EventError", msg);
    }

    private void showErrorMessage(String msg) {
        showErrorMessage(getReactApplicationContext(), msg);
    }

    private static void sendEvent(ReactContext reactContext, String eventName, String data) {
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, data);
    }

    private void sendEvent(String eventName, JSONObject params) {
        sendEvent(getReactApplicationContext(), eventName, params.toString());
    }

    private void sendEvent(String eventName, String msg) {
        sendEvent(getReactApplicationContext(), eventName, msg);
    }
}
