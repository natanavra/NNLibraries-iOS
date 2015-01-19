//
//  NNSwitch.m
//  NNLibraries
//
//  Created by Natan Abramov on 1/6/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNCustomSwitch.h"
#import "UIView+NNAdditions.h"

@implementation NNCustomSwitch

- (instancetype)initWithOnImage:(UIImage *)onImage offImage:(UIImage *)offImage {
    if(self = [super init]) {
        _onImage = onImage;
        _offImage = offImage;
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage: offImage];
        [imgView sizeToFit];
        [imgView setFrameOrigin: CGPointZero];
        [self setFrameSize: offImage.size];
        [self addSubview: imgView];
        
        _switchImage = imgView;
        
        [self addTarget: self action: @selector(toggleState) forControlEvents: UIControlEventTouchUpInside];
    }
    return self;
}

- (void)toggleState {
    _on = !_on;
    _switchImage.image = _on ? _onImage : _offImage;
}

@end
