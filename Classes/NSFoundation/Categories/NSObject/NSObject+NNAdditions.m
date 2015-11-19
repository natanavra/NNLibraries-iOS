//
//  NSObject+NNAdditions.m
//  NNLibraries
//
//  Created by Natan Abramov on 6/8/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+NNAdditions.h"
#import "NNJSONUtilities.h"
#import "NSData+NNAdditions.h"

@implementation NSObject (NNAdditions)

//TODO: get back to swizzling implementations, possibly not correct

+ (void)nnSwizzleInstanceMethod:(SEL)selector toSelector:(SEL)newSelector {
    [self nnSwizzleInstanceMethod: selector toInstancesOfClass: self withSelector: newSelector];
}

+ (void)nnSwizzleInstanceMethod:(SEL)selector toInstancesOfClass:(Class)cls withSelector:(SEL)newSelector {
    Method original = class_getInstanceMethod(self, selector);
    Method swizzled = class_getInstanceMethod(cls, newSelector);

    BOOL added = class_addMethod(cls, newSelector, method_getImplementation(swizzled), method_getTypeEncoding(swizzled));
    if(added) {
        class_replaceMethod(cls, selector, method_getImplementation(swizzled), method_getTypeEncoding(swizzled));
    } else {
        method_exchangeImplementations(original, swizzled);
    }
}

+ (void)nnSwizzleClassMethod:(SEL)selector toSelector:(SEL)newSelector {
    [self nnSwizzleClassMethod: selector toClass: self withSelector: newSelector];
}

+ (void)nnSwizzleClassMethod:(SEL)selector toClass:(Class)cls withSelector:(SEL)newSelector {
    Method original = class_getClassMethod(self, selector);
    Method swizzled = class_getClassMethod(cls, newSelector);
    
    IMP swizzledImp = method_getImplementation(swizzled);
    const char *swizzledTypeEnc = method_getTypeEncoding(swizzled);
    
    Class c = object_getClass(cls);
    if(c) {
        BOOL added = class_addMethod(c, newSelector, swizzledImp, swizzledTypeEnc);
        if(added) {
            class_replaceMethod(c, selector, swizzledImp, swizzledTypeEnc);
        } else {
            method_exchangeImplementations(original, swizzled);
        }
    }
}

+ (NSString *)className {
    return NSStringFromClass([self class]);
}

- (NSString *)className {
    return NSStringFromClass([self class]);
}

- (NSString *)fileName {
    return [[NSString stringWithUTF8String: __FILE__] lastPathComponent];
}

- (NSString *)nnDescription {
    NSString *description = nil;
    if([self isKindOfClass: [NSString class]]) {
        description = (NSString *)self;
    } else if([self isKindOfClass: [NSData class]]) {
        NSData *data = (NSData *)self;
        description = [data nnStringWithEncoding: NSUTF8StringEncoding];
    } else if([self isKindOfClass: [NSDictionary class]] || [self isKindOfClass: [NSArray class]]) {
        description = [self debugDescription];
//        NSError *err = nil;
//        NSData *jsonData = [NNJSONUtilities JSONDataFromObject: self prettyPrint: YES error: &err];
//        if(jsonData) {
//            description = [jsonData nnStringWithEncoding: NSUTF8StringEncoding];
//        } else {
//            description = nil;
//        }
    }
    
    if((!description || description.length == 0) && ![self isKindOfClass: [NSData class]]) {
        description = [self description];
    }
    return description;
}

@end
