//
//  NNSwitch.h
//  NNLibraries
//
//  Created by Natan Abramov on 1/6/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNCustomSwitch : UIControl {
    UIImage *_onImage;
    UIImage *_offImage;
}

@property (nonatomic, assign) BOOL on;
@property (nonatomic, weak) UIImageView *switchImage;

- (instancetype)initWithOnImage:(UIImage *)onImage offImage:(UIImage *)offImage;
@end
