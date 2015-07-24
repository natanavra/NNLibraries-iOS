//
//  NNInsetTextField.m
//  GlobeKeeper
//
//  Created by Natan Abramov on 12/10/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "NNInsetTextField.h"

@implementation NNInsetTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder: aDecoder]) {
        [self initializeDefaultValues];
    }
    return self;
}

- (void)initializeDefaultValues {
    _widthInset = 10.0f;
    _heightInset = 0;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, _widthInset, _heightInset);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, _widthInset, _heightInset);
}

@end
