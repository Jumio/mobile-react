//
//  JumioMobileSDKAuthentication.m
//
//  Copyright © 2019 Jumio Corporation All rights reserved.
//

#import "JumioMobileSDKAuthentication.h"
#import "AppDelegate.h"
@import JumioCore;
@import NetverifyFace;

@interface JumioMobileSDKAuthentication () <AuthenticationControllerDelegate>

@property (nonatomic, strong) AuthenticationController* authenticationController;
@property (nonatomic, strong) UIViewController *authenticationScanViewController;
@property (strong) AuthenticationConfiguration* authenticationConfiguration;
@property (nonatomic) BOOL initiateSuccessful;

@end

@implementation JumioMobileSDKAuthentication

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
  return @[@"EventErrorAuthentication", @"EventAuthentication", @"EventInitiateSuccess"];
}

RCT_EXPORT_METHOD(initAuthentication:(NSString*)apiToken apiSecret:(NSString*)apiSecret dataCenter:(NSString*)dataCenter configuration:(NSDictionary*)configuration) {
  [self initAuthenticationHelper:apiToken apiSecret:apiSecret dataCenter:dataCenter configuration:configuration customization:nil];
}

RCT_EXPORT_METHOD(initAuthenticationWithCustomization:(NSString*)apiToken apiSecret:(NSString*)apiSecret dataCenter:(NSString*)dataCenter configuration:(NSDictionary*)configuration customization:(NSDictionary *)customization) {
  [self initAuthenticationHelper:apiToken apiSecret:apiSecret dataCenter:dataCenter configuration:configuration customization:customization];
}

- (void)initAuthenticationHelper:(NSString*)apiToken apiSecret:(NSString*)apiSecret dataCenter:(NSString*)dataCenter configuration:(NSDictionary*)configuration customization:(NSDictionary*)customization {
  
  if (self.authenticationController) {
    [self.authenticationController destroy];
    self.authenticationScanViewController = nil;
    self.authenticationConfiguration = nil;
    self.authenticationController = nil;
    
  }
  self.authenticationConfiguration = [AuthenticationConfiguration new];
  self.authenticationConfiguration.delegate = self;
  self.authenticationConfiguration.apiToken = apiToken;
  self.authenticationConfiguration.apiSecret = apiSecret;
  
  JumioDataCenter jumioDataCenter = JumioDataCenterUS;
  NSString *dataCenterLowercase = [dataCenter lowercaseString];
  
  if ([dataCenterLowercase isEqualToString: @"eu"]) {
    jumioDataCenter = JumioDataCenterEU;
  } else if ([dataCenterLowercase isEqualToString: @"sg"]) {
    jumioDataCenter = JumioDataCenterSG;
  }

  self.authenticationConfiguration.dataCenter = jumioDataCenter;
  
  // Configuration
  NSString *enrollmentTransactionReference = nil;
  NSString *authenticationTransactionReference = nil;
  
  if (![configuration isEqual:[NSNull null]]) {
    for (NSString *key in configuration) {
      
      if ([key isEqualToString: @"enrollmentTransactionReference"]) {
        enrollmentTransactionReference = [configuration objectForKey: key];
        
      } else if ([key isEqualToString:@"authenticationTransactionReference"]) {
        authenticationTransactionReference = [configuration objectForKey:key];
        
      } else if ([key isEqualToString: @"callbackUrl"]) {
        self.authenticationConfiguration.callbackUrl = [configuration objectForKey: key];
        
      } else if ([key isEqualToString:@"userReference"]) {
        self.authenticationConfiguration.userReference = [configuration objectForKey:key];

      }
    }
  }
  
  // Customization
  if (![customization isEqual:[NSNull null]]) {
      for (NSString *key in customization) {
          if ([key isEqualToString: @"disableBlur"]) {
              [[JumioBaseView jumioAppearance] setDisableBlur: @YES];
          } else if ([key isEqualToString: @"enableDarkMode"]) {
              [[JumioBaseView jumioAppearance] setEnableDarkMode:@YES];
          } else {
              UIColor *color = [self colorWithHexString: [customization objectForKey: key]];
              
              if ([key isEqualToString: @"backgroundColor"]) {
                  [[JumioBaseView jumioAppearance] setBackgroundColor: color];
              } else if ([key isEqualToString: @"tintColor"]) {
                  [[UINavigationBar jumioAppearance] setTintColor: color];
              } else if ([key isEqualToString: @"barTintColor"]) {
                  [[UINavigationBar jumioAppearance] setBarTintColor: color];
              } else if ([key isEqualToString: @"textTitleColor"]) {
                  [[UINavigationBar jumioAppearance] setTitleTextAttributes: @{NSForegroundColorAttributeName: color}];
              } else if ([key isEqualToString: @"foregroundColor"]) {
                  [[JumioBaseView jumioAppearance] setForegroundColor: color];
              } else if ([key isEqualToString: @"positiveButtonBackgroundColor"]) {
                  [[JumioPositiveButton jumioAppearance] setBackgroundColor: color forState:UIControlStateNormal];
              } else if ([key isEqualToString: @"positiveButtonBorderColor"]) {
                  [[JumioPositiveButton jumioAppearance] setBorderColor: color];
              } else if ([key isEqualToString: @"positiveButtonTitleColor"]) {
                  [[JumioPositiveButton jumioAppearance] setTitleColor: color forState:UIControlStateNormal];
              } else if ([key isEqualToString: @"faceOvalColor"]) {
                  [[JumioScanOverlayView jumioAppearance] setFaceOvalColor: color];
              } else if ([key isEqualToString: @"faceProgressColor"]) {
                   [[JumioScanOverlayView jumioAppearance] setFaceProgressColor: color];
              } else if ([key isEqualToString: @"faceFeedbackBackgroundColor"]) {
                   [[JumioScanOverlayView jumioAppearance] setFaceFeedbackBackgroundColor: color];
              } else if ([key isEqualToString: @"faceFeedbackTextColor"]) {
                   [[JumioScanOverlayView jumioAppearance] setFaceFeedbackTextColor: color];
              }
            
          }
      }
  }
  
  self.initiateSuccessful = NO;
  
  if (enrollmentTransactionReference != nil || authenticationTransactionReference != nil){
    if (authenticationTransactionReference != nil) {
      self.authenticationConfiguration.authenticationTransactionReference = authenticationTransactionReference;
    } else {
      self.authenticationConfiguration.enrollmentTransactionReference = enrollmentTransactionReference;
    }
    
    self.authenticationController = [[AuthenticationController alloc] initWithConfiguration:self.authenticationConfiguration];
  }
}

