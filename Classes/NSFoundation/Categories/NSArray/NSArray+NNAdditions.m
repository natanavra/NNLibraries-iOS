//
//  NSArray+NNAdditions.m
//  NNLibraries
//
//  Created by Natan Abramov on 22/07/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NSArray+NNAdditions.h"

@implementation NSArray (NNAdditions)

- (NSArray *)arrayWithValuesOfClass:(Class)cls {
    NSMutableArray *cleanedArray = [NSMutableArray arrayWithArray: self];
    [cleanedArray removeObjectsNotOfClass: cls];
    return [cleanedArray copy];
}

+ (NSArray *)uniqueCopyArray:(NSArray *)array {
    NSSet *set = [NSSet setWithArray: array];
    return [set allObjects];
}

@end


@implementation  NSMutableArray (NNAdditions)

- (void)removeObjectsNotOfClass:(Class)cls {
    NSMutableArray *cleanObjects = [NSMutableArray array];
    for(id object in self) {
        if(![object isKindOfClass: cls]) {
            [cleanObjects addObject: object];
        }
    }
    [cleanObjects removeObjectsInArray: cleanObjects];
}

- (BOOL)nnSafeAddObject:(id)object {
    if(object) {
        [self addObject: object];
        return YES;
    }
    return NO;
}

@end
