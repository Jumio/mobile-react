//
//  JumioMobileSDKDocumentVerification.h
//
//  Copyright © 2018 Jumio Corporation All rights reserved.
//


#import "JumioMobileSDKDocumentVerification.h"
#import "AppDelegate.h"
@import Netverify;

@interface JumioMobileSDKDocumentVerification() <DocumentVerificationViewControllerDelegate>

@property (nonatomic, strong) DocumentVerificationViewController *documentVerificationViewController;
@property (strong) DocumentVerificationConfiguration* documentVerifcationConfiguration;

@end

@implementation JumioMobileSDKDocumentVerification

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"EventError", @"EventDocumentVerification"];
}

RCT_EXPORT_METHOD(initDocumentVerification:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options) {
    [self initDocumentVerificationHelper:apiToken apiSecret:apiSecret dataCenter:dataCenter configuration:options customization:NULL];
}

RCT_EXPORT_METHOD(initDocumentVerificationWithCustomization:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options customization:(NSDictionary *)customization) {
    [self initDocumentVerificationHelper:apiToken apiSecret:apiSecret dataCenter:dataCenter configuration:options customization:customization];
}

- (void)initDocumentVerificationHelper:(NSString *)apiToken apiSecret:(NSString *)apiSecret dataCenter:(NSString *)dataCenter configuration:(NSDictionary *)options customization:(NSDictionary *)customization {
    
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
            } else if ([key isEqualToString: @"merchantScanReference"]) {
                _documentVerifcationConfiguration.merchantScanReference = [options objectForKey: key];
            } else if ([key isEqualToString: @"customerId"]) {
                _documentVerifcationConfiguration.customerId = [options objectForKey: key];
            } else if ([key isEqualToString: @"documentName"]) {
                _documentVerifcationConfiguration.documentName = [options objectForKey: key];
            } else if ([key isEqualToString: @"enableExtraction"]) {
                _documentVerifcationConfiguration.enableExtraction = [options objectForKey: key];
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
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.window.rootViewController presentViewController: _documentVerificationViewController animated: YES completion: nil];
    });
}

#pragma mark - Document Verification Delegates

- (void)documentVerificationViewController:(DocumentVerificationViewController *)documentVerificationViewController didFinishWithScanReference:(NSString *)scanReference {
	NSDictionary *result = [NSDictionary dictionaryWithObject: scanReference forKey: @"scanReference"];

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController dismissViewControllerAnimated: YES completion: ^{
        [self sendEventWithName: @"EventDocumentVerification" body: result];
    }];
}

- (void) documentVerificationViewController:(DocumentVerificationViewController *)documentVerificationViewController didFinishWithError:(DocumentVerificationError *)error {
    [self sendDocumentVerificationError: error];
}

# pragma mark - Helper methods

- (void) sendDocumentVerificationError:(DocumentVerificationError *)error {
	NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
	[result setValue: error.code forKey: @"errorCode"];
	[result setValue: error.message forKey: @"errorMessage"];

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
