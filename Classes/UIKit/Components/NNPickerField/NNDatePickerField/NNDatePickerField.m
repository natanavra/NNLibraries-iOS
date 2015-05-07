//
//  NNDatePickerField.m
//  NNLibraries
//
//  Created by Natan Abramov on 1/17/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNDatePickerField.h"
#import "NSDate+NNAdditions.h"

typedef NS_ENUM(NSInteger, toolbarItemIndex) {
    toolbarClearItemIndex = 0,
    toolbarTitleItemIndex = 2,
    toolbarCloseItemIndex = 4,
};

@interface NNDatePickerField ()
@property (nonatomic, weak) UIDatePicker *datePicker;
@end

@implementation NNDatePickerField
@synthesize pickerPlaceholder = _pickerPlaceholder;
@synthesize pickerDelegate = _pickerDelegate;

#pragma mark - Overrides

- (void)clearField {
    [super clearField];
    _selectedDate = nil;
    NSDate *newDate = _datePicker.minimumDate ? _datePicker.minimumDate : [NSDate date];
    [_datePicker setDate: newDate animated: YES];
}

- (void)unlinkPicker {
    //This method is called by the superclass 'resignFirstResponder'
    [_datePicker removeTarget: self action: @selector(dateChanged:) forControlEvents: UIControlEventValueChanged];
    _datePicker = nil;
}

#pragma mark - UIDatePicker Related

- (UIDatePicker *)classDatePicker {
    static UIDatePicker *picker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        picker = [[UIDatePicker alloc] init];
    });
    return picker;
}

- (void)setupPicker {
    [super setupPicker];
    
    UIDatePicker *datePicker = [self classDatePicker];
    _datePicker = datePicker;
    datePicker.datePickerMode = _datePickerMode;
    datePicker.minimumDate = _minimumDate;
    datePicker.maximumDate = _maximumDate;
    [datePicker addTarget: self action: @selector(dateChanged:) forControlEvents: UIControlEventValueChanged];
    
    NSDate *newDate = nil;
    if(_selectedDate) {
        newDate = _selectedDate;
    } else if(_minimumDate) {
        newDate = _minimumDate;
    } else if(_maximumDate) {
        newDate = _maximumDate;
    } else {
        newDate = [NSDate date];
    }
    [self setSelectedDate: newDate];
    self.inputView = datePicker;
}

- (void)dateChanged:(UIDatePicker *)datePicker {
    [self handleDateChangedWithDate: datePicker.date];
}

- (void)handleDateChangedWithDate:(NSDate *)date {
    if([self isValidDate: date]) {
        BOOL shouldChange = YES;
        
        //Ask delegate wether we can change the date.
        if([_pickerDelegate respondsToSelector: @selector(datePickerField:shouldChangeToDate:)]) {
            shouldChange = [_pickerDelegate datePickerField: self shouldChangeToDate: date];
        }
        
        if(shouldChange) {
            _selectedDate = date;
            self.text = [self dateStringFromDate: date];
            if([_pickerDelegate respondsToSelector: @selector(datePickerField:dateChangedToDate:)]) {
                [_pickerDelegate datePickerField: self dateChangedToDate: _selectedDate];
            }
        }
    }
    NSDate *newDate = _selectedDate ? _selectedDate : [NSDate date];
    [_datePicker setDate: newDate animated: YES];
}

- (void)setSelectedDate:(NSDate *)date {
    [self handleDateChangedWithDate: date];
}

- (void)setMinimumDate:(NSDate *)date {
    if(!_maximumDate) {
        _minimumDate = date;
    } else {
        NSComparisonResult compare = [self compareDateByMode: _maximumDate withDate: date];
        if(compare != NSOrderedAscending) {
            _minimumDate = date;
        }
    }
    
    //If current date is invalid - change it to the minimum date.
    if(_selectedDate && ![self isValidDate: _selectedDate]) {
        [self setSelectedDate: date];
    }
}

- (void)setMaximumDate:(NSDate *)date {
    if(!_minimumDate) {
        _maximumDate = date;
    } else {
        NSComparisonResult compare = [self compareDateByMode: _minimumDate withDate: date];
        if(compare != NSOrderedDescending) {
            _maximumDate = date;
        }
    }
    
    //If current selected date is invalid - change it to the maximum date.
    if(_selectedDate && ![self isValidDate: _selectedDate]) {
        [self setSelectedDate: date];
    }
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
    
    BOOL validDate = YES;
    if(_minimumDate) {
        if([self compareDateByMode: _minimumDate withDate: date] == NSOrderedDescending) {
            validDate = NO;
        }
    }
    if(_maximumDate) {
        if([self compareDateByMode: _maximumDate withDate: date] == NSOrderedAscending) {
            validDate = NO;
        }
    }
    
    return validDate;
}

#pragma mark - Helpers

- (NSComparisonResult)compareDateByMode:(NSDate *)date withDate:(NSDate *)otherDate {
    NSComparisonResult result;
    if([self isTimePickerMode]) {
        result = [date timeCompare: otherDate];
    } else {
        result = [date compare: otherDate];
    }
    return result;
}

- (BOOL)isTimePickerMode {
    return (_datePickerMode == UIDatePickerModeTime) || (_datePickerMode == UIDatePickerModeCountDownTimer);
}

- (NSString *)dateStringFromDate:(NSDate *)date {
    NSString *retVal = nil;
    if(_dateDisplayFormat.length > 0) {
        static NSDateFormatter *formatter = nil;
        if(!formatter) {
            formatter = [[NSDateFormatter alloc] init];
        }
        formatter.timeZone = [NSTimeZone defaultTimeZone];
        
        [formatter setDateFormat: _dateDisplayFormat];
        retVal = [formatter stringFromDate: date];
    } else {
        NSDateFormatterStyle dateStyle = NSDateFormatterShortStyle;
        NSDateFormatterStyle timeStyle = NSDateFormatterShortStyle;
        if(_datePickerMode == UIDatePickerModeTime || _datePickerMode == UIDatePickerModeCountDownTimer) {
            dateStyle = NSDateFormatterNoStyle;
        } else if(_datePickerMode == UIDatePickerModeDate) {
            timeStyle = NSDateFormatterNoStyle;
        }
        retVal = [NSDateFormatter localizedStringFromDate: date dateStyle: dateStyle timeStyle: timeStyle];
    }
    return retVal;
}

@end
