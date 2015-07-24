//
//  NSDictionary+NNAdditions.h
//  NNLibraries
//
//  Created by Natan Abramov on 22/07/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NNAdditions)
- (NSDictionary *)dictionaryWithValuesOfClass:(Class)cls;
@end

@interface NSMutableDictionary (NNAdditions)
- (void)safeSetObject:(id)object forKey:(id<NSCopying>)key;
- (void)removeObjectsAndKeysNotOfClass:(Class)cls;
@end
