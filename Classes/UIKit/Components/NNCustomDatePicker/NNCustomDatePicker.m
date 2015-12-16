//
//  NNCustomDatePicker.m
//  NNLibraries
//
//  Created by Natan Abramov on 1/29/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNCustomDatePicker.h"
#import "NSDate+NNAdditions.h"

const NSInteger kMinYear = 0;
const NSInteger kMaxYear = 10000;

@interface NNCustomDatePicker () <UIPickerViewDelegate, UIPickerViewDataSource> {
    BOOL _initialized;
    BOOL _dateChanged;
}
@property (nonatomic, strong) NSDateComponents *selectedDateComponents;
@property (nonatomic) NSInteger numUnits;
@property (nonatomic) NSInteger numDays;
@end

@implementation NNCustomDatePicker

#pragma mark - Helpers

NSInteger numUnitsInBitmask(NNDateUnit mask) {
    NSInteger flagsCount = 0;
    while(mask != 0x0) {
        if(mask & 0x1) {
            flagsCount ++;
        }
        mask >>= 1;
    }
    return flagsCount;
}

NNDateUnit unitInBitMaskWithIndex(NNDateUnit mask, NSInteger index) {
    if(index > numUnitsInBitmask(mask) - 1) {
        return NNDateUnitNone;
    }
    
    NSInteger numShifts = -1;
    NSInteger flagsCount = -1;
    while(flagsCount != index && mask != 0x0) {
        if(mask & 0x1) {
            flagsCount ++;
        }
        mask >>= 1;
        numShifts ++;
    }
    
    if(numShifts == -1) {
        return NNDateUnitNone;
    }
    
    NNDateUnit retVal = 1 << numShifts;
    return retVal;
}

NSInteger indexOfUnitInBitMask(NNDateUnit mask, NNDateUnit component) {
    if((mask & component) == 0x0) {
        return NSNotFound;
    }
    
    NSInteger flagsCount = -1;
    NNDateUnit counter = 1 << 0;
    while((component & counter) == 0x0) {
        if(mask & counter) {
            flagsCount ++;
        }
        counter <<= 1;
    }
    return flagsCount + 1;
}

NSCalendarUnit calendarUnitsFromNNDateUnits(NNDateUnit mask) {
    NSCalendarUnit unit = 0;
    if(mask & NNDateUnitSecond) {
        unit |= NSCalendarUnitSecond;
    }
    if(mask & NNDateUnitMinute) {
        unit |= NSCalendarUnitMinute;
    }
    if(mask & NNDateUnitHour) {
        unit |= NSCalendarUnitHour;
    }
    if(mask & NNDateUnitDay) {
        unit |= NSCalendarUnitDay;
    }
    if(mask & NNDateUnitMonth) {
        unit |= NSCalendarUnitMonth;
    }
    if(mask & NNDateUnitYear) {
        unit |= NSCalendarUnitYear;
    }
    return unit;
}

NNDateUnit fullUnitMask() {
    NSInteger counter = 1 << 0;
    NSInteger lastMask = 1 << NNDateUnitOrderLast;
    NSInteger mask = counter;
    while(counter < lastMask) {
        counter <<= 1;
        mask += counter;
    }
    return mask;
}

+ (NSArray *)months {
    static NSArray *months = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        months = [NSDate monthSymbols];
    });
    return months;
}

- (NSDateComponents *)currentDateComponents {
    static NSDateComponents *currentDateComponents = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        currentDateComponents = [[self selectedDateComponents] copy];
    });
    
    for(int i = 0 ; i < _numUnits ; i ++) {
        NSInteger selectedRow = [self selectedRowInComponent: i];
        NNDateUnit comp = unitInBitMaskWithIndex(_units, i);
        
        if(comp & NNDateUnitSecond) {
            currentDateComponents.second = selectedRow;
        } else if(comp & NNDateUnitMinute) {
            currentDateComponents.minute = selectedRow;
        } else if(comp & NNDateUnitHour) {
            currentDateComponents.hour = selectedRow;
        } else if(comp & NNDateUnitDay) {
            currentDateComponents.day = selectedRow + 1;
        } else if(comp & NNDateUnitMonth) {
            currentDateComponents.month = selectedRow + 1;
        } else if(comp & NNDateUnitYear) {
            currentDateComponents.year = selectedRow;
        }
    }
    return currentDateComponents;
}

- (NSDateComponents *)selectedDateComponents {
    if(_dateChanged || !_selectedDateComponents) {
        if(!_selectedDateComponents) {
            _selectedDateComponents = [[NSDateComponents alloc] init];
        }
        _selectedDateComponents = [NSDate dateComponents: calendarUnitsFromNNDateUnits(fullUnitMask()) fromDate: _selectedDate];
        _dateChanged = NO;
    }
    return _selectedDateComponents;
}

- (void)applySelectedDateToPicker {
    NSDateComponents *components = [self selectedDateComponents];
    BOOL monthDisplayed = _units & NNDateUnitMonth;
    for(int i = 0 ; i < _numUnits ; i ++) {
        NNDateUnit comp = unitInBitMaskWithIndex(_units, i);
        NSInteger newRow = 0;
        if(comp & NNDateUnitSecond) {
            newRow = components.second;
        } else if(comp & NNDateUnitMinute) {
            newRow = components.minute;
        } else if(comp & NNDateUnitHour) {
            newRow = components.hour;
        } else if(comp & NNDateUnitDay) {
            if(monthDisplayed) {
                newRow = components.day - 1;
            } else {
                newRow = [NSDate daysInYear: _selectedDate] - 1;
            }
        } else if(comp & NNDateUnitMonth) {
            newRow = components.month - 1;
        } else if(comp & NNDateUnitYear) {
            newRow = components.year;
        }
        [self selectRow: newRow inComponent: i animated: YES];
    }
}

