//
//  NNUtilities.h
//  FourSigns
//
//  Created by Natan Abramov on 9/4/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define rgba(r, g, b, a) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha: a]

/** All sorts of utilities (File, JSON parsing, device checking, etc). possibly when gets too large will be broken down to several different classes. */
@interface NNUtilities : NSObject

//object validation methods
+ (id)validObjectFromObject:(id)object;
+ (NSString *)validStringFromObject:(id)object;
+ (NSInteger)validIntegerFromObject:(id)object;
+ (float)validFloatFromObject:(id)object;
+ (double)validDoubleFromObject:(id)object;
+ (BOOL)validBooleanFromObject:(id)object;
+ (NSString *)trimWhiteSpace:(NSString *)string;

//JSON
+ (NSDictionary *)parseJsonFromData:(NSData *)data;
+ (NSData *)jsonDataFromDictionary:(NSDictionary *)json;

//File Management
+ (NSString *)pathToDocumentsDirectory;
+ (NSString *)pathToFileInDocumentsDirectory:(NSString *)fileName;
+ (BOOL)fileExistsInDocumentsDirectory:(NSString *)fileName;
+ (BOOL)fileExistsAtPath:(NSString *)path;

//Device specific utilities
+ (BOOL)isBigDevice;
+ (CGFloat)deviceWidth;
+ (NSString *)UDID;

//UIColor
+ (UIColor *)colorWithHexString: (NSString *)stringToConvert;
+ (UIColor *)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;

//Other
+ (NSString *)currentTimestampString;
+ (NSString *)NSStringFromUIInterfaceOrientation:(UIInterfaceOrientation)orientation;
+ (UIImage *)imageNamedWithOriginalRendering:(NSString *)imageName;
+ (CGRect)CGRectByInseting:(CGRect)rect insets:(UIEdgeInsets)insets;
+ (CGRect)CGRectByOffseting:(CGRect)rect offset:(UIEdgeInsets)insets;
/** Return YES if 0 <= number <= 1. NO otherwise. */
+ (BOOL)numberBetween0And1:(float)number;

+ (NSArray *)uniqueCopy:(NSArray *)array;

//URLs
+ (void)navigateWazeOrMapsWithAddress:(NSString *)address;
+ (void)navigateWazeOrMapsWithLongitude:(double)longitude latitude:(double)latitude;
+ (void)callNumber:(NSString *)number;

@end