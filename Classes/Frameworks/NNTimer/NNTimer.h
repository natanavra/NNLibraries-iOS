//
//  NNTimer.h
//  NNLibraries
//
//  Created by Natan Abramov on 11/2/15.
//  Copyright © 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NNTimer;

typedef void(^NNTimerBlock)(NNTimer *timer);

@interface NNTimer : NSObject

@property (nonatomic, strong, readonly) id userInfo;
@property (nonatomic, readonly) NSTimeInterval interval;
@property (nonatomic, readonly) BOOL repeats;

+ (instancetype)scheduledTimerWithInterval:(NSTimeInterval)interval userInfo:(id)info repeats:(BOOL)repeats block:(NNTimerBlock)block;
- (instancetype)initWithInterval:(NSTimeInterval)interval userInfo:(id)info repeats:(BOOL)repeats block:(NNTimerBlock)block;

- (void)invalidate;
- (BOOL)isValid;

@end
