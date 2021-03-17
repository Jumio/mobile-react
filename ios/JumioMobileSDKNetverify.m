//
//  JumioMobileSDKNetverify.m
//
//  Copyright © 2019 Jumio Corporation All rights reserved.
//

#import "JumioMobileSDKNetverify.h"

@import JumioCore;
@import Netverify;

@interface JumioMobileSDKNetverify() <NetverifyViewControllerDelegate>

@property (nonatomic, strong) NetverifyViewController *netverifyViewController;
@property (strong) NetverifyConfiguration* netverifyConfiguration;

@end

@implementation JumioMobileSDKNetverify

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
    return @[@"EventErrorNetverify", @"EventDocumentData"];
}

RCT_EXPORT_METHOD(initNetverify:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options) {
    [self initNetverifyHelper:apiToken apiSecret:apiSecret dataCenter:dataCenter configuration:options customization:NULL];
}

RCT_EXPORT_METHOD(initNetverifyWithCustomization:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options customization:(NSDictionary *)customization) {
    [self initNetverifyHelper:apiToken apiSecret:apiSecret dataCenter:dataCenter configuration:options customization:customization];
}

- (void)initNetverifyHelper:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options customization:(NSDictionary *)customization {
    
    if (self.netverifyViewController) {
        [self.netverifyViewController destroy];
    }
    
    // Initialization
    _netverifyConfiguration = [NetverifyConfiguration new];
    _netverifyConfiguration.delegate = self;
    _netverifyConfiguration.apiToken = apiToken;
    _netverifyConfiguration.apiSecret = apiSecret;
    
    JumioDataCenter jumioDataCenter = JumioDataCenterUS;
    NSString *dataCenterLowercase = [dataCenter lowercaseString];
    
    if ([dataCenterLowercase isEqualToString: @"eu"]) {
      jumioDataCenter = JumioDataCenterEU;
    } else if ([dataCenterLowercase isEqualToString: @"sg"]) {
      jumioDataCenter = JumioDataCenterSG;
    }
  
    _netverifyConfiguration.dataCenter = jumioDataCenter;
    
    // Configuration
    if (![options isEqual:[NSNull null]]) {
        for (NSString *key in options) {
            if ([key isEqualToString: @"enableVerification"]) {
                _netverifyConfiguration.enableVerification = [self getBoolValue: [options objectForKey: key]];
            } else if ([key isEqualToString: @"callbackUrl"]) {
                _netverifyConfiguration.callbackUrl = [options objectForKey: key];
            } else if ([key isEqualToString: @"enableIdentityVerification"]) {
                _netverifyConfiguration.enableIdentityVerification = [self getBoolValue: [options objectForKey: key]];
            } else if ([key isEqualToString: @"preselectedCountry"]) {
                _netverifyConfiguration.preselectedCountry = [options objectForKey: key];
            } else if ([key isEqualToString: @"userReference"]) {
                _netverifyConfiguration.userReference = [options objectForKey: key];
            } else if ([key isEqualToString: @"reportingCriteria"]) {
                _netverifyConfiguration.reportingCriteria = [options objectForKey: key];
            } else if ([key isEqualToString: @"customerInternalReference"]) {
                _netverifyConfiguration.customerInternalReference = [options objectForKey: key];
            } else if ([key isEqualToString: @"enableWatchlistScreening"]) {
              NSString* watchlistScreeningValue = [[options objectForKey: key] lowercaseString];
              if ([watchlistScreeningValue isEqualToString:@"enabled"]) {
                _netverifyConfiguration.watchlistScreening = NetverifyWatchlistScreeningEnabled;
              } else if ([watchlistScreeningValue isEqualToString:@"disabled"]) {
                _netverifyConfiguration.watchlistScreening = NetverifyWatchlistScreeningDisabled;
              } else {
                _netverifyConfiguration.watchlistScreening = NetverifyWatchlistScreeningDefault;
              }
            } else if ([key isEqualToString: @"watchlistSearchProfile"]) {
              _netverifyConfiguration.watchlistSearchProfile = [options objectForKey: key];
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
                [[NetverifyBaseView jumioAppearance] setDisableBlur: @YES];
            } else if ([key isEqualToString: @"enableDarkMode"]) {
                [[NetverifyBaseView jumioAppearance] setEnableDarkMode:@YES];
            } else {
                UIColor *color = [self colorWithHexString: [customization objectForKey: key]];
                
                if ([key isEqualToString: @"backgroundColor"]) {
                    [[NetverifyBaseView jumioAppearance] setBackgroundColor: color];
                } else if ([key isEqualToString: @"tintColor"]) {
                    [[UINavigationBar jumioAppearance] setTintColor: color];
                } else if ([key isEqualToString: @"barTintColor"]) {
                    [[UINavigationBar jumioAppearance] setBarTintColor: color];
                } else if ([key isEqualToString: @"textTitleColor"]) {
                    [[UINavigationBar jumioAppearance] setTitleTextAttributes: @{NSForegroundColorAttributeName: color}];
                } else if ([key isEqualToString: @"foregroundColor"]) {
                    [[NetverifyBaseView jumioAppearance] setForegroundColor: color];
                } else if ([key isEqualToString: @"documentSelectionHeaderBackgroundColor"]) {
                  	[[NetverifyDocumentSelectionHeaderView jumioAppearance] setBackgroundColor: color];
               	} else if ([key isEqualToString: @"documentSelectionHeaderTitleColor"]) {
                   	[[NetverifyDocumentSelectionHeaderView jumioAppearance] setTitleColor: color];
                } else if ([key isEqualToString: @"documentSelectionHeaderIconColor"]) {
                    [[NetverifyDocumentSelectionHeaderView jumioAppearance] setIconColor: color];
                } else if ([key isEqualToString: @"documentSelectionButtonBackgroundColor"]) {
                    [[NetverifyDocumentSelectionButton jumioAppearance] setBackgroundColor: color forState: UIControlStateNormal];
                } else if ([key isEqualToString: @"documentSelectionButtonTitleColor"]) {
                    [[NetverifyDocumentSelectionButton jumioAppearance] setTitleColor: color forState: UIControlStateNormal];
                } else if ([key isEqualToString: @"documentSelectionButtonIconColor"]) {
                    [[NetverifyDocumentSelectionButton jumioAppearance] setIconColor: color forState: UIControlStateNormal];
                } else if ([key isEqualToString: @"fallbackButtonBackgroundColor"]) {
                    [[NetverifyFallbackButton jumioAppearance] setBackgroundColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"fallbackButtonBorderColor"]) {
                    [[NetverifyFallbackButton jumioAppearance] setBorderColor: color];
                } else if ([key isEqualToString: @"fallbackButtonTitleColor"]) {
                    [[NetverifyFallbackButton jumioAppearance] setTitleColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"positiveButtonBackgroundColor"]) {
                    [[NetverifyPositiveButton jumioAppearance] setBackgroundColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"positiveButtonBorderColor"]) {
                    [[NetverifyPositiveButton jumioAppearance] setBorderColor: color];
                } else if ([key isEqualToString: @"positiveButtonTitleColor"]) {
                    [[NetverifyPositiveButton jumioAppearance] setTitleColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"negativeButtonBackgroundColor"]) {
                    [[NetverifyNegativeButton jumioAppearance] setBackgroundColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"negativeButtonBorderColor"]) {
                    [[NetverifyNegativeButton jumioAppearance] setBorderColor: color];
                } else if ([key isEqualToString: @"negativeButtonTitleColor"]) {
                    [[NetverifyNegativeButton jumioAppearance] setTitleColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"faceOvalColor"]) {
                    [[NetverifyScanOverlayView jumioAppearance] setFaceOvalColor: color];
                } else if ([key isEqualToString: @"faceProgressColor"]) {
                     [[NetverifyScanOverlayView jumioAppearance] setFaceProgressColor: color];
                } else if ([key isEqualToString: @"faceFeedbackBackgroundColor"]) {
                     [[NetverifyScanOverlayView jumioAppearance] setFaceFeedbackBackgroundColor: color];
                } else if ([key isEqualToString: @"faceFeedbackTextColor"]) {
                     [[NetverifyScanOverlayView jumioAppearance] setFaceFeedbackTextColor: color];
                }
            }
        }
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.netverifyViewController = [[NetverifyViewController alloc] initWithConfiguration: self.netverifyConfiguration];
    });
}

