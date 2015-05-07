//
//  UIColor+NNAdditions.h
//  NNLibraries
//
//  Created by Natan Abramov on 4/26/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NNAdditions)
/**
 *  Convinience method for creating colors with RGBA values with range 0-255 (Instead of the Apple 0.0 - 1.0)
 *  @warning Alpha values stay the same range 0.0 - 1.0!
 *  @return UIColor with given params
 */
+ (UIColor *)colorWithR:(NSUInteger)red g:(NSUInteger)green b:(NSUInteger)blue a:(CGFloat)alpha;
@end
