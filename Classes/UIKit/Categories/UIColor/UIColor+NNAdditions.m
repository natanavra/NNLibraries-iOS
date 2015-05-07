//
//  UIColor+NNAdditions.m
//  NNLibraries
//
//  Created by Natan Abramov on 4/26/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "UIColor+NNAdditions.h"

@implementation UIColor (NNAdditions)

+ (UIColor *)colorWithR:(NSUInteger)red g:(NSUInteger)green b:(NSUInteger)blue a:(CGFloat)alpha {
    return [self colorWithRed: red/255.0f green: green/255.0f blue: blue/255.0f alpha: alpha];
}

@end
