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
    RCT_EXTERN_METHOD(start)
    RCT_EXTERN_METHOD(isRooted:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
@end

