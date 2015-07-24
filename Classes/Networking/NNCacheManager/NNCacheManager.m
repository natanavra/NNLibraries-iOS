//
//  NNCacheManager.m
//  NNLibraries
//
//  Created by Natan Abramov on 3/20/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNCacheManager.h"

@implementation NNCacheManager

+ (instancetype)sharedCache {
    static id _shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (instancetype)init {
    if(self = [super init]) {
        
    }
    return self;
}

@end
