//
//  NNFullscreenPopup.m
//  NNLibraries
//
//  Created by Natan Abramov on 5/13/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNFullscreenPopup.h"
#import "NNConstants.h"
#import "UIView+NNAdditions.h"

@implementation NNFullscreenPopup

+ (instancetype)popup {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    NNFullscreenPopup *popup = [self popupForView: keyWindow];
    if(!popup) {
        popup = [[self alloc] init];
        popup.frame = keyWindow.bounds;
        popup.alpha = 0;
        [keyWindow addSubview: popup];
        [popup fadeIn];
    }
    return popup;
}

+ (instancetype)popupForView:(UIView *)view {
    NNFullscreenPopup *popup = nil;
    for(UIView *subview in view.subviews) {
        if([subview isKindOfClass: [self class]]) {
            popup = (NNFullscreenPopup *)subview;
            break;
        }
    }
    return popup;
}

- (instancetype)initWithFrame:(CGRect)frame {
    NNFullscreenPopup *popup = [self initWithNibName: NSStringFromClass([self class])];
    if(!popup) {
        popup = [super initWithFrame: frame];
    }
    popup.alpha = 0;
    return popup;
}

- (void)fadeIn {
    [UIView animateWithDuration: NNDefaultAnimationDuration animations: ^{
        self.alpha = 1.0f;
    }];
}

- (void)fadeOut {
    [UIView animateWithDuration: NNDefaultAnimationDuration animations: ^{
        self.alpha = 0.0f;
    } completion: ^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
