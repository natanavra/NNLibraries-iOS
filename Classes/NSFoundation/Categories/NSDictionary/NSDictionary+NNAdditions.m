//
//  NSDictionary+NNAdditions.m
//  NNLibraries
//
//  Created by Natan Abramov on 22/07/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NSDictionary+NNAdditions.h"

@implementation NSDictionary (NNAdditions)

- (NSDictionary *)nnDictionaryWithValuesOfClass:(Class)cls {
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary: self];
    [newDict nnRemoveObjectsAndKeysNotOfClass: cls];
    return newDict;
}

- (NSDictionary *)nnDictionaryByRemovingValuesOfClass:(Class)cls {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: self];
    [dict nnRemoveObjectsAndKeysOfClass: cls];
    return dict;
}

- (NSDictionary *)nnDictionaryWithoutNSNulls {
    return [self nnDictionaryByRemovingValuesOfClass: [NSNull class]];
}

@end


@implementation NSMutableDictionary (NNAdditions)

#pragma mark - NNAdditions

- (void)nnSafeSetObject:(id)object forKey:(id<NSCopying>)key {
    if(!object || !key) {
        return;
    }
    self[key] = object;
}

- (void)nnRemoveObjectsAndKeysNotOfClass:(Class)cls {
    NSMutableArray *badKeys = [NSMutableArray array];
    for(id keyObject in self) {
        BOOL bad = NO;
        if(![keyObject isKindOfClass: cls]) {
            bad = YES;
        } else if(![self[keyObject] isKindOfClass: cls]) {
            bad = YES;
        }
        
        if(bad) {
            [badKeys addObject: keyObject];
        }
    }
    [self removeObjectsForKeys: badKeys];
}

- (void)nnRemoveObjectsAndKeysOfClass:(Class)cls {
    NSMutableArray *badKeys = [NSMutableArray array];
    for(id keyObject in self) {
        BOOL bad = NO;
        if([keyObject isKindOfClass: cls]) {
            bad = YES;
        } else if([self[keyObject] isKindOfClass: cls]) {
            bad = YES;
        }
        
        if(bad) {
            [badKeys addObject: keyObject];
        }
    }
    [self removeObjectsForKeys: badKeys];
}

- (void)nnRemoveNSNulls {
    [self nnRemoveObjectsAndKeysOfClass: [NSNull class]];
}

@end
