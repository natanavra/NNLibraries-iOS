//
//  ReachabilityManager.h
//  iSale
//
//  Created by Natan Abramov on 6/16/14.
//  Copyright (c) 2014 Natan Abramov. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kReachabilityChangedNotification;

@interface NNReachabilityManager : NSObject {
}
+ (NNReachabilityManager *)sharedManager;
- (BOOL)isReachable;

@end
