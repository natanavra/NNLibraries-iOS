//
//  CALayer+NNRuntimeAttributes.m
//  NNLibraries
//
//  Created by Natan Abramov on 1/27/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "CALayer+NNRuntimeAttributes.h"

@implementation CALayer (NNRuntimeAttributes)

- (void)setIBBorderColor:(UIColor *)newColor {
    self.borderColor = newColor.CGColor;
}

- (UIColor *)IBBorderColor {
    return [UIColor colorWithCGColor: self.borderColor];
}

@end
