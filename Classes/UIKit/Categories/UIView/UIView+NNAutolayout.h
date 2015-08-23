//
//  UIView+Autolayout.h
//  NNLibraries
//
//  Created by Natan Abramov on 6/8/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NNAutolayout)
- (void)removeConstraintsForView:(UIView *)view;
- (void)distributeViews:(NSArray *)views horizontallyWithMarginsFromSuperView:(CGFloat)margin;
- (void)alignToSuperviewCenterX;
- (void)alignToSuperviewCenterY;
- (void)alignToSuperviewCenters;

- (UIView *)spacerView;
@end
