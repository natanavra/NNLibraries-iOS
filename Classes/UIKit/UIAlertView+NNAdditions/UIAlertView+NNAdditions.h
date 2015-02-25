//
//  UIAlertView+NNAdditions.h
//  GlobeKeeper
//
//  Created by Natan Abramov on 10/17/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (NNAdditions)
/** This method is localized. it passes all displayed string parameters through NSLocalizedString */
+ (UIAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtons:(NSArray *)btnTitles delegate:(id<UIAlertViewDelegate>)delegate;
/** This method is localized. it passes all displayed string parameters through NSLocalizedString, additional option to give the alert a tag. */
+ (UIAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtons:(NSArray *)btnTitles delegate:(id<UIAlertViewDelegate>)delegate tag:(NSInteger)tag;

/** Show the alert and dismiss it automatically after a defined number of seconds. */
- (void)showWithDisplayTime:(NSTimeInterval)displayTime;

/** Dismiss the alert after the delay is over */
- (void)dismissAfterDelay:(NSTimeInterval)delay;
@end
