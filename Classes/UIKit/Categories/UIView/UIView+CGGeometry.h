//
//  UIView+CGGeometry.h
//  NNLibraries
//
//  Created by Natan Abramov on 3/18/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CGGeometry)
- (void)setFrameSize:(CGSize)size;
- (void)setFrameOrigin:(CGPoint)origin;
- (void)setFrameOriginX:(float)x;
- (void)setFrameOriginY:(float)y;
- (void)setCenterX:(float)x;
- (void)setCenterY:(float)y;
- (CGPoint)bottomLeft;

- (CGSize)boundsSize;
- (CGFloat)boundsHeight;
- (CGFloat)boundsWidth;
@end
