//
//  UIView+NNAdditions.h
//  FourSigns
//
//  Created by Natan Abramov on 10/11/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NNAdditions)
- (instancetype)initWithNibName:(NSString *)nibName;
- (instancetype)initWithNibName:(NSString *)nibName withOwner:(id)owner;
- (void)removeAllSubviews;
@end
