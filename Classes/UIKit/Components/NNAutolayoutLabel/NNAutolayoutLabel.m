//
//  NNAutolayoutLabel.m
//  NNLibraries
//
//  Created by Natan Abramov on 3/5/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNAutolayoutLabel.h"

@implementation NNAutolayoutLabel

- (void)layoutSubviews {
    self.preferredMaxLayoutWidth = self.bounds.size.width;
    [super layoutSubviews];
}

@end
