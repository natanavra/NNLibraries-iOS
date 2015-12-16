//
//  NNMotionManager.m
//  NNLibraries
//
//  Created by Natan Abramov on 2/6/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNMotionManager.h"
#import "NNLogger.h"

#define DEBUG_MOTION 0

#import <CoreMotion/CoreMotion.h>

@interface NNMotionManager ()
@property (nonatomic, strong) CMMotionManager *mgr;
@property (nonatomic, strong) NSOperationQueue *updatesQueue;
@end

@implementation NNMotionManager

#pragma mark - INIT

+ (instancetype)sharedMotionManager {
    static NNMotionManager *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (instancetype)init {
    if(self = [super init]) {
        _mgr = [[CMMotionManager alloc] init];
        _updatesQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

#pragma mark - Device Motion

- (void)updateDeviceMotionWithBlock {
    //Update once a second
    _mgr.deviceMotionUpdateInterval = 1.0;
    [_mgr startDeviceMotionUpdatesToQueue: _updatesQueue withHandler: ^(CMDeviceMotion *motion, NSError *error) {
        if(!error) {
            if(DEBUG_MOTION) {
                [NNLogger logFromInstance: self message: @"Device Motion Handler" data: motion];
            }
        } else {
            [NNLogger logFromInstance: self message: @"Device Motion Error" data: error];
        }
    }];
}

@end
