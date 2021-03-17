/*
 * Copyright 2017 Jumio Corporation
 * All rights reserved
 */

package com.jumio.react;

import android.app.Activity;
import android.content.Intent;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.WritableMap;
import com.jumio.core.enums.JumioCameraPosition;
import com.jumio.core.enums.JumioDataCenter;
import com.jumio.nv.NetverifyDocumentData;
import com.jumio.nv.NetverifySDK;
import com.jumio.nv.data.document.NVDocumentType;
import com.jumio.nv.data.document.NVDocumentVariant;
import com.jumio.nv.data.document.NVMRZFormat;
import com.jumio.nv.enums.NVExtractionMethod;
import com.jumio.nv.enums.NVGender;
import com.jumio.nv.enums.NVWatchlistScreening;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

public class JumioModuleNetverify extends JumioBaseModule {

    private final static String TAG = "JumioMobileSDKNetverify";
    private final String ERROR_KEY = "EventErrorNetverify";

	public static  NetverifySDK netverifySDK;

    JumioModuleNetverify(ReactApplicationContext context) {
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

            if (requestCode == NetverifySDK.REQUEST_CODE) {
                if (data == null) {
                    return;
                }
                String scanReference = data.getStringExtra(NetverifySDK.EXTRA_SCAN_REFERENCE) != null ? data.getStringExtra(NetverifySDK.EXTRA_SCAN_REFERENCE) : "";

                if (resultCode == Activity.RESULT_OK) {
                    NetverifyDocumentData documentData = (NetverifyDocumentData) data.getParcelableExtra(NetverifySDK.EXTRA_SCAN_DATA);

                    WritableMap result = Arguments.createMap();
                    result.putString("selectedCountry", documentData.getSelectedCountry());
                    if (documentData.getSelectedDocumentType() == NVDocumentType.PASSPORT) {
                        result.putString("selectedDocumentType", "PASSPORT");
                    } else if (documentData.getSelectedDocumentType() == NVDocumentType.DRIVER_LICENSE) {
                        result.putString("selectedDocumentType", "DRIVER_LICENSE");
                    } else if (documentData.getSelectedDocumentType() == NVDocumentType.IDENTITY_CARD) {
                        result.putString("selectedDocumentType", "IDENTITY_CARD");
                    } else if (documentData.getSelectedDocumentType() == NVDocumentType.VISA) {
                        result.putString("selectedDocumentType", "VISA");
                    }
                    result.putString("idNumber", documentData.getIdNumber());
                    result.putString("personalNumber", documentData.getPersonalNumber());
                    result.putString("issuingDate", documentData.getIssuingDate() != null ? documentData.getIssuingDate().toString() : "");
                    result.putString("expiryDate", documentData.getExpiryDate() != null ? documentData.getExpiryDate().toString() : "");
                    result.putString("issuingCountry", documentData.getIssuingCountry());
                    result.putString("lastName", documentData.getLastName());
                    result.putString("firstName", documentData.getFirstName());
                    result.putString("dob", documentData.getDob() != null ? documentData.getDob().toString() : ""); // test format
                    if (documentData.getGender() == NVGender.M) {
                        result.putString("gender", "m");
                    } else if (documentData.getGender() == NVGender.F) {
                        result.putString("gender", "f");
                    } else if (documentData.getGender() == NVGender.X) {
                        result.putString("gender", "x");
                    }
                    result.putString("originatingCountry", documentData.getOriginatingCountry());
                    result.putString("addressLine", documentData.getAddressLine());
                    result.putString("city", documentData.getCity());
                    result.putString("subdivision", documentData.getSubdivision());
                    result.putString("postCode", documentData.getPostCode());
                    result.putString("optionalData1", documentData.getOptionalData1());
                    result.putString("optionalData2", documentData.getOptionalData2());
                    result.putString("placeOfBirth", documentData.getPlaceOfBirth());
                    if (documentData.getExtractionMethod() == NVExtractionMethod.MRZ) {
                        result.putString("extractionMethod", "MRZ");
                    } else if (documentData.getExtractionMethod() == NVExtractionMethod.OCR) {
                        result.putString("extractionMethod", "OCR");
                    } else if (documentData.getExtractionMethod() == NVExtractionMethod.BARCODE) {
                        result.putString("extractionMethod", "BARCODE");
                    } else if (documentData.getExtractionMethod() == NVExtractionMethod.BARCODE_OCR) {
                        result.putString("extractionMethod", "BARCODE_OCR");
                    } else if (documentData.getExtractionMethod() == NVExtractionMethod.NONE) {
                        result.putString("extractionMethod", "NONE");
                    }

                    result.putString("scanReference", scanReference);

                    //MRZ data if available
                    if (documentData.getMrzData() != null) {
                        WritableMap mrzData = Arguments.createMap();
                        if (documentData.getMrzData().getFormat() == NVMRZFormat.MRP) {
                            mrzData.putString("format", "MRP");
                        } else if (documentData.getMrzData().getFormat() == NVMRZFormat.TD1) {
                            mrzData.putString("format", "TD1");
                        } else if (documentData.getMrzData().getFormat() == NVMRZFormat.TD2) {
                            mrzData.putString("format", "TD2");
                        } else if (documentData.getMrzData().getFormat() == NVMRZFormat.CNIS) {
                            mrzData.putString("format", "CNIS");
                        } else if (documentData.getMrzData().getFormat() == NVMRZFormat.MRV_A) {
                            mrzData.putString("format", "MRVA");
                        } else if (documentData.getMrzData().getFormat() == NVMRZFormat.MRV_B) {
                            mrzData.putString("format", "MRVB");
                        } else if (documentData.getMrzData().getFormat() == NVMRZFormat.Unknown) {
                            mrzData.putString("format", "UNKNOWN");
                        }
                        mrzData.putString("line1", documentData.getMrzData().getMrzLine1());
                        mrzData.putString("line2", documentData.getMrzData().getMrzLine2());
                        mrzData.putString("line3", documentData.getMrzData().getMrzLine3());
                        mrzData.putBoolean("idNumberValid", documentData.getMrzData().idNumberValid());
                        mrzData.putBoolean("dobValid", documentData.getMrzData().dobValid());
                        mrzData.putBoolean("expiryDateValid", documentData.getMrzData().expiryDateValid());
                        mrzData.putBoolean("personalNumberValid", documentData.getMrzData().personalNumberValid());
                        mrzData.putBoolean("compositeValid", documentData.getMrzData().compositeValid());
                        result.putMap("mrzData", mrzData);
                    }

                    sendEvent("EventDocumentData", result);
                } else if (resultCode == Activity.RESULT_CANCELED) {
                    String errorMessage = data.getStringExtra(NetverifySDK.EXTRA_ERROR_MESSAGE);
                    String errorCode = data.getStringExtra(NetverifySDK.EXTRA_ERROR_CODE);
                    sendErrorObject(errorCode, errorMessage, scanReference);
                }
                if (JumioModuleNetverify.netverifySDK != null) {
                    JumioModuleNetverify.netverifySDK.destroy();
                }
                reactContext.removeActivityEventListener(mActivityEventListener);
            }
        }
    };


    @NotNull
    @Override
    public String getName() {
        return "JumioMobileSDKNetverify";
    }

    @Override
    public boolean canOverrideExistingModule() {
        return true;
    }
    // Netverify

    @ReactMethod
    public void initNetverify(String apiToken, String apiSecret, String dataCenter, ReadableMap options) {
        try {
            if (apiToken.isEmpty() || apiSecret.isEmpty() || dataCenter.isEmpty()) {
                showErrorMessage("Missing required parameters apiToken, apiSecret or dataCenter.");
                return;
            }

            JumioDataCenter center = null;
            try {
                center = JumioDataCenter.valueOf(dataCenter.toUpperCase());
            } catch (Exception e) {
                throw new Exception("Datacenter not valid: "+dataCenter);            
            }
            netverifySDK = NetverifySDK.create(getCurrentActivity(), apiToken, apiSecret, center);

            this.configureNetverify(options);
        } catch (Exception e) {
            showErrorMessage("Error initializing the Netverify SDK: " + e.getLocalizedMessage());
        }
    }

    private void configureNetverify(ReadableMap options) {
        ReadableMapKeySetIterator keys = options.keySetIterator();
        while (keys.hasNextKey()) {
            String key = keys.nextKey();

            if (key.equalsIgnoreCase("enableVerification")) {
                netverifySDK.setEnableVerification(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("callbackUrl")) {
                netverifySDK.setCallbackUrl(options.getString(key));
            } else if (key.equalsIgnoreCase("enableIdentityVerification")) {
                netverifySDK.setEnableIdentityVerification(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("preselectedCountry")) {
                netverifySDK.setPreselectedCountry(options.getString(key));
            } else if (key.equalsIgnoreCase("customerInternalReference")) {
                netverifySDK.setCustomerInternalReference(options.getString(key));
            } else if (key.equalsIgnoreCase("reportingCriteria")) {
                netverifySDK.setReportingCriteria(options.getString(key));
            } else if (key.equalsIgnoreCase("userReference")) {
                netverifySDK.setUserReference(options.getString(key));
            } else if (key.equalsIgnoreCase("enableWatchlistScreening")) {
                NVWatchlistScreening watchlistScreeningState;
                switch (options.getString(key).toLowerCase()) {
                    case "enabled": watchlistScreeningState = NVWatchlistScreening.ENABLED;
                        break;
                    case "disabled": watchlistScreeningState = NVWatchlistScreening.DISABLED;
                        break;
                    default: watchlistScreeningState = NVWatchlistScreening.DEFAULT;
                        break;
                }
                netverifySDK.setWatchlistScreening(watchlistScreeningState);
            } else if (key.equalsIgnoreCase("watchlistSearchProfile")) {
                netverifySDK.setWatchlistSearchProfile(options.getString(key));
            } else if (key.equalsIgnoreCase("sendDebugInfoToJumio")) {
                netverifySDK.sendDebugInfoToJumio(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("dataExtractionOnMobileOnly")) {
                netverifySDK.setDataExtractionOnMobileOnly(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("cameraPosition")) {
                JumioCameraPosition cameraPosition = (options.getString(key).toLowerCase().equals("front")) ? JumioCameraPosition.FRONT : JumioCameraPosition.BACK;
                netverifySDK.setCameraPosition(cameraPosition);
            } else if (key.equalsIgnoreCase("preselectedDocumentVariant")) {
                NVDocumentVariant variant = (options.getString(key).toLowerCase().equals("paper")) ? NVDocumentVariant.PAPER : NVDocumentVariant.PLASTIC;
                netverifySDK.setPreselectedDocumentVariant(variant);
            } else if (key.equalsIgnoreCase("documentTypes")) {
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
            boolean sdkStarted = checkPermissionsAndStart(netverifySDK);
            if(sdkStarted){
                reactContext.addActivityEventListener(mActivityEventListener);
            }
        } catch (Exception e) {
            showErrorMessage("Error starting the Netverify SDK: " + e.getLocalizedMessage());
        }
    }
}

