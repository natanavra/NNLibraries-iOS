//
//  NNJSONUtilities.m
//  NNLibraries
//
//  Created by Natan Abramov on 16/07/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNJSONUtilities.h"
#import "NNConstants.h"
#import "NSError+NNAdditions.h"
#import "NNLogger.h"

@implementation NNJSONUtilities

#pragma mark - Validations

+ (id)validObjectFromObject:(id)object {
    if(object == [NSNull null] || object == nil) {
        return nil;
    }
    return object;
}

+ (NSString *)validStringFromObject:(id)object {
    if([self validObjectFromObject: object]) {
        if([object isKindOfClass: [NSString class]]) {
            return object;
        }
        return [object stringValue];
    }
    return @"";
}

+ (NSInteger)validIntegerFromObject:(id)object {
    if([self validObjectFromObject: object]) {
        return [object integerValue];
    }
    return 0;
}

+ (float)validFloatFromObject:(id)object {
    if([self validObjectFromObject: object]) {
        return [object floatValue];
    }
    return 0.0f;
}

+ (double)validDoubleFromObject:(id)object {
    if([self validObjectFromObject: object]) {
        return [object doubleValue];
    }
    return 0.0;
}

+ (BOOL)validBooleanFromObject:(id)object {
    return [self validBooleanFromObject: object fallbackValue: NO];
}

+ (BOOL)validBooleanFromObject:(id)object fallbackValue:(BOOL)fallback {
    if([self validObjectFromObject: object]) {
        return [object boolValue];
    }
    return fallback;
}

#pragma mark - JSON Parsing

+ (BOOL)isValidJSONObject:(id)object {
    return [NSJSONSerialization isValidJSONObject: object];
}

+ (id)parseJSONFromData:(NSData *)data error:(NSError **)error {
    id object = nil;
    if(!data) {
        if(error) {
            *error = [NSError nnErrorWithCode: kNilObjectError];
        }
    } else {
        object = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingAllowFragments error: error];
    }
    return object;
}

+ (NSData *)JSONDataFromObject:(id)object error:(NSError **)error {
    return [self JSONDataFromObject: object prettyPrint: NO error: error];
}

+ (NSData *)JSONDataFromObject:(id)object prettyPrint:(BOOL)pretty error:(NSError **)error {
    NSData *retData = nil;
    if(!object) {
        if(error) {
            *error = [NSError nnErrorWithCode: kNilObjectError];
        }
    } else if([NSJSONSerialization isValidJSONObject: object]) {
        NSJSONWritingOptions options = pretty ? NSJSONWritingPrettyPrinted : kNilObjectError;
        retData = [NSJSONSerialization dataWithJSONObject: object options: options error: error];
    } else if(error) {
        *error = [NSError nnErrorWithCode: kInvalidJSONObjectError];
    }
    return retData;
}

@end
