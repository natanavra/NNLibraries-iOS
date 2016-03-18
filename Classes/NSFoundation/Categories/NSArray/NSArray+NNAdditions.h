//
//  NSArray+NNAdditions.h
//  NNLibraries
//
//  Created by Natan Abramov on 22/07/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NNAdditions)
+ (NSArray *)uniqueCopyArray:(NSArray *)array;
- (NSArray *)arrayWithValuesOfClass:(Class)cls;
@end


@interface NSMutableArray (NNAdditions)
- (void)removeObjectsNotOfClass:(Class)cls;
- (BOOL)nnSafeAddObject:(id)object;
@end

