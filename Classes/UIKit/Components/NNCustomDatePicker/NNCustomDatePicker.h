//
//  NNCustomDatePicker.h
//  NNLibraries
//
//  Created by Natan Abramov on 1/29/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license.

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

/**
 Missing features:
 - Calculate width for each components, so more can be put on the screen.
 - Grayed out components out of the miniumum - maximum range.
 - Localization.
 - 12-Hour format support (Localization related)
 - Wrap around/circular picking
 */

/** The order to display the components, 0 is the left most. */
typedef NS_ENUM(NSInteger, NNDateUnitOrder) {
    NNDateUnitOrderDay = 0,
    NNDateUnitOrderMonth = 1,
    NNDateUnitOrderYear = 2,
    NNDateUnitOrderHour = 3,
    NNDateUnitOrderMinute = 4,
    NNDateUnitOrderSecond = 5,
    NNDateUnitOrderLast = NNDateUnitOrderSecond,
};

/** The date units to display in the date picker. Mutli-option '|' seperated */
typedef NS_OPTIONS(NSInteger, NNDateUnit) {
    NNDateUnitNone = 0,
    NNDateUnitSecond = 1 << NNDateUnitOrderSecond,
    NNDateUnitMinute = 1 << NNDateUnitOrderMinute,
    NNDateUnitHour = 1 << NNDateUnitOrderHour,
    NNDateUnitDay = 1 << NNDateUnitOrderDay,
    NNDateUnitMonth = 1 << NNDateUnitOrderMonth,
    NNDateUnitYear = 1 << NNDateUnitOrderYear,
};

@class NNCustomDatePicker;

@protocol NNCustomDatePickerDelegate <NSObject>
@optional
- (void)customDatePicker:(NNCustomDatePicker *)datePicker didSelectDate:(NSDate *)date;
- (BOOL)customDatePicker:(NNCustomDatePicker *)datePicker shouldSelectDate:(NSDate *)date;
@end

/**
 *  Custom UIDatePicker. Apple's picker does not offer the flexibility of choosing specific combinations - such and month/year, month/day, etc.
 *
 *  Instantiate with 'initWithDateUnits:' with the units you wish to be displayed in the picker. <br/>
 *  <strong>Example:</strong> (will display months and years)
 *  @code NNCustomDatePicker *picker = [[NNCustomDatePicker alloc] initWithDateUnits: (NNDateUnitYear | NNDateUnitMonth)]; @endcode
 *
 *  Currently only supports days, months, years, hours, minutes, seconds.
 *
 *  If days are presented but no months, displays as days in current year 0-364/365.
 *
 *  The supported years are 0 - 10000. <br/>
 *  Currently supports only 24-hour formats <br/>
 *  The ordering/priority of components when displayed is (left to right): days, months, years, hours, minutes, seconds <br/>
 */
@interface NNCustomDatePicker : UIPickerView
/** The custom date units to be displayed by the picker. This is a mask, combine values using the OR '|' operator <br/>
 *  <b>e.g.</b> (NNDateUnitSecond | NNDateUnitMinte) */
@property (nonatomic) NNDateUnit units;

/** The current date. Set this value to change the current date displayed by the picker. Defaults to '[NSDate date]'. <br/>
    <i>nil</i> does nothing. */
@property (nonatomic, copy) NSDate *selectedDate;

/** Custom delegate. Use this to fine tune selection with 'customDatePicker:shouldSelectDate:' or be informed of a change in selection with 'customDatePicker:didSelectDate'. Both methods are optional. */
@property (nonatomic, weak) id<NNCustomDatePickerDelegate> customDateDelegate;

/** The minimum selectable date. Will not allow dates before this to be selected. */
@property (nonatomic, copy) NSDate *minimumDate;
/** The maximum selectable date. Will not allow dates after this to be selected. */
@property (nonatomic, copy) NSDate *maximumDate;

/** Initialize with custom date units, or altenatively call other 'init' methods and then 'setUnits:'. */
- (instancetype)initWithDateUnits:(NNDateUnit)units;

/** The currently selected date broken down to the masks components. */
- (NSDateComponents *)selectedDateComponents;

@end