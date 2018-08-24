//
//  JumioMobileSDKNetverify.m
//
//  Copyright © 2018 Jumio Corporation All rights reserved.
//

#import "JumioMobileSDKNetverify.h"
#import "AppDelegate.h"
@import Netverify;

@interface JumioMobileSDKNetverify() <NetverifyViewControllerDelegate>

@property (nonatomic, strong) NetverifyViewController *netverifyViewController;
@property (strong) NetverifyConfiguration* netverifyConfiguration;

@end

@implementation JumioMobileSDKNetverify

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"EventError", @"EventDocumentData"];
}

RCT_EXPORT_METHOD(initNetverify:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options) {
    [self initNetverifyHelper:apiToken apiSecret:apiSecret dataCenter:dataCenter configuration:options customization:NULL];
}

RCT_EXPORT_METHOD(initNetverifyWithCustomization:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options customization:(NSDictionary *)customization) {
    [self initNetverifyHelper:apiToken apiSecret:apiSecret dataCenter:dataCenter configuration:options customization:customization];
}

RCT_EXPORT_METHOD(enableEMRTD) {
    // only working on android
    // method does nothing!
}

- (void)initNetverifyHelper:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options customization:(NSDictionary *)customization {
    
    if (self.netverifyViewController) {
        [self.netverifyViewController destroy];
    }
    
    // Initialization
    _netverifyConfiguration = [NetverifyConfiguration new];
    _netverifyConfiguration.delegate = self;
    _netverifyConfiguration.merchantApiToken = apiToken;
    _netverifyConfiguration.merchantApiSecret = apiSecret;
    NSString *dataCenterLowercase = [dataCenter lowercaseString];
    _netverifyConfiguration.dataCenter = ([dataCenterLowercase isEqualToString: @"eu"]) ? JumioDataCenterEU : JumioDataCenterUS;
    
    // Configuration
    if (![options isEqual:[NSNull null]]) {
        for (NSString *key in options) {
            if ([key isEqualToString: @"requireVerification"]) {
                _netverifyConfiguration.requireVerification = [self getBoolValue: [options objectForKey: key]];
            } else if ([key isEqualToString: @"callbackUrl"]) {
                _netverifyConfiguration.callbackUrl = [options objectForKey: key];
            } else if ([key isEqualToString: @"requireFaceMatch"]) {
                _netverifyConfiguration.requireFaceMatch = [self getBoolValue: [options objectForKey: key]];
            } else if ([key isEqualToString: @"preselectedCountry"]) {
                _netverifyConfiguration.preselectedCountry = [options objectForKey: key];
            } else if ([key isEqualToString: @"merchantScanReference"]) {
                _netverifyConfiguration.merchantScanReference = [options objectForKey: key];
            } else if ([key isEqualToString: @"merchantReportingCriteria"]) {
                _netverifyConfiguration.merchantReportingCriteria = [options objectForKey: key];
            } else if ([key isEqualToString: @"customerId"]) {
                _netverifyConfiguration.customerId = [options objectForKey: key];
            } else if ([key isEqualToString: @"sendDebugInfoToJumio"]) {
                _netverifyConfiguration.sendDebugInfoToJumio = [self getBoolValue: [options objectForKey: key]];
            } else if ([key isEqualToString: @"dataExtractionOnMobileOnly"]) {
                _netverifyConfiguration.dataExtractionOnMobileOnly = [self getBoolValue: [options objectForKey: key]];
            } else if ([key isEqualToString: @"cameraPosition"]) {
                NSString *cameraString = [[options objectForKey: key] lowercaseString];
                JumioCameraPosition cameraPosition = ([cameraString isEqualToString: @"front"]) ? JumioCameraPositionFront : JumioCameraPositionBack;
                _netverifyConfiguration.cameraPosition = cameraPosition;
            } else if ([key isEqualToString: @"preselectedDocumentVariant"]) {
                NSString *variantString = [[options objectForKey: key] lowercaseString];
                NetverifyDocumentVariant variant = ([variantString isEqualToString: @"paper"]) ? NetverifyDocumentVariantPaper : NetverifyDocumentVariantPlastic;
                _netverifyConfiguration.preselectedDocumentVariant = variant;
            } else if ([key isEqualToString: @"documentTypes"]) {
                NSMutableArray *jsonTypes = [options objectForKey: key];
                NetverifyDocumentType documentTypes = 0;
                
                int i;
                for (i = 0; i < [jsonTypes count]; i++) {
                    id type = [jsonTypes objectAtIndex: i];
                    
                    if ([[type lowercaseString] isEqualToString: @"passport"]) {
                        documentTypes = documentTypes | NetverifyDocumentTypePassport;
                    } else if ([[type lowercaseString] isEqualToString: @"driver_license"]) {
                        documentTypes = documentTypes | NetverifyDocumentTypeDriverLicense;
                    } else if ([[type lowercaseString] isEqualToString: @"identity_card"]) {
                        documentTypes = documentTypes | NetverifyDocumentTypeIdentityCard;
                    } else if ([[type lowercaseString] isEqualToString: @"visa"]) {
                        documentTypes = documentTypes | NetverifyDocumentTypeVisa;
                    }
                }
                
                _netverifyConfiguration.preselectedDocumentTypes = documentTypes;
            }
        }
    }
    
    // Customization
    if (![customization isEqual:[NSNull null]]) {
        for (NSString *key in customization) {
            if ([key isEqualToString: @"disableBlur"]) {
                [[NetverifyBaseView netverifyAppearance] setDisableBlur: @YES];
            } else {
                UIColor *color = [self colorWithHexString: [customization objectForKey: key]];
                
                if ([key isEqualToString: @"backgroundColor"]) {
                    [[NetverifyBaseView netverifyAppearance] setBackgroundColor: color];
                } else if ([key isEqualToString: @"tintColor"]) {
                    [[UINavigationBar netverifyAppearance] setTintColor: color];
                } else if ([key isEqualToString: @"barTintColor"]) {
                    [[UINavigationBar netverifyAppearance] setBarTintColor: color];
                } else if ([key isEqualToString: @"textTitleColor"]) {
                    [[UINavigationBar netverifyAppearance] setTitleTextAttributes: @{NSForegroundColorAttributeName: color}];
                } else if ([key isEqualToString: @"foregroundColor"]) {
                    [[NetverifyBaseView netverifyAppearance] setForegroundColor: color];
                } else if ([key isEqualToString: @"documentSelectionHeaderBackgroundColor"]) {
                  	[[NetverifyDocumentSelectionHeaderView netverifyAppearance] setBackgroundColor: color];
               	} else if ([key isEqualToString: @"documentSelectionHeaderTitleColor"]) {
                   	[[NetverifyDocumentSelectionHeaderView netverifyAppearance] setTitleColor: color];
            	} else if ([key isEqualToString: @"documentSelectionHeaderIconColor"]) {
                    [[NetverifyDocumentSelectionHeaderView netverifyAppearance] setIconColor: color];
                } else if ([key isEqualToString: @"documentSelectionButtonBackgroundColor"]) {
                    [[NetverifyDocumentSelectionButton netverifyAppearance] setBackgroundColor: color forState: UIControlStateNormal];
                } else if ([key isEqualToString: @"documentSelectionButtonTitleColor"]) {
                    [[NetverifyDocumentSelectionButton netverifyAppearance] setTitleColor: color forState: UIControlStateNormal];
                } else if ([key isEqualToString: @"documentSelectionButtonIconColor"]) {
                    [[NetverifyDocumentSelectionButton netverifyAppearance] setIconColor: color forState: UIControlStateNormal];
                } else if ([key isEqualToString: @"fallbackButtonBackgroundColor"]) {
                    [[NetverifyFallbackButton netverifyAppearance] setBackgroundColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"fallbackButtonBorderColor"]) {
                    [[NetverifyFallbackButton netverifyAppearance] setBorderColor: color];
                } else if ([key isEqualToString: @"fallbackButtonTitleColor"]) {
                    [[NetverifyFallbackButton netverifyAppearance] setTitleColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"positiveButtonBackgroundColor"]) {
                    [[NetverifyPositiveButton netverifyAppearance] setBackgroundColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"positiveButtonBorderColor"]) {
                    [[NetverifyPositiveButton netverifyAppearance] setBorderColor: color];
                } else if ([key isEqualToString: @"positiveButtonTitleColor"]) {
                    [[NetverifyPositiveButton netverifyAppearance] setTitleColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"negativeButtonBackgroundColor"]) {
                    [[NetverifyNegativeButton netverifyAppearance] setBackgroundColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"negativeButtonBorderColor"]) {
                    [[NetverifyNegativeButton netverifyAppearance] setBorderColor: color];
                } else if ([key isEqualToString: @"negativeButtonTitleColor"]) {
                    [[NetverifyNegativeButton netverifyAppearance] setTitleColor: color forState:UIControlStateNormal];
                }
            }
        }
    }
    
    _netverifyViewController = [[NetverifyViewController alloc] initWithConfiguration: _netverifyConfiguration];
}

