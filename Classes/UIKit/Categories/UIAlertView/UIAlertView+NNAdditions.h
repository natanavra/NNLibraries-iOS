//
//  UIAlertView+NNAdditions.h
//  GlobeKeeper
//
//  Created by Natan Abramov on 10/17/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (NNAdditions)

/** Shows a localized UIAlertView with a title, subtitle and a cancel button. */
+ (UIAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle;
/** Shows a localized UIAlertView with a title, subtitle, cancel button, other buttons and a delegate. */
+ (UIAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtons:(NSArray *)btnTitles delegate:(id<UIAlertViewDelegate>)delegate;

/** Shows a localized UIAlertView. All displayed string parameters go through NSLocalizedString, additional option to give the alert a tag. */
+ (UIAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtons:(NSArray *)btnTitles delegate:(id<UIAlertViewDelegate>)delegate tag:(NSInteger)tag;

/**
 *  Creates a localized UIAlertView without displaying it.
 *  Additional params include: title, message, cancel, other buttons, delegate and tag.
 *  @return localized UIAlertView
 */
+ (UIAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtons:(NSArray *)btnTitles delegate:(id<UIAlertViewDelegate>)delegate tag:(NSInteger)tag;

/**
 *  Creates a localized UIAlertView without displaying it.
 *  Additional params include: title, message, cancel, other buttons and delegate.
 *  @return localized UIAlertView
 */
+ (UIAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtons:(NSArray *)btnTitles delegate:(id<UIAlertViewDelegate>)delegate;

/** Show the alert and dismiss it automatically after a defined number of seconds. (Fakes a click on button with index 0) */
- (void)showWithDisplayTime:(NSTimeInterval)displayTime;

/** Dismiss the alert after the delay is over (Fakes a click on button with index 0) */
- (void)dismissAfterDelay:(NSTimeInterval)delay;
@end
