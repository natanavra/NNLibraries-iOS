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

- (NSString *)fileName {
    return [[NSString stringWithUTF8String: __FILE__] lastPathComponent];
}

- (NSString *)nnDescription {
    NSString *description = nil;
    if([self isKindOfClass: [NSString class]]) {
        description = (NSString *)self;
    } else if([self isKindOfClass: [NSData class]]) {
        description = [[NSString alloc] initWithData: (NSData *)self encoding: NSUTF8StringEncoding];
    } else if([self isKindOfClass: [NSDictionary class]]) {
        
    }
    
    if(!description || description.length == 0) {
        description = [self description];
    }
    return description;
}

@end
