//
//  JumioMobileSDKBamCheckout.h
//
//  Copyright © 2019 Jumio Corporation All rights reserved.
//

#import "JumioMobileSDKBamCheckout.h"
@import JumioCore;
@import BAMCheckout;

@interface JumioMobileSDKBamCheckout() <BAMCheckoutViewControllerDelegate>

@property (nonatomic, strong) BAMCheckoutViewController *bamViewController;
@property (strong) BAMCheckoutConfiguration* bamConfiguration;
@property (strong) NSMutableArray* scanReferences;

@end

@implementation JumioMobileSDKBamCheckout

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"EventErrorBam", @"EventCardInformation"];
}

RCT_EXPORT_METHOD(initBAM:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options) {
    [self initBAMHelper:apiToken apiSecret:apiSecret dataCenter:dataCenter configuration:options customization:NULL];
}

RCT_EXPORT_METHOD(initBAMWithCustomization:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options customization:(NSDictionary *)customization) {
    [self initBAMHelper:apiToken apiSecret:apiSecret dataCenter:dataCenter configuration:options customization:customization];
}

- (void)initBAMHelper:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options customization:(NSDictionary *)customization {
    
    // Initialization
    _bamConfiguration = [BAMCheckoutConfiguration new];
    _bamConfiguration.delegate = self;
    _bamConfiguration.apiToken = apiToken;
    _bamConfiguration.apiSecret = apiSecret;
  
    JumioDataCenter jumioDataCenter = JumioDataCenterUS;
    NSString *dataCenterLowercase = [dataCenter lowercaseString];
    
    if ([dataCenterLowercase isEqualToString: @"eu"]) {
      jumioDataCenter = JumioDataCenterEU;
    } else if ([dataCenterLowercase isEqualToString: @"sg"]) {
      jumioDataCenter = JumioDataCenterSG;
    }
  
    _bamConfiguration.dataCenter = jumioDataCenter;
  
    self.scanReferences = [[NSMutableArray alloc] init];
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
            } else if ([key isEqualToString: @"reportingCriteria"]) {
                _bamConfiguration.reportingCriteria = [options objectForKey: key];
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
                [[BAMCheckoutBaseView jumioAppearance] setDisableBlur: @YES];
            } else {
                UIColor *color = [self colorWithHexString: [customization objectForKey: key]];
                
                if ([key isEqualToString: @"backgroundColor"]) {
                    [[BAMCheckoutBaseView jumioAppearance] setBackgroundColor: color];
                } else if ([key isEqualToString: @"tintColor"]) {
                    [[UINavigationBar jumioAppearance] setTintColor: color];
                } else if ([key isEqualToString: @"barTintColor"]) {
                    [[UINavigationBar jumioAppearance] setBarTintColor: color];
                } else if ([key isEqualToString: @"textTitleColor"]) {
                    [[UINavigationBar jumioAppearance] setTitleTextAttributes: @{NSForegroundColorAttributeName: color}];
                } else if ([key isEqualToString: @"foregroundColor"]) {
                    [[BAMCheckoutBaseView jumioAppearance] setForegroundColor: color];
                } else if ([key isEqualToString: @"positiveButtonBackgroundColor"]) {
                    [[BAMCheckoutPositiveButton jumioAppearance] setBackgroundColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"positiveButtonBorderColor"]) {
                    [[BAMCheckoutPositiveButton jumioAppearance] setBorderColor: color];
                } else if ([key isEqualToString: @"positiveButtonTitleColor"]) {
                    [[BAMCheckoutPositiveButton jumioAppearance] setTitleColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"negativeButtonBackgroundColor"]) {
                    [[BAMCheckoutNegativeButton jumioAppearance] setBackgroundColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"negativeButtonBorderColor"]) {
                    [[BAMCheckoutNegativeButton jumioAppearance] setBorderColor: color];
                } else if ([key isEqualToString: @"negativeButtonTitleColor"]) {
                    [[BAMCheckoutNegativeButton jumioAppearance] setTitleColor: color forState:UIControlStateNormal];
                }  else if ([key isEqualToString: @"scanOverlayTextColor"]) {
                    [[BAMCheckoutScanOverlay jumioAppearance] setTextColor: color];
                }  else if ([key isEqualToString: @"scanOverlayBorderColor"]) {
                    [[BAMCheckoutScanOverlay jumioAppearance] setBorderColor: color];
                }
            }
        }
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.bamViewController = [[BAMCheckoutViewController alloc]initWithConfiguration: self.bamConfiguration];
    });
}

RCT_EXPORT_METHOD(startBAM) {
    if (_bamViewController == nil) {
        NSLog(@"The BAMCheckout SDK is not initialized yet. Call initBAM() first.");
        return;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
        [delegate.window.rootViewController presentViewController: _bamViewController animated: YES completion: nil];
    });
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
  
    if (scanReference) {
      if (![self.scanReferences containsObject:scanReference]) {
        [self.scanReferences addObject:scanReference];
      }
    }
	
    [result setValue: self.scanReferences forKey: @"scanReferences"];
    
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController dismissViewControllerAnimated: YES completion: ^{
        [self sendEventWithName: @"EventCardInformation" body: result];
        [self.scanReferences removeAllObjects];
    }];
}

- (void)bamCheckoutViewController:(BAMCheckoutViewController *)controller didCancelWithError:(NSError *)error scanReference:(NSString *)scanReference {
    if (scanReference) {
      if (![self.scanReferences containsObject:scanReference]) {
        [self.scanReferences addObject:scanReference];
      }
    }
  
    [self sendError: error scanReference: self.scanReferences.copy];
    [self.scanReferences removeAllObjects];
}

- (void)bamCheckoutViewController:(BAMCheckoutViewController *)controller didStartScanAttemptWithScanReference:(NSString *)scanReference {
    if (scanReference) {
      if (![self.scanReferences containsObject:scanReference]) {
        [self.scanReferences addObject:scanReference];
      }
    }

    NSLog(@"BAMCheckoutViewController did start scan attempt with request reference: %@", scanReference);
}

# pragma mark - Helper methods

- (void) sendError:(NSError *)error scanReference:(NSArray *)scanReferences {
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	[result setValue: [NSNumber numberWithInteger: error.code] forKey: @"errorCode"];
	[result setValue: error.localizedDescription forKey: @"errorMessage"];
	if (scanReferences) {
		[result setValue: scanReferences forKey: @"scanReferences"];
	}

	id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
	[delegate.window.rootViewController dismissViewControllerAnimated: YES completion: ^{
    	[self sendEventWithName: @"EventErrorBam" body: result];
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
