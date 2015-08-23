//
//  JSONTraverser.m
//  sandbox
//
//  Created by Natan Abramov on 12/17/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "WMJSONTraverser.h"
#import "Logger.h"

@interface WMJSONTraverser ()

@property (nonatomic,strong) id jsonObject;

@end

@implementation WMJSONTraverser

- (instancetype)initWithJSONData:(NSData *)data error:(NSError *)error {
    if(self = [super init]) {
        _jsonObject = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &error];
        if(error) {
            [Logger logDebugFromSender: self withMessage: @"Error reading JSON" withData: error];
            return nil;
        }
    }
    return self;
}

- (instancetype)initWithJSONObject:(id)object {
    //If not of type NSDictionary or NSArray, do not create the object.
    if(![object isKindOfClass: NSDictionary.class] && ![object isKindOfClass: NSArray.class]) {
        return nil;
    }
    
    if(self = [super init]) {
        _jsonObject = object;
    }
    return self;
}

- (id)rootJsonObject {
    return [_jsonObject copy];;
}

- (id)valueForTraversalPath:(NSString *)path {
    return [WMJSONTraverser valueForTraversalPath: path inObject: _jsonObject];
}

+ (id)valueForTraversalPath:(NSString *)path inObject:(id)jsonObject {
    NSArray *components = [path componentsSeparatedByString: @"."];
    id currentObject = jsonObject;
    for(NSString *objectName in components) {
        NSRange bracketRange = [objectName rangeOfString: @"["];
        if(bracketRange.location != NSNotFound) {
            if([currentObject isKindOfClass: NSDictionary.class]) {
                NSString *arrayKey = [objectName substringToIndex: bracketRange.location];
                currentObject = [self dictionaryFromObject: currentObject];
                if(currentObject) {
                    currentObject = [currentObject objectForKey: arrayKey];
                }
            }
            
            if([currentObject isKindOfClass: NSArray.class]) {
                NSArray *currentArray = (NSArray *)currentObject;
                
                NSRange bracketValueRange = [objectName rangeOfString: @"["];
                bracketValueRange.length = [objectName rangeOfString: @"]"].location - bracketValueRange.location;
                NSString *bracesStringValue = [objectName substringWithRange: bracketValueRange];
                NSInteger bracesValue = [self numberFromString: bracesStringValue];
                
                if(bracesValue >= 0 && bracesValue < currentArray.count) {
                    currentObject = currentObject[bracesValue];
                } else {
                    [Logger logDebugFromSender: self withMessage: @"The index in the brackets is out of bounds" withData: objectName];
                    currentObject = nil;
                }
            }
            
        } else {
            currentObject = [self dictionaryFromObject: currentObject];
            if(currentObject) {
                currentObject = [currentObject objectForKey: objectName];
            }
        }
        
        if(currentObject == nil) {
            [Logger logDebugFromSender: self withMessage: @"Key not found" withData: objectName];
            break;
        }
    }
    return currentObject;
}

- (void)setValueForTraversalPath:(NSString *)path value:(id)newValue {
    NSMutableArray *components = [NSMutableArray arrayWithArray: [path componentsSeparatedByString: @"."]];
    NSString *key = [components lastObject];
    [components removeLastObject];
    id object = [self valueForTraversalPath: [components lastObject]];
    if([object isKindOfClass: NSMutableDictionary.class]) {
        NSMutableDictionary *dict = (NSMutableDictionary *)object;
        [dict setObject: newValue forKey: key];
    }
}

//group: flights byValue: price.amount
- (NSArray *)groupCollectionInPath:(NSString *)path byValue:(NSString *)value {
    id collection = [self valueForTraversalPath: path];
    NSMutableArray *groups = [NSMutableArray array];
    if(collection) {
        NSString *distinctPredicateFormat = [@"@distinctUnionOfObjects." stringByAppendingString: value];
        NSArray *filteredValues = [collection valueForKeyPath: distinctPredicateFormat];
        for(id object in filteredValues) {
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                if([evaluatedObject isKindOfClass: [NSDictionary class]]) {
                    id compareValue = [WMJSONTraverser valueForTraversalPath: value inObject: evaluatedObject];
                    return [compareValue isEqual: object];
                }
                return NO;
            }];
            NSArray *group = [collection filteredArrayUsingPredicate: predicate];
            [groups addObject: group];
        }
    }
    return groups;
}

#pragma mark - Special Traversal

- (NSInteger)numberOfObjectsInArrayForPath:(NSString *)path {
    id object = [self valueForTraversalPath: path];
    if([object isKindOfClass: NSArray.class]) { 
        NSArray *array = (NSArray *)object;
        return array.count;
    }
    return 0;
}

#pragma mark - Helpers

+ (NSDictionary *)dictionaryFromObject:(id)object {
    if([object isKindOfClass: NSDictionary.class]) {
        return object;
    } else {
        return nil;
    }
}

/** Returns 0 if not a valid number. */
+ (NSInteger)numberFromString:(NSString *)value {
    static NSCharacterSet *numberSet = nil;
    if(!numberSet) {
        numberSet = [NSCharacterSet characterSetWithCharactersInString: @"1234567890"];
    }
    
    NSString *clearedValue = [value stringByTrimmingCharactersInSet: [numberSet invertedSet]];
    return [clearedValue integerValue];
}

@end


@implementation WMJSONTraverser (Extended)

- (id)objectForKey:(id)key {
    return [self valueForTraversalPath: key];
}

- (id)objectForKeyedSubscript:(id)key {
    return [self valueForTraversalPath: key];
}

@end

