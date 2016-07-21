//
//  NNJSONUtilities.h
//  NNLibraries
//
//  Created by Natan Abramov on 16/07/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNJSONUtilities : NSObject
//object validation methods
+ (id)validObjectFromObject:(id)object;
+ (NSString *)validStringFromObject:(id)object DEPRECATED_MSG_ATTRIBUTE("Behaviour is not defined well, because an empty string is not better than nil. Use 'validObjectFromObject:' instead");
+ (NSInteger)validIntegerFromObject:(id)object;
+ (float)validFloatFromObject:(id)object;
+ (double)validDoubleFromObject:(id)object;
+ (BOOL)validBooleanFromObject:(id)object;
+ (BOOL)validBooleanFromObject:(id)object fallbackValue:(BOOL)fallback;

//JSON parse (NSObjects from NSData)
+ (id)makeValidJSONObject:(id)object;
+ (id)makeValidJSONObject:(id)object shouldReplaceIncompatibleWithStrings:(BOOL)replace;
+ (id)makeValidJSONObject:(id)object invalidValues:(NSMutableDictionary *)invalid DEPRECATED_MSG_ATTRIBUTE("Not working, use makeValidJSONObject: instead");
+ (BOOL)isValidJSONObject:(id)object;
+ (BOOL)isJSONTypeObject:(id)object;
+ (BOOL)isJSONSimpleType:(id)object;

+ (id)parseJSONFromData:(NSData *)data error:(NSError **)error DEPRECATED_MSG_ATTRIBUTE("Use 'JSONObjectFromData:error:' instead");
+ (id)JSONObjectFromData:(NSData *)data error:(NSError **)error;
+ (id)JSONObjectFromData:(NSData *)data withOptions:(NSJSONReadingOptions)options error:(NSError **)error;

//JSON Data from NSObjects
+ (NSData *)JSONDataFromObject:(id)object error:(NSError **)error;
+ (NSData *)JSONDataFromObject:(id)object prettyPrint:(BOOL)pretty error:(NSError **)error;
+ (NSData *)JSONDataFromObject:(id)object prettyPrint:(BOOL)pretty error:(NSError **)error forceValid:(BOOL)force;

//Traversal and lookup
+ (id)valueForKeyPath:(NSString *)keyPath inObject:(id)object;

@end
