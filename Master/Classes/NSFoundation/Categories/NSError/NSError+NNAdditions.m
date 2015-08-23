//
//  NSError+NNAdditions.m
//  NNLibraries
//
//  Created by Natan Abramov on 16/07/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NSError+NNAdditions.h"

NSString *const kNNErrorDomain = @"com.NNLibraries.error";

@implementation NSError (NNAdditions)

+ (NSError *)nnErrorWithCode:(NSUInteger)code {
    return [NSError errorWithDomain: kNNErrorDomain code: code userInfo: @{@"description" : [self errorDescriptionWithCode: code]}];
}

+ (NSString *)errorDescriptionWithCode:(NSUInteger)code {
    NSString *retVal = nil;
    switch(code) {
        case kNilObjectError:
            retVal = @"Object must not be nil";
            break;
        case kInvalidJSONObjectError:
            retVal = @"Not a valid JSON object";
            break;
        default:
            retVal = @"";
            break;
    }
    return retVal;
}

@end
