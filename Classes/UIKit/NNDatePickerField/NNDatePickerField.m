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

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

- (BOOL)becomeFirstResponder {
    if(![[self inputView] isKindOfClass: [UIDatePicker class]]) {
        [self setupPicker];
    }
    return [super becomeFirstResponder];
}

- (void)setupPicker {
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget: self action: @selector(dateChanged:) forControlEvents: UIControlEventValueChanged];
    datePicker.date = [NSDate date];
    _selectedDate = [NSDate date];
    self.inputView = datePicker;
    _datePicker = datePicker;
    
    self.tintColor = [UIColor clearColor];
}

- (void)setDatePickerMode:(UIDatePickerMode)newMode {
    if([[self inputView] isKindOfClass: [UIDatePicker class]]) {
        UIDatePicker *picker = (UIDatePicker *)[self inputView];
        picker.datePickerMode = newMode;
    }
}

- (void)dateChanged:(UIDatePicker *)datePicker {
    BOOL shouldChange = YES;
    if(_datePickerDelegate) {
        shouldChange = [_datePickerDelegate shouldChangeDate: datePicker.date inDatePickerField: self];
    }
    
    if(shouldChange) {
        _selectedDate = datePicker.date;
        self.text = [self dateStringFromDate: datePicker.date withFormat: [self dateFormat]];
    }
}

- (NSString *)dateFormat {
    if(_dateDisplayFormat.length == 0) {
        if(_datePicker.datePickerMode == UIDatePickerModeTime) {
            return @"HH:mm";
        } else if(_datePicker.datePickerMode == UIDatePickerModeDate) {
            return @"dd/MM/yyyy";
        }
    }
    return _dateDisplayFormat;
}

- (NSString *)dateStringFromDate:(NSDate *)date withFormat:(NSString *)format {
    static NSDateFormatter *formatter = nil;
    if(!formatter) {
        formatter = [[NSDateFormatter alloc] init];
    }
    [formatter setDateFormat: format];
    return [formatter stringFromDate: date];
}

@end