RCT_EXPORT_METHOD(startNetverify) {
    if (_netverifyViewController == nil) {
        NSLog(@"The Netverify SDK is not initialized yet. Call initNetverify() first.");
        return;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.window.rootViewController presentViewController: _netverifyViewController animated:YES completion: nil];
    });
}

#pragma mark - Netverify Delegates

- (void) netverifyViewController:(NetverifyViewController *)netverifyViewController didFinishWithDocumentData:(NetverifyDocumentData *)documentData scanReference:(NSString *)scanReference {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy-MM-dd'T'HH:mm:ss.SSS"];
  
    [result setValue: documentData.selectedCountry forKey: @"selectedCountry"];
    if (documentData.selectedDocumentType == NetverifyDocumentTypePassport) {
        [result setValue: @"PASSPORT" forKey: @"selectedDocumentType"];
    } else if (documentData.selectedDocumentType == NetverifyDocumentTypeDriverLicense) {
        [result setValue: @"DRIVER_LICENSE" forKey: @"selectedDocumentType"];
    } else if (documentData.selectedDocumentType == NetverifyDocumentTypeIdentityCard) {
        [result setValue: @"IDENTITY_CARD" forKey: @"selectedDocumentType"];
    } else if (documentData.selectedDocumentType == NetverifyDocumentTypeVisa) {
        [result setValue: @"VISA" forKey: @"selectedDocumentType"];
    }
    [result setValue: documentData.idNumber forKey: @"idNumber"];
    [result setValue: documentData.personalNumber forKey: @"personalNumber"];
    [result setValue: [formatter stringFromDate: documentData.issuingDate] forKey: @"issuingDate"];
    [result setValue: [formatter stringFromDate: documentData.expiryDate] forKey: @"expiryDate"];
    [result setValue: documentData.issuingCountry forKey: @"issuingCountry"];
    [result setValue: documentData.lastName forKey: @"lastName"];
    [result setValue: documentData.firstName forKey: @"firstName"];
    [result setValue: [formatter stringFromDate: documentData.dob] forKey: @"dob"];
    if (documentData.gender == NetverifyGenderM) {
        [result setValue: @"m" forKey: @"gender"];
    } else if (documentData.gender == NetverifyGenderF) {
        [result setValue: @"f" forKey: @"gender"];
    } else if (documentData.gender == NetverifyGenderX) {
        [result setValue: @"x" forKey: @"gender"];
    }
    [result setValue: documentData.originatingCountry forKey: @"originatingCountry"];
    [result setValue: documentData.addressLine forKey: @"addressLine"];
    [result setValue: documentData.city forKey: @"city"];
    [result setValue: documentData.subdivision forKey: @"subdivision"];
    [result setValue: documentData.postCode forKey: @"postCode"];
    [result setValue: documentData.optionalData1 forKey: @"optionalData1"];
    [result setValue: documentData.optionalData2 forKey: @"optionalData2"];
    if (documentData.extractionMethod == NetverifyExtractionMethodMRZ) {
        [result setValue: @"MRZ" forKey: @"extractionMethod"];
    } else if (documentData.extractionMethod == NetverifyExtractionMethodOCR) {
        [result setValue: @"OCR" forKey: @"extractionMethod"];
    } else if (documentData.extractionMethod == NetverifyExtractionMethodBarcode) {
        [result setValue: @"BARCODE" forKey: @"extractionMethod"];
    } else if (documentData.extractionMethod == NetverifyExtractionMethodBarcodeOCR) {
        [result setValue: @"BARCODE_OCR" forKey: @"extractionMethod"];
    } else if (documentData.extractionMethod == NetverifyExtractionMethodNone) {
        [result setValue: @"NONE" forKey: @"extractionMethod"];
    }
    
    // MRZ data if available
    if (documentData.mrzData != nil) {
        NSMutableDictionary *mrzData = [[NSMutableDictionary alloc] init];
        if (documentData.mrzData.format == NetverifyMRZFormatMRP) {
            [mrzData setValue: @"MRP" forKey: @"format"];
        } else if (documentData.mrzData.format == NetverifyMRZFormatTD1) {
            [mrzData setValue: @"TD1" forKey: @"format"];
        } else if (documentData.mrzData.format == NetverifyMRZFormatTD2) {
            [mrzData setValue: @"TD2" forKey: @"format"];
        } else if (documentData.mrzData.format == NetverifyMRZFormatCNIS) {
            [mrzData setValue: @"CNIS" forKey: @"format"];
        } else if (documentData.mrzData.format == NetverifyMRZFormatMRVA) {
            [mrzData setValue: @"MRVA" forKey: @"format"];
        } else if (documentData.mrzData.format == NetverifyMRZFormatMRVB) {
            [mrzData setValue: @"MRVB" forKey: @"format"];
        } else if (documentData.mrzData.format == NetverifyMRZFormatUnknown) {
            [mrzData setValue: @"UNKNOWN" forKey: @"format"];
        }
        
        [mrzData setValue: documentData.mrzData.line1 forKey: @"line1"];
        [mrzData setValue: documentData.mrzData.line2 forKey: @"line2"];
        [mrzData setValue: documentData.mrzData.line3 forKey: @"line3"];
        [mrzData setValue: [NSNumber numberWithBool: documentData.mrzData.idNumberValid] forKey: @"idNumberValid"];
        [mrzData setValue: [NSNumber numberWithBool: documentData.mrzData.dobValid] forKey: @"dobValid"];
        [mrzData setValue: [NSNumber numberWithBool: documentData.mrzData.expiryDateValid] forKey: @"expiryDateValid"];
        [mrzData setValue: [NSNumber numberWithBool: documentData.mrzData.personalNumberValid] forKey: @"personalNumberValid"];
        [mrzData setValue: [NSNumber numberWithBool: documentData.mrzData.compositeValid] forKey: @"compositeValid"];
        [result setValue: mrzData forKey: @"mrzData"];
    }
	
	[result setValue: scanReference forKey: @"scanReference"];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController dismissViewControllerAnimated: YES completion: ^{
        [self sendEventWithName: @"EventDocumentData" body: result];
    }];
}

