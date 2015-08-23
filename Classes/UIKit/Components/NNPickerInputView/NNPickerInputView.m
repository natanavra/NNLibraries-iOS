//
//  NNPickerInputView.m
//  MaKasher
//
//  Created by Natan Abramov on 11/8/14.
//  Copyright (c) 2014 Natan Abramov. All rights reserved.
//

#import "NNPickerInputView.h"

@interface NNPickerInputView ()
@property (nonatomic, weak) id<UITextFieldDelegate> delegate;
@end

@implementation NNPickerInputView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame: frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if(self = [super initWithCoder: decoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _picker = [[UIPickerView alloc] init];
}

#pragma mark - Input Views

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (UIView *)inputView {
    if(_picker) {
        return _picker;
    }
    return [super inputView];
}

- (UIView *)inputAccessoryView {
    if(_picker) {
        UIToolbar *accessory = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, _picker.frame.size.width, 44)];
        UIBarButtonItem *flexiSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: NULL];
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle: @"סגור" style: UIBarButtonItemStyleDone target: self action: @selector(endEditing)];
        
        NSMutableArray *items = [NSMutableArray array];
        [items addObjectsFromArray: @[flexiSpace, closeButton]];
        [accessory setItems: items];
        return accessory;
    }
    return [super inputAccessoryView];
}

- (void)endEditing {
    [self endEditing: YES];
}

#pragma mark - UIKeyInputProtocol

- (BOOL)hasText {
    return YES;
}

- (void)insertText:(NSString *)text {
    
}

- (void)deleteBackward {
    
}

@end
