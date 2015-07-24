//
//  NNPickerField.h
//  NNLibraries
//
//  Created by Natan Abramov on 2/28/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NNPickerField;

@protocol NNPickerFieldDelegate <NSObject>
@optional
- (void)pickerFieldDidClose:(NNPickerField *)pickerField;
- (void)pickerFieldDidClearSelection:(NNPickerField *)pickerField;
//Maybe in the future (for all subclasses)
//- (BOOL)pickerField:(NNPickerField *)pickerField shouldSelectRow:(NSInteger)row inComponent:(NSInteger)component;
//- (void)pickerField:(NNPickerField *)pickerField didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
@end

/**
 *  <strong>Abstract class!!! DO NOT USE IT!</strong>
 *  Used as a super class for the different picker fields e.g.: NNObjectPickerField and NNDatePickerField.
 */
@interface NNPickerField : UITextField {
    id pickerDelegate;
}
@property (nonatomic, weak) id<NNPickerFieldDelegate> pickerDelegate;
@property (nonatomic, copy) NSString *pickerPlaceholder;

/**
 *  Shows an input accessory view, a toolbar above the picker.
 *  @param title      the title for the picker, will be displayed in the center of the picker.
 *  @param closeTitle The close button title
 *  @param cleanTitle The cleanup button title
 *  @param color      The color, default to <b>'blackColor'</b>
 */
- (void)setShowsToolBarWithTitle:(NSString *)title
            withCloseButtonTitle:(NSString *)closeTitle
                  withClearTitle:(NSString *)clearTitle
                  withTitleColor:(UIColor *)color;


#pragma mark - PRIVATE METHODS
/** @warning Private method! Calling this method will result in unexpected behavior! */
- (void)setupPicker;
/** @warning Private method! Calling this method will result in unexpected behavior! */
- (UIToolbar *)inputAccessoryToolbar;
/** @warning Private method! Calling this method will result in unexpected behavior! */
- (void)closePicker;
/** @warning Private method! Calling this method will result in unexpected behavior! */
- (void)clearField;
/** @warning Private method! Calling this method will result in unexpected behavior! */
- (void)unlinkPicker;
@end
