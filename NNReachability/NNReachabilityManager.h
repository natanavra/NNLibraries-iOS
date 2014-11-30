//
//  ReachabilityManager.h
//  iSale
//
//  Created by Natan Abramov on 6/16/14.
//  Copyright (c) 2014 Natan Abramov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNReachabilityManager : NSObject {
}
@property (nonatomic, weak) void (^callback)(BOOL reachable);
+ (NNReachabilityManager *)sharedManager;
- (BOOL)isReachable;
- (void)setReachabilityChangedBlock:(void(^)(BOOL reachable))block;
@end
