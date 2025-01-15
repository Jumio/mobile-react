//
//  JumioMobileSDK.m
//  JumioReactMobileSdk
//
//  Copyright © 2021 Jumio Corporation All rights reserved.
//
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(JumioMobileSDK, RCTEventEmitter)
    RCT_EXTERN_METHOD(initialize:(NSString *)authorizationToken dataCenter:(NSString *)dataCenter)
    RCT_EXTERN_METHOD(setupCustomizations:(NSDictionary *)customizations)
    RCT_EXTERN_METHOD(start)
    RCT_EXTERN_METHOD(isRooted:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
    RCT_EXTERN_METHOD(setPreloaderFinishedBlock:(RCTResponseSenderBlock)completion)
    RCT_EXTERN_METHOD(preloadIfNeeded)
@end

