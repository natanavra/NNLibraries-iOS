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
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtons:(NSArray *)btnTitles delegate:(id<UIAlertViewDelegate>)delegate;
/** This method is localized. it passes all displayed string parameters through NSLocalizedString, additional option to give the alert a tag. */
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtons:(NSArray *)btnTitles delegate:(id<UIAlertViewDelegate>)delegate tag:(NSInteger)tag;
@end
