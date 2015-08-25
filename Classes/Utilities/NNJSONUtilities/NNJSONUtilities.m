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
#import "NSDictionary+NNAdditions.h"
#import "NSArray+NNAdditions.h"

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

+ (id)makeValidJSONObject:(id)object {
    return [self makeValidJSONObject: object invalidValues: nil];
}

+ (id)makeValidJSONObject:(id)object invalidValues:(NSDictionary **)invalid {
    if([self isValidJSONObject: object]) {
        return object;
    }
    
    id validObject = nil;
    if([self isJSONTypeObject: object]) {
        if([object isKindOfClass: [NSDictionary class]]) {
            NSMutableDictionary *valid = [NSMutableDictionary dictionary];
            NSDictionary *dict = (NSDictionary *)object;
            [dict enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
                if([key isKindOfClass: [NSString class]]) {
                    [valid nnSafeSetObject: [self makeValidJSONObject: obj invalidValues: nil] forKey: key];
                } else {
                    NSString *validKey = [key description];
                    //Transform invalid keys to strings (According to Apple Docs valid JSON all keys are strings)
                    [valid nnSafeSetObject: [self makeValidJSONObject: obj invalidValues: nil] forKey: validKey];
                }
            }];
            validObject = valid;
        } else if([object isKindOfClass: [NSArray class]]) {
            NSMutableArray *valid = [NSMutableArray array];
            NSArray *arr = (NSArray *)object;
            for(id obj in arr) {
                [valid nnSafeAddObject: [self makeValidJSONObject: obj invalidValues: nil]];
            }
            validObject = valid;
        } else {
            validObject = object;
        }
    } else {
        //Transforming invalid objects to strings
        validObject = [object description];
    }
    return validObject;
}

+ (BOOL)isJSONTypeObject:(id)object {
    //According to Apple Docs these are the only valid classes for JSON objects
    if([object isKindOfClass: [NSArray class]] ||
       [object isKindOfClass: [NSDictionary class]] ||
       [object isKindOfClass: [NSString class]] ||
       [object isKindOfClass: [NSNumber class]] ||
       [object isKindOfClass: [NSNull class]]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isValidJSONObject:(id)object {
    return [NSJSONSerialization isValidJSONObject: object];
}

+ (id)parseJSONFromData:(NSData *)data error:(NSError **)error {
    return [self JSONObjectFromData: data withOptions: kNilOptions error: error];
}

+ (id)JSONObjectFromData:(NSData *)data error:(NSError **)error {
    return [self JSONObjectFromData: data withOptions: kNilOptions error: error];
}

+ (id)JSONObjectFromData:(NSData *)data withOptions:(NSJSONReadingOptions)options error:(NSError **)error {
    id object = nil;
    if(!data) {
        if(error) {
            *error = [NSError nnErrorWithCode: kNilObjectError];
        }
    } else {
        if(options == kNilOptions) {
            options = NSJSONReadingAllowFragments;
        }
        object = [NSJSONSerialization JSONObjectWithData: data options: options error: error];
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