RCT_EXPORT_METHOD(startAuthentication) {
  if (self.authenticationController == nil || !self.initiateSuccessful) {
    NSLog(@"The Authentication SDK has not been initialized yet.");
    return;
  }
  
  dispatch_async(dispatch_get_main_queue(), ^{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window.rootViewController presentViewController: self.authenticationScanViewController animated:YES completion: nil];
  });
}

#pragma mark - Authentication Delegates

- (void)authenticationController:(nonnull AuthenticationController *)authenticationController didFinishInitializingScanViewController:(nonnull UIViewController *)scanViewController {
  self.authenticationScanViewController = scanViewController;
  self.initiateSuccessful = YES;
  NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
  
  [self sendEventWithName:@"EventInitiateSuccess" body: result];
}

- (void)authenticationController:(nonnull AuthenticationController *)authenticationController didFinishWithAuthenticationResult:(AuthenticationResult)authenticationResult transactionReference:(nonnull NSString *)transactionReference {
  NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
  if (authenticationResult == AuthenticationResultSuccess) {
    [result setValue: @"SUCCESS" forKey: @"authenticationResult"];
  } else {
    [result setValue: @"FAILED" forKey: @"authenticationResult"];
  }
  
  [result setValue: transactionReference forKey: @"transactionReference"];
  
  [self.authenticationScanViewController dismissViewControllerAnimated: YES completion: ^{
    [self sendEventWithName:@"EventAuthentication" body: result];
    
    [self.authenticationController destroy];
    self.authenticationConfiguration = nil;
  }];
}

- (void)authenticationController:(nonnull AuthenticationController *)authenticationController didFinishWithError:(nonnull AuthenticationError *)error transactionReference:(NSString * _Nullable)transactionReference {
  
  NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
  [result setValue: error.code forKey: @"errorCode"];
  [result setValue: error.message forKey: @"errorMessage"];
  if (transactionReference) {
    [result setValue: transactionReference forKey: @"transactionReference"];
  }
  
  //Dismiss the SDK
  void (^errorCompletion)(void) = ^{    
    [self sendEventWithName:@"EventErrorAuthentication" body: result];
    
    //Destroy the instance to properly clean up the SDK
    [self.authenticationController destroy];
    self.authenticationController = nil;
  };
  
  if (self.authenticationScanViewController) {
    [self.authenticationScanViewController dismissViewControllerAnimated:YES completion:errorCompletion];
  } else {
    errorCompletion();
  }
}

#pragma mark - Helper methods

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