- (void) netverifyViewController:(NetverifyViewController *)netverifyViewController didCancelWithError:(NetverifyError *)error scanReference:(NSString *)scanReference {
  [self sendNetverifyError: error scanReference: scanReference];
}

- (void) netverifyViewController:(NetverifyViewController *)netverifyViewController didFinishInitializingWithError:(NetverifyError *)error {
  if (error != nil) {
    [self sendNetverifyError: error scanReference: nil];
  }
}

# pragma mark - Helper methods

- (void) sendNetverifyError:(NetverifyError *)error scanReference:(NSString *)scanReference {
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	[result setValue: error.code forKey: @"errorCode"];
	[result setValue: error.message forKey: @"errorMessage"];
	if (scanReference) {
		[result setValue: scanReference forKey: @"scanReference"];
	}

	AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[delegate.window.rootViewController dismissViewControllerAnimated: YES completion: ^{
    	[self sendEventWithName: @"EventError" body: result];
	}];
}

- (BOOL) getBoolValue:(NSObject *)value {
    if (value && [value isKindOfClass: [NSNumber class]]) {
        return [((NSNumber *)value) boolValue];
    }
    return value;
}

- (UIColor *)colorWithHexString:(NSString *)str_HEX {
    int red = 0;
    int green = 0;
    int blue = 0;
    sscanf([str_HEX UTF8String], "#%02X%02X%02X", &red, &green, &blue);
    return  [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

@end