RCT_EXPORT_METHOD(startNetverify) {
    dispatch_sync(dispatch_get_main_queue(), ^{
        if (_netverifyViewController == nil) {
            NSLog(@"The Netverify SDK is not initialized yet. Call initNetverify() first.");
            return;
        }
        id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
        [delegate.window.rootViewController presentViewController: _netverifyViewController animated:YES completion: nil];
    });
}

#pragma mark - Netverify Delegates

- (void) netverifyViewController:(NetverifyViewController *)netverifyViewController didFinishWithDocumentData:(NetverifyDocumentData *)documentData scanReference:(NSString *)scanReference accountId:(NSString* _Nullable)accountId authenticationResult:(BOOL)authenticationResult {
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
    if (accountId) {
        [result setValue: accountId forKey: @"accountId"];
    }
    [result setValue: [NSNumber numberWithBool: authenticationResult] forKey: @"authenticationResult"];
    
    
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
    
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController dismissViewControllerAnimated: YES completion: ^{
        [self sendEventWithName: @"EventDocumentData" body: result];
        
        [self.netverifyViewController destroy];
        self.netverifyViewController = nil;
    }];
}

- (void) netverifyViewController:(NetverifyViewController *)netverifyViewController didCancelWithError:(NetverifyError *)error scanReference:(NSString *)scanReference accountId:(NSString* _Nullable)accountId {
    [self sendNetverifyError: error scanReference: scanReference accountId:accountId];
}

- (void) netverifyViewController:(NetverifyViewController *)netverifyViewController didFinishInitializingWithError:(NetverifyError *)error {
  if (error != nil) {
    [self sendNetverifyError: error scanReference: nil accountId:nil];
  }
}

# pragma mark - Helper methods

- (void) sendNetverifyError:(NetverifyError *)error scanReference:(NSString *)scanReference accountId:(NSString* _Nullable)accountId {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    [result setValue: error.code forKey: @"errorCode"];
    [result setValue: error.message forKey: @"errorMessage"];
    if (scanReference) {
        [result setValue: scanReference forKey: @"scanReference"];
    }
    if (accountId) {
        [result setValue: accountId forKey: @"accountId"];
    }
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController dismissViewControllerAnimated: YES completion: ^{
        [self sendEventWithName: @"EventErrorNetverify" body: result];
        
        if (self.netverifyViewController != nil) {
            [self.netverifyViewController destroy];
            self.netverifyViewController = nil;
        }
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
