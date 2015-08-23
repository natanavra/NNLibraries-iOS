//
//  UIView+Autolayout.m
//  NNLibraries
//
//  Created by Natan Abramov on 6/8/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "UIView+NNAutolayout.h"

@implementation UIView (NNAutolayout)

- (void)removeConstraintsForView:(UIView *)view {
    NSMutableArray *constraintsToRemove = [NSMutableArray array];
    for(NSLayoutConstraint *constraint in self.constraints) {
        if(constraint.firstItem == view || constraint.secondItem == view) {
            [constraintsToRemove addObject: constraint];
        }
    }
    [self removeConstraints: constraintsToRemove];
}

- (void)alignToSuperviewCenterX {
    if(!self.superview) {
        return;
    }
    [self.superview addConstraint: [NSLayoutConstraint constraintWithItem: self.superview attribute: NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeCenterX multiplier: 1.0 constant: 0]];
}

- (void)alignToSuperviewCenterY {
    if(!self.superview) {
        return;
    }
    [self.superview addConstraint: [NSLayoutConstraint constraintWithItem: self.superview attribute: NSLayoutAttributeCenterY relatedBy: NSLayoutRelationEqual toItem: self attribute: NSLayoutAttributeCenterY multiplier: 1.0 constant: 0]];
}

- (void)alignToSuperviewCenters {
    if(!self.superview) {
        return;
    }
    [self alignToSuperviewCenterX];
    [self alignToSuperviewCenterY];
}

- (void)distributeViews:(NSArray *)views horizontallyWithMarginsFromSuperView:(CGFloat)margin {
    NSDictionary *metrics = @{@"margin" : @(margin)};
    NSMutableDictionary *viewsDict = [NSMutableDictionary dictionary];
    NSMutableString *visualFormat = [NSMutableString stringWithString: @"H:|-margin-"];
    NSInteger index = 0;
    for(UIView *view in views) {
        NSString *viewName = [NSString stringWithFormat: @"view%li", (long)index];
        viewsDict[viewName] = view;
        
        [visualFormat appendFormat: @"[%@]", viewName];
        if(index == views.count - 1) {
            [visualFormat appendString: @"-margin-|"];
        } else {
            NSString *spacerName = [NSString stringWithFormat: @"spacer%li", (long)index];
            UIView *spacer = [self spacerView];
            [self addSubview: spacer];
            viewsDict[spacerName] = spacer;
            
            if(index == 0) {
                [visualFormat appendString: @"-0-[spacer0]-0-"];
            } else {
                [visualFormat appendFormat: @"-0-[%@(==spacer0)]-0-", spacerName];
            }
        }
        index ++;
    }
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat: visualFormat
                                                                  options: NSLayoutFormatAlignAllCenterY
                                                                  metrics: metrics
                                                                    views: viewsDict]];
}

#pragma mark - Factory

- (UIView *)spacerView {
    UIView *spacer = [[UIView alloc] init];
    spacer.translatesAutoresizingMaskIntoConstraints = NO;
    spacer.backgroundColor = [UIColor clearColor];
    return spacer;
}

@end
