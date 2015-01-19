//
//  NNDatePickerField.h
//  NNLibraries
//
//  Created by Natan Abramov on 1/17/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NNDatePickerField;

@protocol NNDatePickerFieldDelegate <NSObject>
- (void)datePickerField:(NNDatePickerField *)datePickerField dateChanged:(NSDate *)date;
- (BOOL)shouldChangeDate:(NSDate *)date inDatePickerField:(NNDatePickerField *)datePickerField;
@end

@interface NNDatePickerField : UITextField
@property (nonatomic, strong) NSDate *selectedDate;
/** The format in which the selected date will be displayed. If not set, default to dd/MM/yyyy */
@property (nonatomic, strong) NSString *dateDisplayFormat;
@property (nonatomic, weak) id<NNDatePickerFieldDelegate> datePickerDelegate;

- (void)setDatePickerMode:(UIDatePickerMode)newMode;
@end
