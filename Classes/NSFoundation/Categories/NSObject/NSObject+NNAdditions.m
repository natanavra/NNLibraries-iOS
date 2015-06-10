//
//  NSObject+NNAdditions.m
//  NNLibraries
//
//  Created by Natan Abramov on 6/8/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NSObject+NNAdditions.h"

@implementation NSObject (NNAdditions)

+ (NSString *)className {
    return NSStringFromClass([self class]);
}

- (NSString *)className {
    return NSStringFromClass([self class]);
}

@end
