//
//  ReachabilityManager.m
//  iSale
//
//  Created by Natan Abramov on 6/16/14.
//  Copyright (c) 2014 Natan Abramov. All rights reserved.
//

#import "NNReachabilityManager.h"
#import "NNReachability.h"
#import "NNLogger.h"

@interface NNReachabilityManager()
@property (nonatomic, strong) NNReachability *reach;
@property (nonatomic, readwrite, copy) NNReachabilityChangedBlock callback;
@end

@implementation NNReachabilityManager

+ (NNReachabilityManager *)sharedManager {
    static NNReachabilityManager *_reach = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _reach = [[self alloc] init];
    });
    return _reach;
}

- (id)init {
    if(self = [super init]) {
        self.reach = [NNReachability reachabilityForInternetConnection];
        _reach.reachableOnWWAN = YES;
        
        __weak typeof(self) weakSelf = self;
        [_reach setReachableBlock: ^(NNReachability *r) {
            [NNLogger logFromInstance: weakSelf message: @"Internet is reachable"];
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if(strongSelf.callback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.callback(YES);
                });
            }
        }];
        [_reach setUnreachableBlock: ^(NNReachability *r) {
            [NNLogger logFromInstance: weakSelf message: @"Internet not reachable"];
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if(strongSelf.callback) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.callback(NO);
                });
            }
        }];
        [_reach startNotifier];
    }
    return self;
}

- (void)invokeCallback {
    if(_callback) {
        _callback([self isReachable]);
    }
}

- (void)setReachabilityChangedCallback:(NNReachabilityChangedBlock)callback {
    self.callback = callback;
}

- (BOOL)isReachable {
    return [_reach isReachable];
}

- (BOOL)isReachableViaWiFi {
    return [_reach isReachableViaWiFi];
}

- (BOOL)isReachableViaCellular {
    return [_reach isReachableViaWWAN];
}

@end
