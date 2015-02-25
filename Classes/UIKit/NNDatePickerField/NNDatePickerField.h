//
//  NNDatePickerField.h
//  NNLibraries
//
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NNDatePickerField;

@protocol NNDatePickerFieldDelegate <NSObject>
@optional
- (void)datePickerField:(NNDatePickerField *)datePickerField dateChangedToDate:(NSDate *)date;
- (BOOL)datePickerField:(NNDatePickerField *)datePickerField shouldChangeToDate:(NSDate *)date;
@end

@interface NNDatePickerField : UITextField
/** If not set, will use the text field's original <b>text</b> <i>property</i>. */
@property (nonatomic, strong) NSString *pickerPlaceholder;
@property (nonatomic, strong, readonly) NSDate *selectedDate;
/** The format in which the selected date will be displayed. If not set, default to dd/MM/yyyy */
@property (nonatomic, strong) NSString *dateDisplayFormat;
@property (nonatomic, weak) id<NNDatePickerFieldDelegate> datePickerDelegate;
@property (nonatomic) UIDatePickerMode datePickerMode;

- (void)setCurrentDate:(NSDate *)date;
- (NSString *)selectedDateStringWithFormat:(NSString *)format;
/**
 *  Sets the minimum date for the UIDatePicker. If there was already a selected date, it will be updated if it's any time before the minimum date.
 *  @param date The new minimum date
 */
- (void)setMinimumDate:(NSDate *)date;
- (NSDate *)minimumDate;

- (void)setMaximumDate:(NSDate *)date;
- (NSDate *)maximumDate;

/**
 *  Shows an input accessory view, a toolbar above the picker.
 *  @param cleanTitle The cleanup button title
 *  @param closeTitle The close button title
 *  @param title      the title for the picker, will be displayed in the center of the picker.
 *  @param color      The color, default to <b>'blackColor'</b>
 */
- (void)setShowsToolBarWithCleanButtonTitle:(NSString *)cleanTitle
                       withCloseButtonTitle:(NSString *)closeTitle
                                  withTitle:(NSString *)title
                             withTitleColor:(UIColor *)color;
@end
