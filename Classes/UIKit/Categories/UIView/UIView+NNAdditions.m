//
//  UIView+NNAdditions.m
//  FourSigns
//
//  Created by Natan Abramov on 10/11/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "UIView+NNAdditions.h"

@implementation UIView (NNAdditions)

NSInteger const kNonRemovableSubviewTag = 403;

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
        if(subview.tag != kNonRemovableSubviewTag) {
            [subview removeFromSuperview];
        }
    }
}

- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self drawViewHierarchyInRect: self.bounds afterScreenUpdates: YES];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}

@end
