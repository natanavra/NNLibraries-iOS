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
+ (BOOL)validBooleanFromObject:(id)object;

+ (NSDictionary *)parseJsonFromData:(NSData *)data;

//File Management
+ (NSString *)pathToDocumentsDirectory;
+ (NSString *)pathToFileInDocumentsDirectory:(NSString *)fileName;
+ (BOOL)fileExistsInDocumentsDirectory:(NSString *)fileName;
+ (BOOL)fileExistsAtPath:(NSString *)path;

//Device specific utilities
+ (BOOL)isBigDevice;
+ (CGFloat)deviceWidth;

//UIColor
+ (UIColor *)colorWithHexString: (NSString *)stringToConvert;
+ (UIColor *)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;
@end
