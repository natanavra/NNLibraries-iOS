//
//  UIView+NNAdditions.m
//  FourSigns
//
//  Created by Natan Abramov on 10/11/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "UIView+NNAdditions.h"

@implementation UIView (NNAdditions)

- (void)removeAllSubviews {
    for(UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

- (void)setFrameOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (void)setFrameSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setCenterX:(float)x {
    CGPoint center = self.center;
    center.x = x;
    self.center = center;
}

- (void)setCenterY:(float)y {
    CGPoint center = self.center;
    center.y = y;
    self.center = center;
}

- (CGPoint)bottomLeft {
    return CGPointMake(self.frame.origin.x, CGRectGetMaxY(self.frame));
}

@end
