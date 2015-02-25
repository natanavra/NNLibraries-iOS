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
@property (nonatomic, weak) UIPickerView *picker;
@end

@implementation NNPickerField

#pragma mark - Overrides

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

- (BOOL)becomeFirstResponder {
    if(![[self inputView] isKindOfClass: [UIPickerView class]]) {
        [self setupPicker];
    }
    if([self showsRange] && _selectedNumber != NSNotFound) {
        [self setSelectedNumber: _selectedNumber];
        [self pickerView: _picker didSelectRow: _fromNumber + _selectedNumber inComponent: 0];
    } else if(![self showsRange]) {
        [self setCurrentSelectedIndex: 0];
    }
    return [super becomeFirstResponder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder: aDecoder]) {
        [self setupPicker];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame: frame]) {
        [self setupPicker];
    }
    return self;
}

#pragma mark - Custom Methods

- (void)setupPicker {
    _selectedIndex = -1;
    _fromNumber = 1;
    _toNumber = 10;
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    picker.dataSource = self;
    self.inputView = picker;
    self.picker = picker;
    self.tintColor = [UIColor clearColor];
}

- (void)setCloseButtonTitle:(NSString *)title {
    //Deprecated
}

- (void)setClearButtonTitle:(NSString *)title {
    //Deprecated
}

- (void)endEditing {
    if([_pickerDelegate respondsToSelector: @selector(pickerFieldDidFinishSelection:)]) {
        [_pickerDelegate pickerFieldDidFinishSelection: self];
    }
    [self endEditing: YES];
}

- (void)clear {
    self.text = @"";
    _selectedIndex = -1;
    _selectedNumber = NSNotFound;
    _selectedObject = nil;
    [self endEditing: YES];
    
    if([_pickerDelegate respondsToSelector: @selector(pickerFieldDidCleanSelection:)]) {
        [_pickerDelegate pickerFieldDidCleanSelection: self];
    }
}

- (void)setShowsToolBarWithCleanButtonTitle:(NSString *)cleanTitle
                       withCloseButtonTitle:(NSString *)closeTitle
                                  withTitle:(NSString *)title
                             withTitleColor:(UIColor *)color {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, _picker.frame.size.width, 44.0f)];
    
    NSMutableArray *items = [NSMutableArray array];
    if(cleanTitle) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle: cleanTitle
                                                                 style: UIBarButtonItemStylePlain
                                                                target: self action: @selector(clear)];
        [items addObject: item];
    }
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                                   target: nil action: nil];
    [items addObject: flexibleSpace];
    
    if(title) {
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, toolbar.frame.size.width * 0.6, toolbar.frame.size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = color ? color : [UIColor blackColor];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView: label];
        [items addObject: titleItem];
        
        flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                      target: nil action: nil];
        [items addObject: flexibleSpace];
    }
    
    if(closeTitle) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle: closeTitle
                                                                 style: UIBarButtonItemStyleDone
                                                                target: self action: @selector(endEditing)];
        [items addObject: item];
    }
    
    toolbar.items = [items copy];
    self.inputAccessoryView = toolbar;
}

#pragma mark - UIPickerView Protocols

- (void)setShowsRange:(BOOL)showsRange {
    [self showNumberRangeFromNumber: _fromNumber toNumber: _toNumber];
}

- (void)showNumberRangeFromNumber:(NSInteger)fromNumber toNumber:(NSInteger)toNumber {
    if(fromNumber > toNumber) {
        NSInteger holder = fromNumber;
        fromNumber = toNumber;
        toNumber = holder;
    } else if(fromNumber == toNumber) {
        toNumber ++;
    }
    _showsRange = YES;
    _fromNumber = fromNumber;
    _toNumber = toNumber;
    _selectedNumber = NSNotFound;
    [_picker reloadAllComponents];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(_showsRange) {
        return _toNumber - _fromNumber + 1;
    } else {
        return _items.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(_showsRange) {
        return [NSString stringWithFormat: @"%zi", _fromNumber + row];
    } else {
        id object = _items[row];
        if([object conformsToProtocol: @protocol(NNSelectable)]) {
            return [object title];
        } else if([object isKindOfClass: NSString.class]) {
            return object;
        } else if([object isKindOfClass: [NSDictionary class]]) {
            return [object allValues][row];
        }
        return @"";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(_showsRange) {
        _selectedNumber = _fromNumber + row;
        self.text = [NSString stringWithFormat: @"%zi", _selectedNumber];
        
        if([_pickerDelegate respondsToSelector: @selector(pickerField:didSelectNumber:)]) {
            [_pickerDelegate pickerField: self didSelectNumber: _selectedNumber];
        }
    } else {
        if(_items.count == 0) {
            return;
        }
        
        BOOL shouldSelect = YES;
        if([_pickerDelegate respondsToSelector: @selector(pickerField:shouldSelectObjectAtIndex:)]) {
            shouldSelect = [_pickerDelegate pickerField: self shouldSelectObjectAtIndex: row];
        }
        
        if(shouldSelect) {
            _selectedObject = _items[row];
            _selectedIndex = row;
            self.text = [_selectedObject conformsToProtocol: @protocol(NNSelectable)] ? [_selectedObject title] : _selectedObject;
            
            if([_pickerDelegate respondsToSelector: @selector(pickerField:didSelectObject:atIndex:)]) {
                [_pickerDelegate pickerField: self didSelectObject: _selectedObject atIndex: _selectedIndex];
            }
        }
    }
}

- (void)setSelectedNumber:(NSInteger)selectedNumber {
    if(selectedNumber >= _fromNumber && selectedNumber <= _toNumber) {
        _selectedNumber = selectedNumber;
        [_picker selectRow: _fromNumber + _selectedNumber inComponent: 0 animated: YES];
    }
}

- (void)setCurrentSelectedIndex:(NSInteger)index {
    if(index >= 0 && index < _items.count) {
        [_picker selectRow: index inComponent: 0 animated: YES];
        [self pickerView: _picker didSelectRow: index inComponent: 0];
    }
}

- (void)setItems:(NSArray *)items {
    _items = [items copy];
    _showsRange = NO;
    [_picker reloadAllComponents];
}

@end
