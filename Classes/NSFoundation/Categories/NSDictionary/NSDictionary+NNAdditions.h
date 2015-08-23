//
//  NSDictionary+NNAdditions.h
//  NNLibraries
//
//  Created by Natan Abramov on 22/07/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NNAdditions)
- (NSDictionary *)nnDictionaryWithValuesOfClass:(Class)cls;
- (NSDictionary *)nnDictionaryByRemovingValuesOfClass:(Class)cls;
- (NSDictionary *)nnDictionaryWithoutNSNulls;
@end

@interface NSMutableDictionary (NNAdditions)
- (void)nnSafeSetObject:(id)object forKey:(id<NSCopying>)key;
- (void)nnRemoveObjectsAndKeysNotOfClass:(Class)cls;
- (void)nnRemoveObjectsAndKeysOfClass:(Class)cls;
- (void)nnRemoveNSNulls;
@end
