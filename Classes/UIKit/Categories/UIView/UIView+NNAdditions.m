//
//  UIView+NNAdditions.m
//  FourSigns
//
//  Created by Natan Abramov on 10/11/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "UIView+NNAdditions.h"

@implementation UIView (NNAdditions)

- (instancetype)initWithNibName:(NSString *)nibName {
    return [self initWithNibName: nibName withOwner: self];
}

- (instancetype)initWithNibName:(NSString *)nibName withOwner:(id)owner {
    if(nibName) {
        UINib *nib = [UINib nibWithNibName: nibName bundle: nil];
        NSArray *components = [nib instantiateWithOwner: owner options: nil];
        if(components.count > 0) {
            return components[0];
        }
    }
    return nil;
}

- (void)removeAllSubviews {
    for(UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

@end
