//
//  NNPickerInputView.m
//  MaKasher
//
//  Created by Natan Abramov on 11/8/14.
//  Copyright (c) 2014 Natan Abramov. All rights reserved.
//

#import "NNPickerInputView.h"

@implementation NNPickerInputView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (UIView *)inputView {
    return _picker;
}

- (UIView *)inputAccessoryView {
    UIToolbar *accessory = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, _picker.frame.size.width, 44)];
    UIBarButtonItem *flexiSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: NULL];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle: @"סגור" style: UIBarButtonItemStyleDone target: self action: @selector(endEditing)];
    [accessory setItems: @[flexiSpace, closeButton]];
    return accessory;
}

- (void)endEditing {
    [self endEditing: YES];
}

- (BOOL)hasText {
    return YES;
}

- (void)insertText:(NSString *)text {
    
}

- (void)deleteBackward {
    
}

@end
