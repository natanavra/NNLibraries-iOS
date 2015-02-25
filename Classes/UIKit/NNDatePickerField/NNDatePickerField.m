//
//  NNDatePickerField.m
//  NNLibraries
//
//  Created by Natan Abramov on 1/17/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNDatePickerField.h"

@interface NNDatePickerField ()
@property (nonatomic, weak) UIDatePicker *datePicker;
@end

@implementation NNDatePickerField

#pragma mark - Responder & Actions

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

- (BOOL)becomeFirstResponder {
    if(![[self inputView] isKindOfClass: [UIDatePicker class]]) {
        [self setupPicker];
    }
    [self setCurrentDate: _datePicker.date];
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

- (void)setShowsToolBarWithCleanButtonTitle:(NSString *)cleanTitle
                       withCloseButtonTitle:(NSString *)closeTitle
                                  withTitle:(NSString *)title
                             withTitleColor:(UIColor *)color {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, _datePicker.frame.size.width, 44.0f)];
    
    NSMutableArray *items = [NSMutableArray array];
    if(cleanTitle) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle: cleanTitle
                                                                 style: UIBarButtonItemStylePlain
                                                                target: self action: @selector(clearDate)];
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
                                                                target: self action: @selector(closePicker)];
        [items addObject: item];
    }
    
    toolbar.items = [items copy];
    self.inputAccessoryView = toolbar;
}

- (void)closePicker {
    [self resignFirstResponder];
}

- (void)clearDate {
    _selectedDate = nil;
    _datePicker.date = _datePicker.minimumDate ? _datePicker.minimumDate : [NSDate date];
    self.text = _pickerPlaceholder;
}

#pragma mark - UIDatePicker Related

- (void)setupPicker {
    _pickerPlaceholder = self.text;
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget: self action: @selector(dateChanged:) forControlEvents: UIControlEventValueChanged];
    datePicker.date = [NSDate date];
    self.inputView = datePicker;
    _datePicker = datePicker;
    
    self.tintColor = [UIColor clearColor];
}

- (void)setDatePickerMode:(UIDatePickerMode)newMode {
    if([[self inputView] isKindOfClass: [UIDatePicker class]]) {
        _datePicker.datePickerMode = newMode;
    }
}

- (void)dateChanged:(UIDatePicker *)datePicker {
    BOOL shouldChange = YES;
    
    //Ask delegate wether we can change the date.
    if([_datePickerDelegate respondsToSelector: @selector(datePickerField:shouldChangeToDate:)]) {
        shouldChange = [_datePickerDelegate datePickerField: self shouldChangeToDate: datePicker.date];
    }
    
    if(shouldChange) {
        _selectedDate = datePicker.date;
        self.text = [self dateStringFromDate: datePicker.date];
        
        if([_datePickerDelegate respondsToSelector: @selector(datePickerField:dateChangedToDate:)]) {
            [_datePickerDelegate datePickerField: self dateChangedToDate: _selectedDate];
        }
    } else {
        datePicker.date = _selectedDate ? _selectedDate : [NSDate date];
    }
}

- (void)setCurrentDate:(NSDate *)date {
    if([self isValidDate: date]) {
        _selectedDate = date;
        _datePicker.date = date;
        self.text = [self dateStringFromDate: date];
    }
}

- (void)setMinimumDate:(NSDate *)date {
    if(!_datePicker.maximumDate) {
        _datePicker.minimumDate = date;
    } else if([_datePicker.maximumDate compare: date] == NSOrderedDescending) {
        _datePicker.minimumDate = date;
    }
    
    //If current date is invalid - change it to the minimum date.
    if(_selectedDate && ![self isValidDate: _selectedDate]) {
        [self setCurrentDate: date];
    }
}

- (NSDate *)minimumDate {
    return _datePicker.minimumDate;
}

- (void)setMaximumDate:(NSDate *)date {
    if(!_datePicker.minimumDate) {
        _datePicker.maximumDate = date;
    } else if([_datePicker.minimumDate compare: date] == NSOrderedAscending) {
        _datePicker.maximumDate = date;
    }
    
    //If current selected date is invalid - change it to the maximum date.
    if(_selectedDate && ![self isValidDate: _selectedDate]) {
        [self setCurrentDate: date];
    }
}

- (NSDate *)maximumDate {
    return _datePicker.maximumDate;
}

- (NSString *)selectedDateStringWithFormat:(NSString *)format {
    NSString *previousFormat = _dateDisplayFormat;
    _dateDisplayFormat = format;
    NSString *dateString = [self dateStringFromDate: _selectedDate];
    _dateDisplayFormat = previousFormat;
    return dateString;
}

- (BOOL)isValidDate:(NSDate *)date {
    if(!date) {
        return NO;
    }
    
    if(_datePicker.minimumDate) {
        if([_datePicker.minimumDate compare: date] == NSOrderedDescending) {
            return NO;
        }
    }
    if(_datePicker.maximumDate) {
        if([_datePicker.maximumDate compare: date] == NSOrderedAscending) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Helpers

- (NSString *)dateStringFromDate:(NSDate *)date {
    static NSDateFormatter *formatter = nil;
    if(!formatter) {
        formatter = [[NSDateFormatter alloc] init];
    }
    NSString *retVal = nil;
    
    if(_dateDisplayFormat.length > 0) {
        [formatter setDateFormat: _dateDisplayFormat];
        retVal = [formatter stringFromDate: date];
    } else {
        [formatter setDateFormat: nil];
        NSDateFormatterStyle dateStyle = NSDateFormatterShortStyle;
        NSDateFormatterStyle timeStyle = NSDateFormatterShortStyle;
        if(_datePicker.datePickerMode == UIDatePickerModeTime || _datePicker.datePickerMode == UIDatePickerModeCountDownTimer) {
            dateStyle = NSDateFormatterNoStyle;
        } else if(_datePicker.datePickerMode == UIDatePickerModeDate) {
            timeStyle = NSDateFormatterNoStyle;
        }
        retVal = [NSDateFormatter localizedStringFromDate: date dateStyle: dateStyle timeStyle: timeStyle];
    }
    return retVal;
}

@end
