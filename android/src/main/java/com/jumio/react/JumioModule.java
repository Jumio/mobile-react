/*
 * Copyright 2017 Jumio Corporation
 * All rights reserved
 */

package com.jumio.react;

import android.support.v4.app.ActivityCompat;
import android.util.Log;
import java.util.ArrayList;

import com.facebook.react.bridge.ReactApplicationContext;
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
import com.jumio.sdk.SDKExpiredException;

public class JumioModule extends ReactContextBaseJavaModule {
    
    private final static String TAG = "JumioMobileSDK";
    public static final int PERMISSION_REQUEST_CODE_BAM = 300;
    public static final int PERMISSION_REQUEST_CODE_NETVERIFY = 301;
    public static final int PERMISSION_REQUEST_CODE_DOCUMENT_VERIFICATION = 303;
    
    public static NetverifySDK netverifySDK;
    public static BamSDK bamSDK;
    public static DocumentVerificationSDK documentVerificationSDK;
    
    public JumioModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }
    
    @Override
    public String getName() {
        return "JumioMobileSDK";
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
            
            ActivityCompat.requestPermissions(getReactApplicationContext().getCurrentActivity(), mp, code);
            //The result is received in MainActivity::onRequestPermissionsResult.
        } else {
            startSdk(sdk);
        }
    }
    
    // Helper methods
    
    private void startSdk(MobileSDK sdk) {
        try {
            sdk.start();
        } catch (MissingPermissionException e) {
            showErrorMessage(e.getLocalizedMessage());
        }
    }
    
    private void showErrorMessage(String msg) {
        Log.e("Error", msg);
        getReactApplicationContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("EventError", msg);
    }
}
