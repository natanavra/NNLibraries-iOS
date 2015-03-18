//
//  UIButton+NNAdditions.m
//  FourSigns
//
//  Created by Natan Abramov on 10/7/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "UIButton+NNAdditions.h"

@implementation UIButton (NNAdditions)

- (void)removeAllTargetsAndActions {
    [self removeTarget: nil action: NULL forControlEvents: UIControlEventAllEvents];
}

@end
