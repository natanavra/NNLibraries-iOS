//
//  UIView+NNAdditions.h
//  FourSigns
//
//  Created by Natan Abramov on 10/11/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NNAdditions)
- (void)removeAllSubviews;

- (void)setFrameOrigin:(CGPoint)origin;
- (void)setFrameSize:(CGSize)size;
- (void)setCenterX:(float)x;
- (void)setCenterY:(float)y;
- (CGPoint)bottomLeft;
@end
