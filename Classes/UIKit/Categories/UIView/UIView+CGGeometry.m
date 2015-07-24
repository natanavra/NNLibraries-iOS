//
//  UIView+CGGeometry.m
//  NNLibraries
//
//  Created by Natan Abramov on 3/18/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "UIView+CGGeometry.h"

@implementation UIView (CGGeometry)


#pragma mark - Frames

- (void)setFrameSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setFrameOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (void)setFrameOriginX:(float)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setFrameOriginY:(float)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

#pragma mark - Points


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

#pragma mark - Sizes

- (CGSize)boundsSize {
    return self.bounds.size;
}

- (CGFloat)boundsHeight {
    return self.bounds.size.height;
}

- (CGFloat)boundsWidth {
    return self.bounds.size.width;
}

@end
