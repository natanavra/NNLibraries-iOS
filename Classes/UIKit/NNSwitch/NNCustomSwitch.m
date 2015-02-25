//
//  NNSwitch.m
//  NNLibraries
//
//  Created by Natan Abramov on 1/6/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNCustomSwitch.h"
#import "NNLogger.h"
#import "UIView+NNAdditions.h"

@implementation NNCustomSwitch

- (instancetype)initWithOnImage:(UIImage *)onImage offImage:(UIImage *)offImage {
    if(self = [super init]) {
        _onImage = onImage;
        _offImage = offImage;
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage: offImage];
        imgView.userInteractionEnabled = NO;
        [imgView sizeToFit];
        [imgView setFrameOrigin: CGPointZero];
        [self setFrameSize: offImage.size];
        [self addSubview: imgView];
        
        CGRect frame = imgView.bounds;
        frame.origin = self.frame.origin;
        self.frame = frame;
        
        _switchImage = imgView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(toggleState)];
        [self addGestureRecognizer: tap];
    }
    return self;
}

- (void)toggleState {
    _on = !_on;
    _switchImage.image = _on ? _onImage : _offImage;
}

@end
