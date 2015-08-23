//
//  UINavigationBar+NNAdditions.m
//  GlobeKeeper
//
//  Created by Natan Abramov on 11/15/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "UINavigationBar+NNAdditions.h"

@implementation UINavigationBar (NNAdditions)

- (void)hideBottomHairline {
    UIImageView *hairline = [self findBottomHairline: self];
    hairline.hidden = YES;
    hairline.clipsToBounds = YES;
}

- (void)showBottomHairline {
    UIImageView *hairline = [self findBottomHairline: self];
    hairline.hidden = NO;
}

- (UIImageView *)findBottomHairline:(UIView *)view {
    if ([view isKindOfClass: UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findBottomHairline:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