#pragma mark - INIT

- (instancetype)init {
    return [self initWithDateUnits: NNDateUnitNone];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame: frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    if(self = [super initWithCoder: decoder]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithDateUnits:(NNDateUnit)components {
    if(self = [super init]) {
        [self initialize];
        self.units = components;
    }
    return self;
}

- (void)initialize {
    if(!_initialized) {
        self.delegate = self;
        self.dataSource = self;
        
        _minimumDate = nil;
        _maximumDate = nil;
        self.selectedDate = [NSDate date];
        [self applySelectedDateToPicker];
        _initialized = YES;
    }
}

#pragma mark - UIPickerView Delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _numUnits;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NNDateUnit comp = unitInBitMaskWithIndex(_units, component);
    NSInteger numRows = 0;
    if(comp & NNDateUnitSecond || comp & NNDateUnitMinute) {
        numRows = 60;
    } else if(comp & NNDateUnitHour) {
        numRows = 24;
    } else if(comp & NNDateUnitDay) {
        numRows = _numDays;
    } else if(comp & NNDateUnitMonth) {
        numRows = [[self class] months].count;
    } else if(comp & NNDateUnitYear) {
        numRows = (kMaxYear - kMinYear) + 1;
    }
    return numRows;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NNDateUnit comp = unitInBitMaskWithIndex(_units, component);
    NSString *title = @"";
    if(comp & NNDateUnitSecond || comp & NNDateUnitMinute) {
        title = [NSString stringWithFormat: @"%zd", row];
    } else if(comp & NNDateUnitHour) {
        title = [NSString stringWithFormat: @"%zd", row];
    } else if(comp & NNDateUnitYear) {
        title = [NSString stringWithFormat: @"%zd", row];
    } else if(comp & NNDateUnitDay) {
        title = [NSString stringWithFormat: @"%zd", row + 1];
    } else if(comp & NNDateUnitMonth) {
        title = [[[self class] months] objectAtIndex: row];
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDateComponents *dateComponents = [self currentDateComponents];
    
    NSInteger newNumDays = 0;
    if(_units & NNDateUnitMonth) {
        newNumDays = [NSDate numberOfDaysInMonth: dateComponents.month inYear: dateComponents.year];
    } else {
        newNumDays = [NSDate numberOfDaysInYear: dateComponents.year];
    }
    if(dateComponents.day > newNumDays) {
        dateComponents.day = newNumDays;
    }
    
    NSDate *newDate = [NSDate dateFromComponents: dateComponents];
    
    BOOL shouldSelect = YES;
    if([newDate compare: _minimumDate] == NSOrderedAscending) {
        shouldSelect = NO;
    } else if([newDate compare: _maximumDate] == NSOrderedDescending) {
        shouldSelect = NO;
    } else if([_customDateDelegate respondsToSelector: @selector(customDatePicker:shouldSelectDate:)]) {
        shouldSelect = [_customDateDelegate customDatePicker: self shouldSelectDate: newDate];
    }
    
    if(shouldSelect) {
        self.selectedDate = newDate;
        
        [self reloadComponent: component];
        
        if([_customDateDelegate respondsToSelector: @selector(customDatePicker:didSelectDate:)]) {
            [_customDateDelegate customDatePicker: self didSelectDate: _selectedDate];
        }
    } else {
        [self applySelectedDateToPicker];
    }
}

#pragma mark - Overrides

- (void)setUnits:(NNDateUnit)units {
    _units = units;
    _numUnits = numUnitsInBitmask(_units);
    if(_initialized) {
        [self reloadAllComponents];
    }
}

- (void)setSelectedDate:(NSDate *)selectedDate {
    if(selectedDate == nil) {
        return;
    }
    
    _dateChanged = YES;
    _selectedDate = selectedDate;
    NSInteger daysIndex = indexOfUnitInBitMask(_units, NNDateUnitDay);
    if(daysIndex != NSNotFound) {
        if(_units & NNDateUnitMonth) {
            _numDays = [NSDate numberOfDaysInMonth: selectedDate];
        } else {
            _numDays = [NSDate numberOfDaysInYearWithDate: selectedDate];
        }
        [self reloadComponent: daysIndex];
    }
    [self applySelectedDateToPicker];
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    if([_selectedDate compare: _minimumDate] == NSOrderedAscending) {
        _selectedDate = _minimumDate;
        [self applySelectedDateToPicker];
    }
    _minimumDate = minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    if([_selectedDate compare: _maximumDate] == NSOrderedDescending) {
        _selectedDate = _maximumDate;
        [self applySelectedDateToPicker];
    }
    _maximumDate = maximumDate;
}

- (void)setDelegate:(id<UIPickerViewDelegate>)delegate {
    if(delegate == self) {
        [super setDelegate: self];
    } else {
        NSAssert(NO, @"NNCustomDatePicker--Do not set the delegate!");
    }
}

- (void)setDataSource:(id<UIPickerViewDataSource>)dataSource {
    if(dataSource == self) {
        [super setDataSource: self];
    } else {
        NSAssert(NO, @"NNCustomDatePicker--Do not set the dataSource!");
    }
}

@end