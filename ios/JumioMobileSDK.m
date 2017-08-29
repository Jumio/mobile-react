//
//  JumioMobileSDK.m
//  Jumio Software Development GmbH
//

#import "JumioMobileSDK.h"
#import "AppDelegate.h"
@import Netverify;
@import BAMCheckout;

@interface JumioMobileSDK() <NetverifyViewControllerDelegate, BAMCheckoutViewControllerDelegate, DocumentVerificationViewControllerDelegate>

@property (nonatomic, strong) NetverifyViewController *netverifyViewController;
@property (nonatomic, strong) BAMCheckoutViewController *bamViewController;
@property (nonatomic, strong) DocumentVerificationViewController *documentVerificationViewController;
@property (strong) NetverifyConfiguration* netverifyConfiguration;
@property (strong) BAMCheckoutConfiguration* bamConfiguration;
@property (strong) DocumentVerificationConfiguration* documentVerifcationConfiguration;

@end

@implementation JumioMobileSDK

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"EventError", @"EventDocumentData", @"EventCardInformation", @"EventDocumentVerification"];
}

#pragma mark - BAMCheckout

RCT_EXPORT_METHOD(initBAM:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options) {
    [self initBAMHelper:apiToken apiSecret:apiSecret dataCenter:dataCenter configuration:options customization:NULL];
}

RCT_EXPORT_METHOD(initBAMWithCustomization:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options customization:(NSDictionary *)customization) {
    [self initBAMHelper:apiToken apiSecret:apiSecret dataCenter:dataCenter configuration:options customization:customization];
}

