//
//  UINavigationController+NNAdditions.m
//  NNLibraries
//
//  Created by Natan Abramov on 2/3/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "UINavigationController+NNAdditions.h"
#import "NNConstants.h"

@implementation UINavigationController (NNAdditions)

- (void)pushViewControllerFromBottom:(UIViewController *)controller {
    [self pushViewController: controller animation: kCATransitionMoveIn fromDirection: kCATransitionFromTop];
}

- (void)popViewControllerFromBottom {
    [self popViewControllerWithAnimation: kCATransitionReveal fromDirection: kCATransitionFromBottom];
}

- (void)pushViewController:(UIViewController *)controller fromDirection:(NNAnimationDirection)direction {
    NSString *transitionDirection = [self transitionDirectionFromAnimationDirection: direction];
    [self pushViewController: controller animation: kCATransitionMoveIn fromDirection: transitionDirection];
}

- (void)popViewControllerToDirection:(NNAnimationDirection)direction {
    NSString *transitionDirection = [self transitionDirectionFromAnimationDirection: direction];
    [self popViewControllerWithAnimation: kCATransitionReveal fromDirection: transitionDirection];
}

- (void)setViewControllers:(NSArray *)viewControllers withAnimationFromDirection:(NNAnimationDirection)direction {
    NSString *transitionDirection = [self transitionDirectionFromAnimationDirection: direction];
    CATransition *transition = [self transitionAnimationWithType: kCATransitionMoveIn fromDirection: transitionDirection];
    [self.view.layer addAnimation: transition forKey: nil];
    [self setViewControllers: viewControllers animated: NO];
}

- (void)pushViewController:(UIViewController *)controller animation:(NSString *)animationType fromDirection:(NSString *)direction {
    CATransition *transition = [self transitionAnimationWithType: animationType fromDirection: direction];
    [self.view.layer addAnimation: transition forKey: nil];
    [self pushViewController: controller animated: NO];
}

- (void)popViewControllerWithAnimation:(NSString *)animationType fromDirection:(NSString *)direction {
    CATransition *transition = [self transitionAnimationWithType: animationType fromDirection: direction];
    [self.view.layer addAnimation: transition forKey: nil];
    [self popViewControllerAnimated: NO];
}

#pragma mark - Helpers

- (NSString *)transitionDirectionFromAnimationDirection:(NNAnimationDirection)direction {
    switch(direction) {
        case NNAnimationDirectionFromTop: {
            return kCATransitionFromTop;
            break;
        }
        case NNAnimationDirectionFromRight: {
            return kCATransitionFromRight;
            break;
        }
        case NNAnimationDirectionFromBottom: {
            return kCATransitionFromBottom;
            break;
        }
        case NNAnimationDirectionFromLeft: {
            return kCATransitionFromLeft;
            break;
        }
    }
    return nil;
}

- (NSString *)oppositeTransitionDirectionFromAnimationDirection:(NNAnimationDirection)direction {
    switch(direction) {
        case NNAnimationDirectionFromTop: {
            return kCATransitionFromBottom;
            break;
        }
        case NNAnimationDirectionFromRight: {
            return kCATransitionFromLeft;
            break;
        }
        case NNAnimationDirectionFromBottom: {
            return kCATransitionFromTop;
            break;
        }
        case NNAnimationDirectionFromLeft: {
            return kCATransitionFromRight;
            break;
        }
    }
    return nil;
}

#pragma mark - Factory

- (CATransition *)transitionAnimationWithType:(NSString *)type fromDirection:(NSString *)direction {
    CATransition *transition = [CATransition animation];
    transition.type = type;
    transition.subtype = direction;
    transition.duration = NNDefaultAnimationDuration;
    return transition;
}

@end
