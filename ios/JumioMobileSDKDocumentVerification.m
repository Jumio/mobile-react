//
//  JumioMobileSDKDocumentVerification.h
//
//  Copyright © 2019 Jumio Corporation All rights reserved.
//

#import "JumioMobileSDKDocumentVerification.h"

@import JumioCore;
@import DocumentVerification;

@interface JumioMobileSDKDocumentVerification() <DocumentVerificationViewControllerDelegate>

@property (nonatomic, strong) DocumentVerificationViewController *documentVerificationViewController;
@property (strong) DocumentVerificationConfiguration* documentVerifcationConfiguration;

@end

@implementation JumioMobileSDKDocumentVerification

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"EventErrorDocumentVerification", @"EventDocumentVerification"];
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
    _documentVerifcationConfiguration.apiToken = apiToken;
    _documentVerifcationConfiguration.apiSecret = apiSecret;
  
    JumioDataCenter jumioDataCenter = JumioDataCenterUS;
    NSString *dataCenterLowercase = [dataCenter lowercaseString];
    
    if ([dataCenterLowercase isEqualToString: @"eu"]) {
      jumioDataCenter = JumioDataCenterEU;
    } else if ([dataCenterLowercase isEqualToString: @"sg"]) {
      jumioDataCenter = JumioDataCenterSG;
    }
  
    _documentVerifcationConfiguration.dataCenter = jumioDataCenter;
    
    // Configuration
    if (![options isEqual:[NSNull null]]) {
        for (NSString *key in options) {
            if ([key isEqualToString: @"type"]) {
                _documentVerifcationConfiguration.type = [options objectForKey: key];
            } else if ([key isEqualToString: @"customDocumentCode"]) {
                _documentVerifcationConfiguration.customDocumentCode = [options objectForKey: key];
            } else if ([key isEqualToString: @"country"]) {
                _documentVerifcationConfiguration.country = [options objectForKey: key];
            } else if ([key isEqualToString: @"reportingCriteria"]) {
                _documentVerifcationConfiguration.reportingCriteria = [options objectForKey: key];
            } else if ([key isEqualToString: @"callbackUrl"]) {
                _documentVerifcationConfiguration.callbackUrl = [options objectForKey: key];
            } else if ([key isEqualToString: @"userReference"]) {
                _documentVerifcationConfiguration.userReference = [options objectForKey: key];
            } else if ([key isEqualToString: @"customerInternalReference"]) {
                _documentVerifcationConfiguration.customerInternalReference = [options objectForKey: key];
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
                [[DocumentVerificationBaseView jumioAppearance] setDisableBlur: @YES];
            } else if ([key isEqualToString: @"enableDarkMode"]) {
              [[DocumentVerificationBaseView jumioAppearance] setEnableDarkMode: @YES];
            } else {
                UIColor *color = [self colorWithHexString: [customization objectForKey: key]];
                
                if ([key isEqualToString: @"backgroundColor"]) {
                    [[DocumentVerificationBaseView jumioAppearance] setBackgroundColor: color];
                } else if ([key isEqualToString: @"tintColor"]) {
                    [[UINavigationBar jumioAppearance] setTintColor: color];
                } else if ([key isEqualToString: @"barTintColor"]) {
                    [[UINavigationBar jumioAppearance] setBarTintColor: color];
                } else if ([key isEqualToString: @"textTitleColor"]) {
                    [[UINavigationBar jumioAppearance] setTitleTextAttributes: @{NSForegroundColorAttributeName: color}];
                } else if ([key isEqualToString: @"foregroundColor"]) {
                    [[DocumentVerificationBaseView jumioAppearance] setForegroundColor: color];
                } else if ([key isEqualToString: @"positiveButtonBackgroundColor"]) {
                    [[DocumentVerificationPositiveButton jumioAppearance] setBackgroundColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"positiveButtonBorderColor"]) {
                    [[DocumentVerificationPositiveButton jumioAppearance] setBorderColor: color];
                } else if ([key isEqualToString: @"positiveButtonTitleColor"]) {
                    [[DocumentVerificationPositiveButton jumioAppearance] setTitleColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"negativeButtonBackgroundColor"]) {
                    [[DocumentVerificationNegativeButton jumioAppearance] setBackgroundColor: color forState:UIControlStateNormal];
                } else if ([key isEqualToString: @"negativeButtonBorderColor"]) {
                    [[DocumentVerificationNegativeButton jumioAppearance] setBorderColor: color];
                } else if ([key isEqualToString: @"negativeButtonTitleColor"]) {
                    [[DocumentVerificationNegativeButton jumioAppearance] setTitleColor: color forState:UIControlStateNormal];
                }
            }
        }
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.documentVerificationViewController = [[DocumentVerificationViewController alloc]initWithConfiguration: self.documentVerifcationConfiguration];
    });
}

RCT_EXPORT_METHOD(startDocumentVerification) {
    if (_documentVerificationViewController == nil) {
        NSLog(@"The Document Verification SDK is not initialized yet. Call initDocumentVerification() first.");
        return;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
        [delegate.window.rootViewController presentViewController: self.documentVerificationViewController animated: YES completion: nil];
    });
}

#pragma mark - Document Verification Delegates

- (void)documentVerificationViewController:(DocumentVerificationViewController *)documentVerificationViewController didFinishWithScanReference:(NSString *)scanReference {
	NSDictionary *result = [NSDictionary dictionaryWithObject: scanReference forKey: @"scanReference"];

    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController dismissViewControllerAnimated: YES completion: ^{
        [self sendEventWithName: @"EventDocumentVerification" body: result];
        self.documentVerificationViewController = nil;
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

	id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
	[delegate.window.rootViewController dismissViewControllerAnimated: YES completion: ^{
    	[self sendEventWithName: @"EventErrorDocumentVerification" body: result];
        self.documentVerificationViewController = nil;
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