- (void)initBAMHelper:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options customization:(NSDictionary *)customization {
    if ([apiToken length] == 0 || [apiSecret length] == 0 || [dataCenter length] == 0) {
        [self sendError: @"Missing required parameters apiToken, apiSecret or dataCenter"];
        return;
    }
    
    // Initialization
    _bamConfiguration = [BAMCheckoutConfiguration new];
    _bamConfiguration.delegate = self;
    _bamConfiguration.merchantApiToken = apiToken;
    _bamConfiguration.merchantApiSecret = apiSecret;
    NSString *dataCenterLowercase = [dataCenter lowercaseString];
    _bamConfiguration.dataCenter = ([dataCenterLowercase isEqualToString: @"eu"]) ? JumioDataCenterEU : JumioDataCenterUS;
    
    // Configuration
    if (![options isEqual: [NSNull null]]) {
        for (NSString *key in options) {
            if ([key isEqualToString: @"cardHolderNameRequired"]) {
                _bamConfiguration.cardHolderNameRequired = [self getBoolValue: [options objectForKey: key]];
            } else if ([key isEqualToString: @"sortCodeAndAccountNumberRequired"]) {
                _bamConfiguration.sortCodeAndAccountNumberRequired = [self getBoolValue: [options objectForKey: key]];
            } else if ([key isEqualToString: @"expiryRequired"]) {
                _bamConfiguration.expiryRequired = [self getBoolValue: [options objectForKey: key]];
            } else if ([key isEqualToString: @"cvvRequired"]) {
                _bamConfiguration.cvvRequired = [self getBoolValue: [options objectForKey: key]];
            } else if ([key isEqualToString: @"expiryEditable"]) {
                _bamConfiguration.expiryEditable = [self getBoolValue: [options objectForKey: key]];
            } else if ([key isEqualToString: @"cardHolderNameEditable"]) {
                _bamConfiguration.cardHolderNameEditable = [self getBoolValue: [options objectForKey: key]];
            } else if ([key isEqualToString: @"merchantReportingCriteria"]) {
                _bamConfiguration.merchantReportingCriteria = [options objectForKey: key];
            } else if ([key isEqualToString: @"vibrationEffectEnabled"]) {
                _bamConfiguration.vibrationEffectEnabled = [self getBoolValue: [options objectForKey: key]];
            } else if ([key isEqualToString: @"enableFlashOnScanStart"]) {
                _bamConfiguration.enableFlashOnScanStart = [self getBoolValue: [options objectForKey: key]];
            } else if ([key isEqualToString: @"cardNumberMaskingEnabled"]) {
                _bamConfiguration.cardNumberMaskingEnabled = [self getBoolValue: [options objectForKey: key]];
            } else if ([key isEqualToString: @"offlineToken"]) {
                _bamConfiguration.offlineToken = [options objectForKey: key];
            } else if ([key isEqualToString: @"cameraPosition"]) {
                NSString *cameraString = [[options objectForKey: key] lowercaseString];
                JumioCameraPosition cameraPosition = ([cameraString isEqualToString: @"front"]) ? JumioCameraPositionFront : JumioCameraPositionBack;
                _bamConfiguration.cameraPosition = cameraPosition;
            } else if ([key isEqualToString: @"cardTypes"]) {
                NSMutableArray *jsonTypes = [options objectForKey: key];
                BAMCheckoutCreditCardTypes cardTypes = 0;
                
                int i;
                for (i = 0; i < [jsonTypes count]; i++) {
                    id type = [jsonTypes objectAtIndex: i];
                    
                    if ([[type lowercaseString] isEqualToString: @"visa"]) {
                        cardTypes = cardTypes | BAMCheckoutCreditCardTypeVisa;
                    } else if ([[type lowercaseString] isEqualToString: @"master_card"]) {
                        cardTypes = cardTypes | BAMCheckoutCreditCardTypeMasterCard;
                    } else if ([[type lowercaseString] isEqualToString: @"american_express"]) {
                        cardTypes = cardTypes | BAMCheckoutCreditCardTypeAmericanExpress;
                    } else if ([[type lowercaseString] isEqualToString: @"china_unionpay"]) {
                        cardTypes = cardTypes | BAMCheckoutCreditCardTypeChinaUnionPay;
                    } else if ([[type lowercaseString] isEqualToString: @"diners_club"]) {
                        cardTypes = cardTypes | BAMCheckoutCreditCardTypeDiners;
                    } else if ([[type lowercaseString] isEqualToString: @"discover"]) {
                        cardTypes = cardTypes | BAMCheckoutCreditCardTypeDiscover;
                    } else if ([[type lowercaseString] isEqualToString: @"jcb"]) {
                        cardTypes = cardTypes | BAMCheckoutCreditCardTypeJCB;
                    } else if ([[type lowercaseString] isEqualToString: @"starbucks"]) {
                        cardTypes = cardTypes | BAMCheckoutCreditCardTypeStarbucks;
                    }
                }
                
                _bamConfiguration.supportedCreditCardTypes = cardTypes;
            }
        }
    }
    
    // Customization
    if (![customization isEqual:[NSNull null]]) {
        for (NSString *key in customization) {
            if ([key isEqualToString: @"disableBlur"]) {
                [[BAMCheckoutBaseView bamCheckoutAppearance] setDisableBlur: @YES];
            } else {
                UIColor *color = [self colorWithHexString: [customization objectForKey: key]];
                
                if ([key isEqualToString: @"backgroundColor"]) {
                    [[BAMCheckoutBaseView bamCheckoutAppearance] setBackgroundColor: color];
                } else if ([key isEqualToString: @"tintColor"]) {
                    [[UINavigationBar bamCheckoutAppearance] setTintColor: color];
                } else if ([key isEqualToString: @"barTintColor"]) {
                    [[UINavigationBar bamCheckoutAppearance] setBarTintColor: color];
                } else if ([key isEqualToString: @"textTitleColor"]) {
                    [[UINavigationBar bamCheckoutAppearance] setTitleTextAttributes: @{NSForegroundColorAttributeName: color}];
                } else if ([key isEqualToString: @"foregroundColor"]) {
                    [[BAMCheckoutBaseView bamCheckoutAppearance] setForegroundColor: color];
                } else if ([key isEqualToString: @"positiveButtonBackgroundColor"]) {
                    [[BAMCheckoutPositiveButton bamCheckoutAppearance] setBackgroundColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"positiveButtonBorderColor"]) {
                    [[BAMCheckoutPositiveButton bamCheckoutAppearance] setBorderColor: color];
                } else if ([key isEqualToString: @"positiveButtonTitleColor"]) {
                    [[BAMCheckoutPositiveButton bamCheckoutAppearance] setTitleColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"negativeButtonBackgroundColor"]) {
                    [[BAMCheckoutNegativeButton bamCheckoutAppearance] setBackgroundColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"negativeButtonBorderColor"]) {
                    [[BAMCheckoutNegativeButton bamCheckoutAppearance] setBorderColor: color];
                } else if ([key isEqualToString: @"negativeButtonTitleColor"]) {
                    [[BAMCheckoutNegativeButton bamCheckoutAppearance] setTitleColor: color forState:UIControlStateNormal];
                }  else if ([key isEqualToString: @"scanOverlayTextColor"]) {
                    [[BAMCheckoutScanOverlay bamCheckoutAppearance] setTextColor: color];
                }  else if ([key isEqualToString: @"scanOverlayBorderColor"]) {
                    [[BAMCheckoutScanOverlay bamCheckoutAppearance] setBorderColor: color];
                }
            }
        }
    }
    
    _bamViewController = [[BAMCheckoutViewController alloc]initWithConfiguration: _bamConfiguration];
}

