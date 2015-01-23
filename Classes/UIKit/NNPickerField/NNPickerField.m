//
//  NNPickerField.m
//  NNLibraries
//
//  Created by Natan Abramov on 1/9/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNPickerField.h"
#import "NNSelectable.h"

@interface NNPickerField () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, weak) UIBarButtonItem *closeButton;
@property (nonatomic, weak) UIBarButtonItem *clearButton;
@property (nonatomic, strong) NSString *closeTitle;
@property (nonatomic, strong) NSString *clearTitle;
@end

@implementation NNPickerField

#pragma mark - Overrides

- (BOOL)becomeFirstResponder {
    if(_items.count != 0) {
        if(![self.inputView isKindOfClass: UIPickerView.class]) {
            [self setupPicker];
        }
        id inputView = self.inputView;
        
        if(_selectedIndex > -1 && _selectedIndex < _items.count) {
            UIPickerView *picker = inputView;
            [picker selectRow: _selectedIndex inComponent: 0 animated: NO];
            [self pickerView: picker didSelectRow: _selectedIndex inComponent: 0];
        }
    } else {
        _selectedIndex = -1;
        _selectedObject = nil;
        self.inputView = nil;
    }
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

#pragma mark - Custom Methods

- (void)setupPicker {
    _selectedIndex = 0;
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    picker.dataSource = self;
    self.inputView = picker;
    
    if(!_clearTitle) {
        _clearTitle = NSLocalizedString(@"Clear", nil);
    }
    if(!_closeTitle) {
        _closeTitle = NSLocalizedString(@"Close", nil);
    }
    
    UIToolbar *accessory = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, picker.frame.size.width, 44)];
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle: _clearTitle style: UIBarButtonItemStyleDone target: self action: @selector(clear)];
    UIBarButtonItem *flexiSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: NULL];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle: _closeTitle style: UIBarButtonItemStyleDone target: self action: @selector(endEditing)];
    
    NSMutableArray *items = [NSMutableArray array];
    [items addObjectsFromArray: @[clearButton, flexiSpace, closeButton]];
    [accessory setItems: items];
    
    _closeButton = closeButton;
    _clearButton = clearButton;
    
    self.inputAccessoryView = accessory;
}

- (void)setCloseButtonTitle:(NSString *)title {
    [_closeButton setTitle: title];
    _closeTitle = title;
}

- (void)setClearButtonTitle:(NSString *)title {
    [_clearButton setTitle: title];
    _clearTitle = title;
}

- (void)endEditing {
    [self endEditing: YES];
}

- (void)clear {
    self.text = @"";
    _selectedIndex = -1;
    _selectedObject = nil;
    [self endEditing];
}

#pragma mark - UIPickerView Protocols

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _items.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    id object = _items[row];
    if([object conformsToProtocol: @protocol(NNSelectable)]) {
        return [object title];
    } else if([object isKindOfClass: NSString.class]) {
        return object;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(_items.count == 0) {
        return;
    }
    _selectedObject = _items[row];
    _selectedIndex = row;
    self.text = [_selectedObject conformsToProtocol: @protocol(NNSelectable)] ? [_selectedObject title] : _selectedObject;
}

@end
