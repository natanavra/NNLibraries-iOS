//
//  UIAlertView+NNAdditions.m
//  GlobeKeeper
//
//  Created by Natan Abramov on 10/17/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "UIAlertView+NNAdditions.h"

@implementation UIAlertView (NNAdditions)

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtons:(NSArray *)btnTitles delegate:(id<UIAlertViewDelegate>)delegate {
    [self showAlertWithTitle: title message: message cancelButtonTitle: cancelTitle otherButtons: btnTitles delegate: delegate tag: 0];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle otherButtons:(NSArray *)btnTitles delegate:(id<UIAlertViewDelegate>)delegate tag:(NSInteger)tag {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(title, nil)
                                                    message: NSLocalizedString(message, nil)
                                                   delegate: delegate
                                          cancelButtonTitle: NSLocalizedString(cancelTitle, nil)
                                          otherButtonTitles: nil];
    for(id obj in btnTitles) {
        if([obj isKindOfClass: [NSString class]]) {
            NSString *btnTitle = (NSString *)obj;
            [alert addButtonWithTitle: NSLocalizedString(btnTitle, nil)];
        }
    }
    alert.tag = tag;
    [alert show];
}

@end
