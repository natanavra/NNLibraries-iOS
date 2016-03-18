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
#import "NNJSONObject.h"

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
    return [self makeValidJSONObject: object shouldReplaceIncompatibleWithStrings: NO];
}

+ (id)makeValidJSONObject:(id)object shouldReplaceIncompatibleWithStrings:(BOOL)replace {
    //return [self makeValidJSONObject: object invalidValues: nil];
    id retval = nil;
    if([self isValidJSONObject: object] || [self isJSONSimpleType: object]) {
        retval = object;
    } else if([object isKindOfClass: [NSDictionary class]]) {
        NSMutableDictionary *validDict = [NSMutableDictionary dictionary];
        NSDictionary *dict = (NSDictionary *)object;
        [dict enumerateKeysAndObjectsUsingBlock: ^(id key, id value, BOOL *stop) {
            if([self isValidJSONObject: value] || [self isJSONSimpleType: value]) {
                validDict[key] = value;
            } else {
                [validDict nnSafeSetObject: [self makeValidJSONObject: value shouldReplaceIncompatibleWithStrings: replace] forKey: key];
            }
        }];
        retval = validDict;
    } else if([object isKindOfClass: [NSArray class]]) {
        NSMutableArray *validArr = [NSMutableArray array];
        NSArray *arr = (NSArray *)object;
        [arr enumerateObjectsUsingBlock: ^(id value, NSUInteger idx, BOOL *stop) {
            if([self isValidJSONObject: value] || [self isJSONSimpleType: value]) {
                [validArr addObject: value];
            } else {
                [validArr nnSafeAddObject: [self makeValidJSONObject: value shouldReplaceIncompatibleWithStrings: replace]];
            }
        }];
        retval = validArr;
    } else if([object isKindOfClass: [NNJSONObject class]]) {
        retval = [((NNJSONObject *)object) dictionaryRepresentation];
    } else if(replace && [object respondsToSelector: @selector(description)]) {
        retval = [object description];
    }
    
    return retval;
}

+ (id)makeValidJSONObject:(id)object invalidValues:(NSMutableDictionary *)invalid {
    if([self isValidJSONObject: object]) {
        return object;
    }
    if(!invalid) {
        invalid = [NSMutableDictionary dictionary];
    }
    
    id validObject = nil;
    if([self isValidJSONObject: object]) {
        if([object isKindOfClass: [NSDictionary class]]) {
            NSMutableDictionary *valid = [NSMutableDictionary dictionary];
            NSDictionary *dict = (NSDictionary *)object;
            [dict enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
                if([key isKindOfClass: [NSString class]]) {
                    [valid nnSafeSetObject: [self makeValidJSONObject: obj invalidValues: invalid] forKey: key];
                } else {
                    NSString *validKey = [key description];
                    //Transform invalid keys to strings (According to Apple Docs valid JSON all keys are strings)
                    [valid nnSafeSetObject: [self makeValidJSONObject: obj invalidValues: invalid] forKey: validKey];
                }
            }];
            validObject = valid;
        } else if([object isKindOfClass: [NSArray class]]) {
            NSMutableArray *valid = [NSMutableArray array];
            NSArray *arr = (NSArray *)object;
            for(id obj in arr) {
                [valid nnSafeAddObject: [self makeValidJSONObject: obj invalidValues: invalid]];
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
       [self isJSONSimpleType: object]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isJSONSimpleType:(id)object {
    if([object isKindOfClass: [NSString class]] ||
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

#pragma mark - JSON Data from NSObjects

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

#pragma mark - Traversal and lookup

//TODO: this should be in an NSDictionary category
+ (id)valueForKeyPath:(NSString *)keyPath inObject:(id)object {
    if(keyPath.length == 0) {
        return nil;
    }
    
    NSArray *dotComps = [keyPath componentsSeparatedByString: @"."];
    id jumper = object;
    for(NSString *key in dotComps) {
        //Allow a user to pass a key corresponding to array without an index, only if the array has one item inside.
        if([jumper isKindOfClass: [NSArray class]]) {
            NSArray *array = (NSArray *)jumper;
            if(array.count == 1) {
                jumper = array[0];
            }
        }
        
        //If we're not in a dictionary and we're still drilling down - exit the loop, the key is irrelevant.
        if(![jumper isKindOfClass: [NSDictionary class]]) {
            jumper = nil;
            break;
        }
    
        //Search for bracket in the key (to support arrays)
        NSRange openBracketRange = [key rangeOfString: @"["];
        if(openBracketRange.location != NSNotFound) {
            NSString *clearKey = [key substringToIndex: openBracketRange.location];
            jumper = [jumper objectForKey: clearKey];
            //Will be set to 'YES' only if we found a closing bracket and there was a valid numeric value inside.
            BOOL valid = NO;
            
            if([jumper isKindOfClass: [NSArray class]]) {
                NSRange closeBracketRange = [key rangeOfString: @"]"];
                if(closeBracketRange.location != NSNotFound) {
                    NSRange inBracketRange = NSMakeRange(openBracketRange.location, closeBracketRange.location - openBracketRange.location);
                    NSString *inBracketString = [key substringWithRange: inBracketRange];
                    NSCharacterSet *numbersSet = [NSCharacterSet decimalDigitCharacterSet];
                    NSString *clearValue = [inBracketString stringByTrimmingCharactersInSet: [numbersSet invertedSet]];
                    if(clearValue.length > 0) {
                        NSInteger bracketValue = [clearValue integerValue];
                        NSArray *array = (NSArray *)jumper;
                        if(bracketValue >= 0 && bracketValue < array.count) {
                            valid = YES;
                            jumper = array[bracketValue];
                        }
                    }
                }
            }
            
            if(!valid) {
                jumper = nil;
            }
        } else {
            jumper = [jumper objectForKey: key];
        }
        
        if(jumper == nil) {
            break;
        }
    }
    return jumper;
}


@end
