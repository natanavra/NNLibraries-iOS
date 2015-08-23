//
//  NSObject+NNAdditions.h
//  NNLibraries
//
//  Created by Natan Abramov on 6/8/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NNAdditions)

+ (void)nnSwizzleInstanceMethod:(SEL)selector toSelector:(SEL)newSelector;
+ (void)nnSwizzleInstanceMethod:(SEL)selector toInstancesOfClass:(Class)cls withSelector:(SEL)newSelector;

+ (void)nnSwizzleClassMethod:(SEL)selector toSelector:(SEL)newSelector;
+ (void)nnSwizzleClassMethod:(SEL)selector toClass:(Class)cls withSelector:(SEL)newSelector;

+ (NSString *)className;
- (NSString *)className;

- (NSString *)fileName;

- (NSString *)nnDescription;

@end
