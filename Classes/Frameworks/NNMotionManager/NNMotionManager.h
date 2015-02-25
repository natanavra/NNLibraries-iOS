//
//  NNMotionManager.h
//  NNLibraries
//
//  Created by Natan Abramov on 2/6/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NNMotionManager : NSObject
+ (instancetype)sharedMotionManager;

- (void)updateDeviceMotionWithBlock;
@end
