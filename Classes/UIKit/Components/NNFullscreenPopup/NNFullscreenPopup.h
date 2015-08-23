//
//  NNFullscreenPopup.h
//  NNLibraries
//
//  Created by Natan Abramov on 5/13/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNFullscreenPopup : UIView
+ (instancetype)popup;
+ (instancetype)popupForView:(UIView *)view;
- (void)fadeIn;
- (void)fadeOut;
@end
