//
//  NNPickerField.h
//  NNLibraries
//
//  Created by Natan Abramov on 1/9/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NNPickerField;

@protocol NNPickerFieldDelegate <NSObject>
@optional
- (BOOL)pickerField:(NNPickerField *)picker shouldSelectObjectAtIndex:(NSInteger)index;
- (void)pickerField:(NNPickerField *)picker didSelectObject:(id)object atIndex:(NSInteger)index;
- (void)pickerFieldDidFinishSelection:(NNPickerField *)picker;
- (void)pickerFieldDidCleanSelection:(NNPickerField *)picker;

- (void)pickerField:(NNPickerField *)picker didSelectNumber:(NSInteger)number;
@end

@interface NNPickerField : UITextField
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, readonly) NSInteger selectedIndex;
@property (nonatomic, readonly) id selectedObject;

@property (nonatomic) BOOL showsRange;
@property (nonatomic) NSInteger selectedNumber;
@property (nonatomic) NSInteger fromNumber;
@property (nonatomic) NSInteger toNumber;

@property (nonatomic, weak) id<NNPickerFieldDelegate> pickerDelegate;

- (void)showNumberRangeFromNumber:(NSInteger)fromNumber toNumber:(NSInteger)toNumber;

- (void)setCurrentSelectedIndex:(NSInteger)index;

- (void)setCloseButtonTitle:(NSString *)title __attribute__((deprecated("Use 'setShowsToolBarWithCleanButtonTitle:...' instead")));
- (void)setClearButtonTitle:(NSString *)title __attribute__((deprecated("Use 'setShowsToolBarWithCleanButtonTitle:...' instead")));

- (void)setShowsToolBarWithCleanButtonTitle:(NSString *)cleanTitle
                       withCloseButtonTitle:(NSString *)closeTitle
                                  withTitle:(NSString *)title
                             withTitleColor:(UIColor *)color;
@end
