//
//  NSDictionary+NNAdditions.m
//  NNLibraries
//
//  Created by Natan Abramov on 22/07/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NSDictionary+NNAdditions.h"

@implementation NSDictionary (NNAdditions)

- (NSDictionary *)dictionaryWithValuesOfClass:(Class)cls {
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary: self];
    [newDict removeObjectsAndKeysNotOfClass: cls];
    return [newDict copy];
}

@end


@implementation NSMutableDictionary (NNAdditions)

#pragma mark - NNAdditions

- (void)safeSetObject:(id)object forKey:(id<NSCopying>)key {
    if(!object || !key) {
        return;
    }
    self[key] = object;
}

- (void)removeObjectsAndKeysNotOfClass:(Class)cls {
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

@end
