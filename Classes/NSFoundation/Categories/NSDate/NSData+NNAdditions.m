//
//  NSData+NNAdditions.m
//  NNLibraries
//
//  Created by Natan Abramov on 4/5/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NSData+NNAdditions.h"

@implementation NSData (NNAdditions)

- (NSString *)hexString {
    NSString *desc = [self description];
    NSString *trim = [desc stringByTrimmingCharactersInSet: [self descriptionCharacterSet]];
    return [trim stringByReplacingOccurrencesOfString: @" " withString: @""];
}

- (NSCharacterSet *)descriptionCharacterSet {
    static NSCharacterSet *charSet = nil;
    if(!charSet) {
        charSet = [NSCharacterSet characterSetWithCharactersInString: @"< >"];
    }
    return charSet;
}

@end
