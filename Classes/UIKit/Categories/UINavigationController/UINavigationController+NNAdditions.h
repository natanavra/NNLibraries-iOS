//
//  UINavigationController+NNAdditions.h
//  NNLibraries
//
//  Created by Natan Abramov on 2/3/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NNAnimationDirection) {
    NNAnimationDirectionFromTop = 0,
    NNAnimationDirectionFromRight,
    NNAnimationDirectionFromBottom,
    NNAnimationDirectionFromLeft
};

@interface UINavigationController (NNAdditions)
- (void)pushViewController:(UIViewController *)controller fromDirection:(NNAnimationDirection)direction;
- (void)popViewControllerToDirection:(NNAnimationDirection)direction;
- (void)setViewControllers:(NSArray *)viewControllers withAnimationFromDirection:(NNAnimationDirection)direction;

- (void)pushViewControllerFromBottom:(UIViewController *)controller;
- (void)popViewControllerFromBottom;
@end
