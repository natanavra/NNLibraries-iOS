//
//  NNJSONObject.h
//  NNLibraries
//
//  Created by Natan Abramov on 3/20/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#ifndef NNJSONObject_HEADER
#define NNJSONObject_HEADER

#import <Foundation/Foundation.h>

@protocol NNJSONObject <NSObject>
@required
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;
@optional
- (NSDictionary *)jsonRepresentation DEPRECATED_MSG_ATTRIBUTE("Implement `dictionaryRepresentation` instead"); //Deprecated
@end

@interface NNJSONObject : NSObject <NNJSONObject, NSCoding>
- (id)validObjectFromObject:(id)object;
- (NSInteger)validIntegerFromObject:(id)object;
- (float)validFloatFromObject:(id)object;
- (double)validDoubleFromObject:(id)object;
- (BOOL)validBooleanFromObject:(id)object;
- (BOOL)validBooleanFromObject:(id)object fallbackValue:(BOOL)fallback;

@end

#endif