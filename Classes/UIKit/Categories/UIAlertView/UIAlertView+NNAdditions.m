//
//  UIAlertView+NNAdditions.m
//  GlobeKeeper
//
//  Created by Natan Abramov on 10/17/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "UIAlertView+NNAdditions.h"

@implementation UIAlertView (NNAdditions)

+ (UIAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtons:(NSArray *)btnTitles delegate:(id<UIAlertViewDelegate>)delegate {
    return [self showAlertWithTitle: title message: message cancelButtonTitle: cancelTitle otherButtons: btnTitles delegate: delegate tag: 0];
}

+ (UIAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtons:(NSArray *)btnTitles delegate:(id<UIAlertViewDelegate>)delegate tag:(NSInteger)tag {
    UIAlertView *alert = [self alertWithTitle: title message: message cancelButtonTitle: cancelTitle otherButtons: btnTitles delegate: delegate tag: tag];
    [alert show];
    return alert;
}

+ (UIAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtons:(NSArray *)btnTitles delegate:(id<UIAlertViewDelegate>)delegate {
    return [self alertWithTitle: title message: message cancelButtonTitle: cancelTitle otherButtons: btnTitles delegate: delegate tag: 0];
}

+ (UIAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtons:(NSArray *)btnTitles delegate:(id<UIAlertViewDelegate>)delegate tag:(NSInteger)tag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(title, nil)
                                                    message: NSLocalizedString(message, nil)
                                                   delegate: delegate
                                          cancelButtonTitle: cancelTitle ? NSLocalizedString(cancelTitle, nil) : nil
                                          otherButtonTitles: nil];
    for(id obj in btnTitles) {
        if([obj isKindOfClass: [NSString class]]) {
            NSString *btnTitle = (NSString *)obj;
            [alert addButtonWithTitle: NSLocalizedString(btnTitle, nil)];
        }
    }
    alert.tag = tag;
    return alert;
}

- (void)showWithDisplayTime:(NSTimeInterval)displayTime {
    if(!self.isVisible) {
        [self show];
    }
    [self dismissAfterDelay: displayTime];
}

- (void)dismissAfterDelay:(NSTimeInterval)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissWithClickedButtonIndex: 0 animated: YES];
    });
}

@end
