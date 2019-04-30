//
//  JumioMobileSDKAuthentication.m
//
//  Copyright © 2019 Jumio Corporation All rights reserved.
//

#import "JumioMobileSDKAuthentication.h"
#import "AppDelegate.h"
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
  return @[@"EventError", @"EventAuthentication", @"EventInitiateSuccess"];
}

RCT_EXPORT_METHOD(initAuthentication:(NSString*)apiToken apiSecret:(NSString*)apiSecret dataCenter:(NSString*)dataCenter configuration:(NSDictionary*)configuration) {
  [self initAuthenticationHelper:apiToken apiSecret:apiSecret dataCenter:dataCenter configuration:configuration customization:nil];
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
  NSString* dataCenterLowercase = [dataCenter lowercaseString];
  self.authenticationConfiguration.dataCenter = [dataCenterLowercase isEqualToString:@"eu"] ? JumioDataCenterEU : JumioDataCenterUS;
  
  // Configuration
  if (![configuration isEqual:[NSNull null]]) {
    for (NSString *key in configuration) {
      if ([key isEqualToString: @"enrollmentTransactionReference"]) {
        self.authenticationConfiguration.enrollmentTransactionReference = [configuration objectForKey: key];
        
      } else if ([key isEqualToString: @"callbackUrl"]) {
        self.authenticationConfiguration.callbackUrl = [configuration objectForKey: key];
        
      } else if ([key isEqualToString:@"userReference"]) {
        self.authenticationConfiguration.userReference = [configuration objectForKey:key];

      }
    }
  }
  
  self.initiateSuccessful = NO;
  
  self.authenticationController = [[AuthenticationController alloc] initWithConfiguration:self.authenticationConfiguration];
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
    [self sendEventWithName:@"EventError" body: result];
    
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

@end
