//
//  NSString+NNAdditions.m
//  NNLibraries
//
//  Created by Natan Abramov on 3/5/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NSString+NNAdditions.h"

@implementation NSString (NNAdditions)

- (NSString *)stringByTrimmingWhiteSpace {
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByRemovingAllWhiteSpace {
    return [self stringByReplacingOccurrencesOfString: @" " withString: @""];
}

@end