RCT_EXPORT_METHOD(startBAM) {
    if (_bamViewController == nil) {
        NSLog(@"The BAMCheckout SDK is not initialized yet. Call initBAM() first.");
        return;
    }
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController presentViewController: _bamViewController animated: YES completion: nil];
}

#pragma mark - Netverify

RCT_EXPORT_METHOD(initNetverify:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options) {
    [self initNetverifyHelper:apiToken apiSecret:apiSecret dataCenter:dataCenter configuration:options customization:NULL];
}

RCT_EXPORT_METHOD(initNetverifyWithCustomization:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options customization:(NSDictionary *)customization) {
    [self initNetverifyHelper:apiToken apiSecret:apiSecret dataCenter:dataCenter configuration:options customization:customization];
}

- (void)initNetverifyHelper:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options customization:(NSDictionary *)customization {
    if ([apiToken length] == 0 || [apiSecret length] == 0 || [dataCenter length] == 0) {
        [self sendError: @"Missing required parameters apiToken, apiSecret or dataCenter"];
        return;
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
            } else if ([key isEqualToString: @"additionalInformation"]) {
                _netverifyConfiguration.additionalInformation = [options objectForKey: key];
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
                } else if ([key isEqualToString: @"defaultButtonBackgroundColor"]) {
                    [[NetverifyScanOptionButton netverifyAppearance] setBackgroundColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"defaultButtonTitleColor"]) {
                    [[NetverifyScanOptionButton netverifyAppearance] setTitleColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"activeButtonBackgroundColor"]) {
                    [[NetverifyScanOptionButton netverifyAppearance] setBackgroundColor: color forState:UIControlStateHighlighted];
                } else if ([key isEqualToString: @"activeButtonTitleColor"]) {
                    [[NetverifyScanOptionButton netverifyAppearance] setTitleColor: color forState:UIControlStateHighlighted];
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
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController presentViewController: _netverifyViewController animated:YES completion: nil];
}

#pragma mark - Document Verification

RCT_EXPORT_METHOD(initDocumentVerification:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options) {
    [self initDocumentVerificationHelper:apiToken apiSecret:apiSecret dataCenter:dataCenter configuration:options customization:NULL];
}

RCT_EXPORT_METHOD(initDocumentVerificationWithCustomization:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options customization:(NSDictionary *)customization) {
    [self initDocumentVerificationHelper:apiToken apiSecret:apiSecret dataCenter:dataCenter configuration:options customization:customization];
}

