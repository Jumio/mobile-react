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
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.jumio.bam.BamCardInformation;
import com.jumio.bam.BamSDK;
import com.jumio.bam.enums.CreditCardType;
import com.jumio.core.enums.JumioCameraPosition;
import com.jumio.core.enums.JumioDataCenter;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

public class JumioModuleBamCheckout extends JumioBaseModule {

    private final static String TAG = "JumioMobileSDKBamCheckout";
	private final String ERROR_KEY = "EventErrorBam";

	public static BamSDK bamSDK;

    JumioModuleBamCheckout(ReactApplicationContext context) {
        super(context);
    }

	@Override
	public String getErrorKey() {
		return ERROR_KEY;
	}

	private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {

		@Override
		public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {

			if (requestCode == BamSDK.REQUEST_CODE) {
				if (data == null) {
					return;
				}
				if (resultCode == Activity.RESULT_OK) {
					BamCardInformation cardInformation = data.getParcelableExtra(BamSDK.EXTRA_CARD_INFORMATION);

					WritableMap result = Arguments.createMap();
					if (cardInformation.getCardType() == CreditCardType.VISA) {
						result.putString("cardType", "VISA");
					} else if (cardInformation.getCardType() == CreditCardType.MASTER_CARD) {
						result.putString("cardType", "MASTER_CARD");
					} else if (cardInformation.getCardType() == CreditCardType.AMERICAN_EXPRESS) {
						result.putString("cardType", "AMERICAN_EXPRESS");
					} else if (cardInformation.getCardType() == CreditCardType.CHINA_UNIONPAY) {
						result.putString("cardType", "CHINA_UNIONPAY");
					} else if (cardInformation.getCardType() == CreditCardType.DINERS_CLUB) {
						result.putString("cardType", "DINERS_CLUB");
					} else if (cardInformation.getCardType() == CreditCardType.DISCOVER) {
						result.putString("cardType", "DISCOVER");
					} else if (cardInformation.getCardType() == CreditCardType.JCB) {
						result.putString("cardType", "JCB");
					}
					result.putString("cardNumber", String.valueOf(cardInformation.getCardNumber()));
					result.putString("cardNumberGrouped", String.valueOf(cardInformation.getCardNumberGrouped()));
					result.putString("cardNumberMasked", String.valueOf(cardInformation.getCardNumberMasked()));
					result.putString("cardExpiryMonth", String.valueOf(cardInformation.getCardExpiryDateMonth()));
					result.putString("cardExpiryYear", String.valueOf(cardInformation.getCardExpiryDateYear()));
					result.putString("cardExpiryDate", String.valueOf(cardInformation.getCardExpiryDate()));
					result.putString("cardCVV", String.valueOf(cardInformation.getCardCvvCode()));
					result.putString("cardHolderName", String.valueOf(cardInformation.getCardHolderName()));
					result.putString("cardSortCode", String.valueOf(cardInformation.getCardSortCode()));
					result.putString("cardAccountNumber", String.valueOf(cardInformation.getCardAccountNumber()));
					result.putBoolean("cardSortCodeValid", cardInformation.isCardSortCodeValid());
					result.putBoolean("cardAccountNumberValid", cardInformation.isCardAccountNumberValid());

					WritableArray writableArray = new WritableNativeArray();
					ArrayList<String> scanReferenceList = data.getStringArrayListExtra(BamSDK.EXTRA_SCAN_ATTEMPTS);
					if (scanReferenceList != null && scanReferenceList.size() > 0) {
						for (int i = scanReferenceList.size() - 1; i >= 0; i--) {
							writableArray.pushString(scanReferenceList.get(i));
						}
					}
					result.putArray("scanReferences", writableArray);
					sendEvent("EventCardInformation", result);

					cardInformation.clear();
				} else if (resultCode == Activity.RESULT_CANCELED) {
					String errorMessage = data.getStringExtra(BamSDK.EXTRA_ERROR_MESSAGE);
					String errorCode = data.getStringExtra(BamSDK.EXTRA_ERROR_CODE);

					WritableArray writableArray = new WritableNativeArray();
					ArrayList<String> scanReferenceList = data.getStringArrayListExtra(BamSDK.EXTRA_SCAN_ATTEMPTS);
					if (scanReferenceList != null && scanReferenceList.size() > 0) {
						for (int i = scanReferenceList.size() - 1; i >= 0; i--) {
							writableArray.pushString(scanReferenceList.get(i));
						}
					}
					sendErrorObjectWithArray(errorCode, errorMessage, writableArray);
				}
				if (JumioModuleBamCheckout.bamSDK != null) {
					JumioModuleBamCheckout.bamSDK.destroy();
				}
				reactContext.removeActivityEventListener(mActivityEventListener);
			}
		}
	};

    @NotNull
    @Override
    public String getName() {
        return "JumioMobileSDKBamCheckout";
    }

    // BAM Checkout
    @ReactMethod
    public void initBAM(String apiToken, String apiSecret, String dataCenter, ReadableMap options) {
        if (BamSDK.isRooted(getReactApplicationContext())) {
            showErrorMessage("The BAM SDK can't run on a rooted device.");
            return;
        }

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
            bamSDK = BamSDK.create(getCurrentActivity(), apiToken, apiSecret, center);

            this.configureBAM(options);
        } catch (Exception e) {
            showErrorMessage("Error initializing the BAM SDK: " + e.getLocalizedMessage());
        }
    }

    private void configureBAM(ReadableMap options) {
        ReadableMapKeySetIterator keys = options.keySetIterator();
        while (keys.hasNextKey()) {
            String key = keys.nextKey();

            if (key.equalsIgnoreCase("cardHolderNameRequired")) {
                bamSDK.setCardHolderNameRequired(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("sortCodeAndAccountNumberRequired")) {
                bamSDK.setSortCodeAndAccountNumberRequired(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("expiryRequired")) {
                bamSDK.setExpiryRequired(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("cvvRequired")) {
                bamSDK.setCvvRequired(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("expiryEditable")) {
                bamSDK.setExpiryEditable(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("cardHolderNameEditable")) {
                bamSDK.setCardHolderNameEditable(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("reportingCriteria")) {
                bamSDK.setMerchantReportingCriteria(options.getString(key));
            } else if (key.equalsIgnoreCase("vibrationEffectEnabled")) {
                bamSDK.setVibrationEffectEnabled(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("enableFlashOnScanStart")) {
                bamSDK.setEnableFlashOnScanStart(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("cardNumberMaskingEnabled")) {
                bamSDK.setCardNumberMaskingEnabled(options.getBoolean(key));
            } else if (key.equalsIgnoreCase("cameraPosition")) {
                JumioCameraPosition cameraPosition = (options.getString(key).toLowerCase().equals("front")) ? JumioCameraPosition.FRONT : JumioCameraPosition.BACK;
                bamSDK.setCameraPosition(cameraPosition);
            } else if (key.equalsIgnoreCase("cardTypes")) {
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
	        boolean sdkStarted = checkPermissionsAndStart(bamSDK);
	        if(sdkStarted){
		        reactContext.addActivityEventListener(mActivityEventListener);
	        }
        } catch(IllegalArgumentException e) {
            showErrorMessage("Error starting the BAM SDK: " + e.getLocalizedMessage());
        }
    }
}

