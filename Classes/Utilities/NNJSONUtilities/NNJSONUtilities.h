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
+ (NSString *)validStringFromObject:(id)object;
+ (NSInteger)validIntegerFromObject:(id)object;
+ (float)validFloatFromObject:(id)object;
+ (double)validDoubleFromObject:(id)object;
+ (BOOL)validBooleanFromObject:(id)object;
+ (BOOL)validBooleanFromObject:(id)object fallbackValue:(BOOL)fallback;

//JSON parse
+ (BOOL)isValidJSONObject:(id)object;
+ (id)parseJSONFromData:(NSData *)data error:(NSError **)error;
+ (NSData *)JSONDataFromObject:(id)object error:(NSError **)error;
+ (NSData *)JSONDataFromObject:(id)object prettyPrint:(BOOL)pretty error:(NSError **)error;

@end