- (void)initDocumentVerificationHelper:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options customization:(NSDictionary *)customization {
    if ([apiToken length] == 0 || [apiSecret length] == 0 || [dataCenter length] == 0) {
        [self sendError: @"Missing required parameters apiToken, apiSecret or dataCenter"];
        return;
    }
    
    // Initialization
    _documentVerifcationConfiguration = [DocumentVerificationConfiguration new];
    _documentVerifcationConfiguration.delegate = self;
    _documentVerifcationConfiguration.merchantApiToken = apiToken;
    _documentVerifcationConfiguration.merchantApiSecret = apiSecret;
    NSString *dataCenterLowercase = [dataCenter lowercaseString];
    _documentVerifcationConfiguration.dataCenter = ([dataCenterLowercase isEqualToString: @"eu"]) ? JumioDataCenterEU : JumioDataCenterUS;
    
    // Configuration
    if (![options isEqual:[NSNull null]]) {
        for (NSString *key in options) {
            if ([key isEqualToString: @"type"]) {
                _documentVerifcationConfiguration.type = [options objectForKey: key];
            } else if ([key isEqualToString: @"customDocumentCode"]) {
                _documentVerifcationConfiguration.customDocumentCode = [options objectForKey: key];
            } else if ([key isEqualToString: @"country"]) {
                _documentVerifcationConfiguration.country = [options objectForKey: key];
            } else if ([key isEqualToString: @"merchantReportingCriteria"]) {
                _documentVerifcationConfiguration.merchantReportingCriteria = [options objectForKey: key];
            } else if ([key isEqualToString: @"callbackUrl"]) {
                _documentVerifcationConfiguration.callbackUrl = [options objectForKey: key];
            } else if ([key isEqualToString: @"additionalInformation"]) {
                _documentVerifcationConfiguration.additionalInformation = [options objectForKey: key];
            } else if ([key isEqualToString: @"merchantScanReference"]) {
                _documentVerifcationConfiguration.merchantScanReference = [options objectForKey: key];
            } else if ([key isEqualToString: @"customerId"]) {
                _documentVerifcationConfiguration.customerId = [options objectForKey: key];
            } else if ([key isEqualToString: @"documentName"]) {
                _documentVerifcationConfiguration.documentName = [options objectForKey: key];
            } else if ([key isEqualToString: @"cameraPosition"]) {
                NSString *cameraString = [[options objectForKey: key] lowercaseString];
                JumioCameraPosition cameraPosition = ([cameraString isEqualToString: @"front"]) ? JumioCameraPositionFront : JumioCameraPositionBack;
                _documentVerifcationConfiguration.cameraPosition = cameraPosition;
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
                } else if ([key isEqualToString: @"defaultButtonBackgroundColor"]) {
                    [[NetverifyScanOptionButton netverifyAppearance] setBackgroundColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"defaultButtonTitleColor"]) {
                    [[NetverifyScanOptionButton netverifyAppearance] setTitleColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"activeButtonBackgroundColor"]) {
                    [[NetverifyScanOptionButton netverifyAppearance] setBackgroundColor: color forState:UIControlStateHighlighted];
                } else if ([key isEqualToString: @"activeButtonTitleColor"]) {
                    [[NetverifyScanOptionButton netverifyAppearance] setTitleColor: color forState:UIControlStateHighlighted];
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
    
    _documentVerificationViewController = [[DocumentVerificationViewController alloc]initWithConfiguration: _documentVerifcationConfiguration];
}

RCT_EXPORT_METHOD(startDocumentVerification) {
    if (_documentVerificationViewController == nil) {
        NSLog(@"The Document Verification SDK is not initialized yet. Call initDocumentVerification() first.");
        return;
    }
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController presentViewController: _documentVerificationViewController animated: YES completion: nil];
}

#pragma mark - BAMCheckout Delegates

- (void)bamCheckoutViewController:(BAMCheckoutViewController *)controller didFinishScanWithCardInformation:(BAMCheckoutCardInformation *)cardInformation scanReference:(NSString *)scanReference {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    
    if (cardInformation.cardType == BAMCheckoutCreditCardTypeVisa) {
        [result setValue: @"VISA" forKey: @"cardType"];
    } else if (cardInformation.cardType == BAMCheckoutCreditCardTypeMasterCard) {
        [result setValue: @"MASTER_CARD" forKey: @"cardType"];
    } else if (cardInformation.cardType == BAMCheckoutCreditCardTypeAmericanExpress) {
        [result setValue: @"AMERICAN_EXPRESS" forKey: @"cardType"];
    } else if (cardInformation.cardType == BAMCheckoutCreditCardTypeChinaUnionPay) {
        [result setValue: @"CHINA_UNIONPAY" forKey: @"cardType"];
    } else if (cardInformation.cardType == BAMCheckoutCreditCardTypeDiners) {
        [result setValue: @"DINERS_CLUB" forKey: @"cardType"];
    } else if (cardInformation.cardType == BAMCheckoutCreditCardTypeDiscover) {
        [result setValue: @"DISCOVER" forKey: @"cardType"];
    } else if (cardInformation.cardType == BAMCheckoutCreditCardTypeJCB) {
        [result setValue: @"JCB" forKey: @"cardType"];
    } else if (cardInformation.cardType == BAMCheckoutCreditCardTypeStarbucks) {
        [result setValue: @"STARBUCKS" forKey: @"cardType"];
    }
    
    [result setValue: [cardInformation.cardNumber copy] forKey: @"cardNumber"];
    [result setValue: [cardInformation.cardNumberGrouped copy] forKey: @"cardNumberGrouped"];
    [result setValue: [cardInformation.cardNumberMasked copy] forKey: @"cardNumberMasked"];
    [result setValue: [cardInformation.cardExpiryMonth copy] forKey: @"cardExpiryMonth"];
    [result setValue: [cardInformation.cardExpiryYear copy] forKey: @"cardExpiryYear"];
    [result setValue: [cardInformation.cardExpiryDate copy] forKey: @"cardExpiryDate"];
    [result setValue: [cardInformation.cardCVV copy] forKey: @"cardCVV"];
    [result setValue: [cardInformation.cardHolderName copy] forKey: @"cardHolderName"];
    [result setValue: [cardInformation.cardSortCode copy] forKey: @"cardSortCode"];
    [result setValue: [cardInformation.cardAccountNumber copy] forKey: @"cardAccountNumber"];
    [result setValue: [NSNumber numberWithBool: cardInformation.cardSortCodeValid] forKey: @"cardSortCodeValid"];
    [result setValue: [NSNumber numberWithBool: cardInformation.cardAccountNumberValid] forKey: @"cardAccountNumberValid"];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController dismissViewControllerAnimated: YES completion: ^{
        [self sendEventWithName: @"EventCardInformation" body: result];
    }];
}

- (void)bamCheckoutViewController:(BAMCheckoutViewController *)controller didCancelWithError:(NSError *)error scanReference:(NSString *)scanReference {
    [self sendError: [self getErrorMessage: error]];
}

- (void)bamCheckoutViewController:(BAMCheckoutViewController *)controller didStartScanAttemptWithScanReference:(NSString *)scanReference {
    NSLog(@"BAMCheckoutViewController did start scan attempt with request reference: %@", scanReference);
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
    [result setValue: documentData.middleName forKey: @"middleName"];
    [result setValue: [formatter stringFromDate: documentData.dob] forKey: @"dob"];
    if (documentData.gender == NetverifyGenderM) {
        [result setValue: @"m" forKey: @"gender"];
    } else if (documentData.gender == NetverifyGenderF) {
        [result setValue: @"f" forKey: @"gender"];
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
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController dismissViewControllerAnimated: YES completion: ^{
        [self sendEventWithName: @"EventDocumentData" body: result];
    }];
}

- (void) netverifyViewController:(NetverifyViewController *)netverifyViewController didCancelWithError:(NSError *)error scanReference:(NSString *)scanReference {
    [self sendError: [self getErrorMessage: error]];
}

- (void) netverifyViewController:(NetverifyViewController *)netverifyViewController didFinishInitializingWithError:(NSError *)error {
    if (error != nil) {
        [self sendError: [self getErrorMessage: error]];
    }
}

#pragma mark - Document Verification Delegates

- (void)documentVerificationViewController:(DocumentVerificationViewController *)documentVerificationViewController didFinishWithScanReference:(NSString *)scanReference {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController dismissViewControllerAnimated: YES completion: ^{
        [self sendEventWithName: @"EventDocumentVerification" body: @"Document Verification finished successfully."];
    }];
}

- (void) documentVerificationViewController:(DocumentVerificationViewController *)documentVerificationViewController didFinishWithError:(NSError *)error {
    [self sendError: [self getErrorMessage: error]];
}

# pragma mark - Helper methods

- (void) sendError:(NSString *)error {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController dismissViewControllerAnimated: YES completion: ^{
        [self sendEventWithName: @"EventError" body: error];
    }];
}

- (NSString *) getErrorMessage:(NSError *)error {
    return [NSString stringWithFormat: @"Cancelled with error code: %ld, message: %@", (long)error.code, error.localizedDescription];
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
