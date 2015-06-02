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

/** 
 A collection of unsorted utilities.
 Slowly moves to class categories for modulation and organization of code.
 */
@interface NNUtilities : NSObject

//object validation methods
+ (id)validObjectFromObject:(id)object;
+ (NSString *)validStringFromObject:(id)object;
+ (NSInteger)validIntegerFromObject:(id)object;
+ (float)validFloatFromObject:(id)object;
+ (double)validDoubleFromObject:(id)object;
+ (BOOL)validBooleanFromObject:(id)object;
+ (BOOL)validBooleanFromObject:(id)object fallbackValue:(BOOL)fallback;

//JSON
+ (id)parseJSONFromData:(NSData *)data;
+ (NSData *)JSONDataFromDictionary:(NSDictionary *)json;
+ (NSData *)JSONDataFromDictionary:(NSDictionary *)json prettyPrinted:(BOOL)pretty;

//File Management
+ (NSString *)pathToDocumentsDirectory;
+ (NSString *)pathToFileInDocumentsDirectory:(NSString *)fileName;
+ (BOOL)fileExistsInDocumentsDirectory:(NSString *)fileName;
+ (BOOL)fileExistsAtPath:(NSString *)path;
+ (BOOL)archiveObjectToDocumentsDirectory:(id)object withName:(NSString *)fileName;
+ (id)unarchiveObjectFromDocumentsDirectory:(NSString *)fileName;

//Device specific utilities
+ (BOOL)isDeviceSimulator;
+ (BOOL)iPhone4Screen;
+ (BOOL)iPhone5Screen;
+ (BOOL)iPhone6Screen;
+ (BOOL)iPhone6PlusScreen;
+ (BOOL)isBigDevice;
+ (CGFloat)screenHeight;
+ (CGFloat)deviceWidth;
+ (NSString *)UDID;

//UIColor
+ (UIColor *)colorWithHexString: (NSString *)stringToConvert;
+ (UIColor *)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;

//Other
+ (NSString *)appShortVersionNumber;
+ (NSString *)appLongVersionNumber;
+ (NSString *)appLongLocalizedVersionNumber;
+ (NSString *)currentTimestampString;
+ (NSString *)NSStringFromUIInterfaceOrientation:(UIInterfaceOrientation)orientation;
+ (UIImage *)imageNamedWithOriginalRendering:(NSString *)imageName;
+ (CGRect)CGRectByInseting:(CGRect)rect insets:(UIEdgeInsets)insets;
+ (CGRect)CGRectByOffseting:(CGRect)rect offset:(UIEdgeInsets)insets;
+ (BOOL)isDebugMode;
/** Return YES if 0 <= number <= 1. NO otherwise. */
+ (BOOL)numberBetween0And1:(float)number;

+ (NSArray *)uniqueCopyArray:(NSArray *)array;

//URLs
+ (BOOL)navigateWazeOrMapsWithAddress:(NSString *)address;
+ (BOOL)navigateWazeOrMapsWithLongitude:(double)longitude latitude:(double)latitude;
+ (BOOL)callNumber:(NSString *)number;

@end