//
//  UINavigationController+NNAdditions.m
//  NNLibraries
//
//  Created by Natan Abramov on 2/3/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "UINavigationController+NNAdditions.h"

NSTimeInterval kDefaultAnimationDuration = 0.3f;

@implementation UINavigationController (NNAdditions)

- (void)pushViewControllerFromBottom:(UIViewController *)controller {
    [self animateViewController: controller animation: kCATransitionMoveIn fromDirection: kCATransitionFromTop];
}

- (void)popViewControllerFromBottom {
    [self animatePopWithAnimation: kCATransitionReveal fromDirection: kCATransitionFromBottom];
}

- (void)animateViewController:(UIViewController *)controller animation:(NSString *)animationType fromDirection:(NSString *)direction {
    CATransition *transition = [self transitionAnimationWithType: animationType fromDirection: direction];
    [self.view.layer addAnimation: transition forKey: nil];
    [self pushViewController: controller animated: NO];
}

- (void)animatePopWithAnimation:(NSString *)animationType fromDirection:(NSString *)direction {
    CATransition *transition = [self transitionAnimationWithType: animationType fromDirection: direction];
    [self.view.layer addAnimation: transition forKey: nil];
    [self popViewControllerAnimated: NO];
}

- (CATransition *)transitionAnimationWithType:(NSString *)type fromDirection:(NSString *)direction {
    CATransition *transition = [CATransition animation];
    transition.type = type;
    transition.subtype = direction;
    transition.duration = kDefaultAnimationDuration;
    return transition;
}

@end
