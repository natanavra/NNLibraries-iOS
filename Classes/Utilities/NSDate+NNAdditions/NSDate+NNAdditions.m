//
//  NSDate+NNAdditions.m
//  NNLibraries
//
//  Created by Natan Abramov on 1/28/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NSDate+NNAdditions.h"
#import "NNLogger.h"

NSString *const NSDatePOSIXFormat = @"yyyy-MM-dd 'T' HH:mm:ss 'Z'";

@implementation NSDate (NNAdditions)

#pragma mark - toString Transformers

- (NSString *)dateStringWithFormat:(NSString *)format {
    return [NSDate dateStringFromDate: self withFormat: format];
}

- (NSString *)POSIXFormatString {
    return [NSDate dateStringFromDate: self withFormat: NSDatePOSIXFormat];
}

- (BOOL)isDateInSameDay:(NSDate *)date {
    if(date) {
        NSDateComponents *selfComps = [NSDate dateComponents: NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate: self];
        NSDateComponents *dateComps = [NSDate dateComponents: NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate: date];

        //If the dates are in the same year, month and day... they're the same day.
        if(selfComps.year == dateComps.year && selfComps.month == dateComps.month && selfComps.day == dateComps.day) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)dateStringFromDate:(NSDate *)date withFormat:(NSString *)format {
    return [self dateStringFromDate: date withFormat: format withTimeZone: nil];
}

+ (NSString *)dateStringFromDate:(NSDate *)date withFormat:(NSString *)format withTimeZone:(NSTimeZone *)timeZone {
    NSAssert(date, [NNLogger logStringFromInstance: self message: @"Date must be a valid string!"]);
    NSAssert(format, [NNLogger logStringFromInstance: self message: @"Format must be valid string!"]);
    NSDateFormatter *formatter = [self dateFormatter];
    formatter.timeZone = timeZone ? timeZone : [NSTimeZone defaultTimeZone];
    formatter.dateFormat = format;
    return [formatter stringFromDate: date];
}

#pragma mark - Date Constructors

+ (NSDate *)dateFromComponents:(NSDateComponents *)components {
    NSCalendar *calendar = [self calendar];
    return [calendar dateFromComponents: components];
}

+ (NSDate *)dateFromString:(NSString *)dateString withFormat:(NSString *)format {
    NSDateFormatter *formatter = [self dateFormatter];
    formatter.dateFormat = format;
    return [formatter dateFromString: dateString];
}

+ (NSDateComponents *)dateComponents:(NSCalendarUnit)comps fromDate:(NSDate *)date {
    NSCalendar *calendar = [self calendar];
    return [calendar components: comps fromDate: date];
}

#pragma mark - Calendar Methods

+ (NSArray *)monthSymbols {
    NSCalendar *calendar = [self calendar];
    return [calendar monthSymbols];
}

+ (NSArray *)weekdaySymbols {
    NSCalendar *calendar = [self calendar];
    return [calendar weekdaySymbols];
}

+ (NSString *)AMSymbol {
    NSCalendar *calendar = [self calendar];
    return [calendar AMSymbol];
}

+ (NSString *)PMSymbol {
    NSCalendar *calendar = [self calendar];
    return [calendar PMSymbol];
}

+ (NSInteger)numberOfDaysInMonth:(NSDate *)date {
    NSRange range = [self rangeOfUnit: NSCalendarUnitDay inUnit: NSCalendarUnitMonth forDate: date];
    return (range.location != NSNotFound) ? range.length : 0;
}

+ (NSInteger)numberOfDaysInYearWithDate:(NSDate *)date {
    return [self numberOfDaysInYearWithComponents: [self dateComponents: NSCalendarUnitYear fromDate: date]];
}

+ (NSInteger)numberOfDaysInYear:(NSInteger)year {
    if(year == NSNotFound) {
        year = 1970;
    }
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    return [self numberOfDaysInYearWithComponents: components];
}

+ (NSInteger)numberOfDaysInYearWithComponents:(NSDateComponents *)components {
    NSDate *yearDate = [self dateFromComponents: components];
    components.year += 1;
    NSDate *nextYear = [self dateFromComponents: components];
    NSTimeInterval secondsInYear = [nextYear timeIntervalSinceDate: yearDate];
    return secondsInYear / (60 * 60 * 24);
}

+ (NSInteger)numberOfDaysInMonth:(NSInteger)month inYear:(NSInteger)year {
    if(year == NSNotFound) {
        year = 1970;
    }
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.month = month;
    comps.year = year;
    NSDate *date = [self dateFromComponents: comps];
    NSRange range = [self rangeOfUnit: NSCalendarUnitDay inUnit: NSCalendarUnitMonth forDate: date];
    return (range.location != NSNotFound) ? range.length : 0;
}

+ (NSInteger)daysInYear:(NSDate *)date {
    NSCalendar *calendar = [self calendar];
    return [calendar ordinalityOfUnit: NSCalendarUnitDay inUnit: NSCalendarUnitYear forDate: date];
}

+ (NSRange)rangeOfUnit:(NSCalendarUnit)unit1 inUnit:(NSCalendarUnit)unit2 forDate:(NSDate *)date {
    NSCalendar *calendar = [self calendar];
    NSRange range = [calendar rangeOfUnit: unit1 inUnit: unit2 forDate: date];
    return range;
}

#pragma mark - Cached Instances

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    return formatter;
}

+ (NSCalendar *)calendar {
    static NSCalendar *calendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar currentCalendar];
    });
    return calendar;
}

@end
