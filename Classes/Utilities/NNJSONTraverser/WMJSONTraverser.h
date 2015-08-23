//
//  JSONTraverser.h
//  sandbox
//
//  Created by Natan Abramov on 12/17/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMJSONTraverser : NSObject

- (instancetype)initWithJSONData:(NSData *)data error:(NSError *)error;

/** Supports only NSArray and NSDictionary data types */
- (instancetype)initWithJSONObject:(id)object;

/** Use this for traversing objects outside of the current jsonObject in the traverser. */
+ (id)valueForTraversalPath:(NSString *)path inObject:(id)jsonObject;

/** Groups objects in collection found in the path by the value provided. e.g. group: @"flights" byValue: @"price.amount".
    If the collection or the value can't be found, an empty array will be returned. */
- (NSArray *)groupCollectionInPath:(NSString *)path byValue:(NSString *)value;

/** e.g. "object.item[1].value" */
- (id)valueForTraversalPath:(NSString *)path;
- (void)setValueForTraversalPath:(NSString *)path value:(id)newValue;
- (id)rootJsonObject;

- (NSInteger)numberOfObjectsInArrayForPath:(NSString *)path;

@end

@interface WMJSONTraverser (Extended)
- (id)objectForKey:(id)key;
- (id)objectForKeyedSubscript:(id)key;
@end