/*
 * Copyright 2017 Jumio Corporation
 * All rights reserved
 */

package com.jumio.react;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.util.Log;
import android.widget.Toast;

import com.facebook.react.ReactActivity;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.jumio.MobileSDK;
import com.jumio.auth.AuthenticationResult;
import com.jumio.auth.AuthenticationSDK;
import com.jumio.bam.BamCardInformation;
import com.jumio.bam.BamSDK;
import com.jumio.bam.enums.CreditCardType;
import com.jumio.core.exceptions.MissingPermissionException;
import com.jumio.dv.DocumentVerificationSDK;
import com.jumio.nv.NetverifyDocumentData;
import com.jumio.nv.NetverifySDK;
import com.jumio.nv.data.document.NVDocumentType;
import com.jumio.nv.data.document.NVMRZFormat;
import com.jumio.nv.enums.NVExtractionMethod;
import com.jumio.nv.enums.NVGender;

import java.util.ArrayList;

import androidx.annotation.NonNull;

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
			if (requestCode == JumioModuleBamCheckout.PERMISSION_REQUEST_CODE_BAM) {
				startSdk(JumioModuleBamCheckout.bamSDK);
			} else if (requestCode == JumioModuleNetverify.PERMISSION_REQUEST_CODE_NETVERIFY) {
				startSdk(JumioModuleNetverify.netverifySDK);
			} else if (requestCode == JumioModuleDocumentVerification.PERMISSION_REQUEST_CODE_DOCUMENT_VERIFICATION) {
				startSdk(JumioModuleDocumentVerification.documentVerificationSDK);
			} else {
				super.onRequestPermissionsResult(requestCode, permissions, grantResults);
			}
		} else {
			Toast.makeText(this, "Not all required permissions have been granted", Toast.LENGTH_LONG).show();
			super.onRequestPermissionsResult(requestCode, permissions, grantResults);
		}
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
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
				if (scanReferenceList != null && scanReferenceList.size() > 0){
					for (int i = scanReferenceList.size() - 1; i >= 0; i--){
						writableArray.pushString(scanReferenceList.get(i));
					}
				}
				result.putArray("scanReferences", writableArray);

				sendEvent(this.getReactInstanceManager().getCurrentReactContext(), "EventCardInformation", result);
				cardInformation.clear();
			} else if (resultCode == Activity.RESULT_CANCELED) {
				String errorMessage = data.getStringExtra(BamSDK.EXTRA_ERROR_MESSAGE);
				String errorCode = data.getStringExtra(BamSDK.EXTRA_ERROR_CODE);

				WritableArray writableArray = new WritableNativeArray();
				ArrayList<String> scanReferenceList = data.getStringArrayListExtra(BamSDK.EXTRA_SCAN_ATTEMPTS);
				if (scanReferenceList != null && scanReferenceList.size() > 0){
					for (int i = scanReferenceList.size() - 1; i >= 0; i--){
						writableArray.pushString(scanReferenceList.get(i));
					}
				}
				sendErrorObjectWithArray(errorCode, errorMessage, writableArray);
			}
			if(JumioModuleBamCheckout.bamSDK != null){
				JumioModuleBamCheckout.bamSDK.destroy();
			}
		} else if (requestCode == NetverifySDK.REQUEST_CODE) {
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

				// EMRTD data if available
				if (documentData.getEMRTDStatus() != null) {
					result.putString("emrtdStatus", String.valueOf(documentData.getEMRTDStatus()));
				}

				sendEvent(this.getReactInstanceManager().getCurrentReactContext(), "EventDocumentData", result);
			} else if (resultCode == Activity.RESULT_CANCELED) {
				String errorMessage = data.getStringExtra(NetverifySDK.EXTRA_ERROR_MESSAGE);
				String errorCode = data.getStringExtra(NetverifySDK.EXTRA_ERROR_CODE);
				sendErrorObject(errorCode, errorMessage, scanReference);
			}
			if(JumioModuleNetverify.netverifySDK != null){
				JumioModuleNetverify.netverifySDK.destroy();
			}
		} else if (requestCode == DocumentVerificationSDK.REQUEST_CODE) {
			if (data == null) {
				return;
			}
			String scanReference = data.getStringExtra(DocumentVerificationSDK.EXTRA_SCAN_REFERENCE) != null ? data.getStringExtra(DocumentVerificationSDK.EXTRA_SCAN_REFERENCE) : "";

			if (resultCode == Activity.RESULT_OK) {
				WritableMap result = Arguments.createMap();
				result.putString("successMessage", "Document-Verification finished successfully.");
				result.putString("scanReference", scanReference);

				sendEvent(this.getReactInstanceManager().getCurrentReactContext(), "EventDocumentVerification", result);

			} else if (resultCode == Activity.RESULT_CANCELED) {
				String errorMessage = data.getStringExtra(DocumentVerificationSDK.EXTRA_ERROR_MESSAGE);
				String errorCode = data.getStringExtra(DocumentVerificationSDK.EXTRA_ERROR_CODE);
				sendErrorObject(errorCode, errorMessage, scanReference);
			}
			if(JumioModuleDocumentVerification.documentVerificationSDK != null){
				JumioModuleDocumentVerification.documentVerificationSDK.destroy();
			}
		} else if (requestCode == AuthenticationSDK.REQUEST_CODE) {
			if(data == null) {
				return;
			}
			String transactionReference = data.getStringExtra(AuthenticationSDK.EXTRA_TRANSACTION_REFERENCE) != null ? data.getStringExtra(AuthenticationSDK.EXTRA_TRANSACTION_REFERENCE) : "";
			if (resultCode == Activity.RESULT_OK) {
				AuthenticationResult authenticationResult = (AuthenticationResult) data.getSerializableExtra(AuthenticationSDK.EXTRA_SCAN_DATA);
				WritableMap result = Arguments.createMap();
				result.putString("authenticationResult", authenticationResult.toString());
				result.putString("transactionReference", transactionReference);

				sendEvent(this.getReactInstanceManager().getCurrentReactContext(), "EventAuthentication", result);
			} else if (resultCode == Activity.RESULT_CANCELED) {
				String errorMessage = data.getStringExtra(AuthenticationSDK.EXTRA_ERROR_MESSAGE);
				String errorCode = data.getStringExtra(AuthenticationSDK.EXTRA_ERROR_CODE);
				sendErrorObject(errorCode, errorMessage, transactionReference);
			}
			if(JumioModuleAuthentication.authenticationSDK!= null){
				JumioModuleAuthentication.authenticationSDK.destroy();
			}
		}

		else {
			this.getReactInstanceManager().onActivityResult(this, requestCode, resultCode, data);
		}
	}

	// Helper methods

	private void sendEvent(ReactContext reactContext, String eventName, WritableMap params) {
		reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
			.emit(eventName, params);
	}

	public void startSdk(MobileSDK sdk) {
		try {
			sdk.start();
		} catch (MissingPermissionException e) {
			showErrorMessage(e.getLocalizedMessage());
		}
	}

	private void sendErrorObject(String errorCode, String errorMsg, String scanReference) {
		WritableMap errorResult = Arguments.createMap();
		errorResult.putString("errorCode", errorCode != null ? errorCode : "");
		errorResult.putString("errorMessage", errorMsg != null ? errorMsg : "");
		errorResult.putString("scanReference", scanReference != null ? scanReference : "");
		sendEvent(this.getReactInstanceManager().getCurrentReactContext(), "EventError", errorResult);
	}

	private void sendErrorObjectWithArray(String errorCode, String errorMsg, WritableArray array) {
		WritableMap errorResult = Arguments.createMap();
		errorResult.putString("errorCode", errorCode != null ? errorCode : "");
		errorResult.putString("errorMessage", errorMsg != null ? errorMsg : "");
		if (array != null){
			errorResult.putArray("scanReferences", array);
		} else {
			errorResult.putString("scanReferences", "");
		}
		sendEvent(this.getReactInstanceManager().getCurrentReactContext(), "EventError", errorResult);
	}

	private void showErrorMessage(String msg) {
		Log.e("Error", msg);
		WritableMap errorResult = Arguments.createMap();
		errorResult.putString("errorMessage", msg != null ? msg : "");
		sendEvent(this.getReactInstanceManager().getCurrentReactContext(), "EventError", errorResult);
	}
}

