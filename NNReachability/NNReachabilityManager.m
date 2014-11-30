//
//  ReachabilityManager.m
//  iSale
//
//  Created by Natan Abramov on 6/16/14.
//  Copyright (c) 2014 Natan Abramov. All rights reserved.
//

#import "NNReachabilityManager.h"
#import "Reachability.h"

@interface NNReachabilityManager()
@property (nonatomic, strong) Reachability *reach;
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
        self.reach = [Reachability reachabilityWithHostName: @"www.google.com"];
        _reach.reachableOnWWAN = YES;
        __weak typeof(self) weakSelf = self;
        [_reach setReachableBlock: ^(Reachability *r) {
            //To keep ARC calm
            __strong typeof(self) strongSelf = weakSelf;
            if(strongSelf && strongSelf->_callback) {
                strongSelf->_callback(strongSelf->_reach.isReachable);
            }
            NSLog(@"Reachable");
        }];
        [_reach setUnreachableBlock: ^(Reachability *r) {
            //To keep ARC calm
            __strong typeof(self) strongSelf = weakSelf;
            if(strongSelf && strongSelf->_callback) {
                strongSelf->_callback(strongSelf->_reach.isReachable);
            }
            NSLog(@"NOT Reachable!");
        }];
        [_reach startNotifier];
    }
    return self;
}

- (BOOL)isReachable {
    return [_reach isReachable];
}

- (void)setReachabilityChangedBlock:(void(^)(BOOL reachable))block {
    _callback = block;
}

@end
