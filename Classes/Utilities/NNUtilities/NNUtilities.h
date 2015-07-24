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
+ (id)validObjectFromObject:(id)object DEPRECATED_MSG_ATTRIBUTE("Use 'NNJSONUtilities' instead");;
+ (NSString *)validStringFromObject:(id)object DEPRECATED_MSG_ATTRIBUTE("Use 'NNJSONUtilities' instead");;
+ (NSInteger)validIntegerFromObject:(id)object DEPRECATED_MSG_ATTRIBUTE("Use 'NNJSONUtilities' instead");;
+ (float)validFloatFromObject:(id)object DEPRECATED_MSG_ATTRIBUTE("Use 'NNJSONUtilities' instead");;
+ (double)validDoubleFromObject:(id)object DEPRECATED_MSG_ATTRIBUTE("Use 'NNJSONUtilities' instead");;
+ (BOOL)validBooleanFromObject:(id)object DEPRECATED_MSG_ATTRIBUTE("Use 'NNJSONUtilities' instead");;
+ (BOOL)validBooleanFromObject:(id)object fallbackValue:(BOOL)fallback DEPRECATED_MSG_ATTRIBUTE("Use 'NNJSONUtilities' instead");;

+ (NSString *)descriptionFromObject:(id)object DEPRECATED_MSG_ATTRIBUTE("Use 'NSObject+NNAdditions >> nnDescription instead");

//JSON
+ (id)parseJSONFromData:(NSData *)data DEPRECATED_MSG_ATTRIBUTE("Use 'NNJSONUtilities' instead");
+ (NSData *)JSONDataFromDictionary:(NSDictionary *)json DEPRECATED_MSG_ATTRIBUTE("Use 'NNJSONUtilities' instead");
+ (NSData *)JSONDataFromDictionary:(NSDictionary *)json prettyPrinted:(BOOL)pretty DEPRECATED_MSG_ATTRIBUTE("Use 'NNJSONUtilities' instead");

//File Management
+ (NSString *)pathToDocumentsDirectory;
+ (NSString *)pathToFileInDocumentsDirectory:(NSString *)fileName;
+ (BOOL)fileExistsInDocumentsDirectory:(NSString *)fileName;
+ (BOOL)fileExistsAtPath:(NSString *)path;
+ (BOOL)archiveObjectToDocumentsDirectory:(id)object withName:(NSString *)fileName;
+ (id)unarchiveObjectFromDocumentsDirectory:(NSString *)fileName;

//Device specific utilities
+ (BOOL)isDeviceSimulator DEPRECATED_MSG_ATTRIBUTE("Use 'UIDevice+NNAdditions' instead");
+ (BOOL)iPhone4Screen DEPRECATED_MSG_ATTRIBUTE("Use 'UIDevice+NNAdditions' instead");
+ (BOOL)iPhone5Screen DEPRECATED_MSG_ATTRIBUTE("Use 'UIDevice+NNAdditions' instead");
+ (BOOL)iPhone6Screen DEPRECATED_MSG_ATTRIBUTE("Use 'UIDevice+NNAdditions' instead");
+ (BOOL)iPhone6PlusScreen DEPRECATED_MSG_ATTRIBUTE("Use 'UIDevice+NNAdditions' instead");
+ (BOOL)isBigDevice DEPRECATED_MSG_ATTRIBUTE("Use 'UIDevice+NNAdditions' instead");
+ (CGFloat)screenHeight DEPRECATED_MSG_ATTRIBUTE("Use 'UIDevice+NNAdditions' instead");
+ (CGFloat)deviceWidth DEPRECATED_MSG_ATTRIBUTE("Use 'UIDevice+NNAdditions' instead");
+ (NSString *)UDID DEPRECATED_MSG_ATTRIBUTE("Use 'UIDevice+NNAdditions' instead");

//UIColor
+ (UIColor *)colorWithHexString: (NSString *)stringToConvert DEPRECATED_MSG_ATTRIBUTE("Use 'UIColor+NNAdditions' instead");
+ (UIColor *)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height DEPRECATED_MSG_ATTRIBUTE("Use 'UIColor+NNAdditions' instead");

//Other
+ (NSString *)uniqueIdentifier;
+ (NSString *)appShortVersionNumber;
+ (NSString *)appLongVersionNumber;
+ (NSString *)appLongLocalizedVersionNumber;
+ (NSString *)currentTimestampString;
+ (NSString *)NSStringFromUIInterfaceOrientation:(UIInterfaceOrientation)orientation;
+ (UIImage *)imageNamedWithOriginalRendering:(NSString *)imageName DEPRECATED_MSG_ATTRIBUTE("Use 'UIImage+NNAdditions' instead");
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