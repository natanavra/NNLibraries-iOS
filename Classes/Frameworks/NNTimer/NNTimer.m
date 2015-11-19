//
//  NNTimer.m
//  NNLibraries
//
//  Created by Natan Abramov on 11/2/15.
//  Copyright © 2015 natanavra. All rights reserved.
//

#import "NNTimer.h"
#import <objc/runtime.h>

@interface NNTimer ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) NNTimerBlock block;
@end

@implementation NNTimer

+ (instancetype)scheduledTimerWithInterval:(NSTimeInterval)interval userInfo:(id)info repeats:(BOOL)repeats block:(NNTimerBlock)block {
    return [[self alloc] initWithInterval: interval userInfo: info repeats: repeats block: block];
}

- (instancetype)initWithInterval:(NSTimeInterval)interval userInfo:(id)info repeats:(BOOL)repeats block:(NNTimerBlock)block {
    if(self = [super init]) {
        self.block = block;
        _interval = interval;
        _userInfo = info;
        _repeats = repeats;
        _timer = [NSTimer scheduledTimerWithTimeInterval: interval target: self selector: @selector(tick) userInfo: nil repeats: repeats];
    }
    return self;
}

- (void)tick {
    if(_block) {
        _block(self);
    }
}

- (void)invalidate {
    [_timer invalidate];
}

- (BOOL)isValid {
    return [_timer isValid];
}

@end
