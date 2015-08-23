//
//  NNUtilities.m
//  FourSigns
//
//  Created by Natan Abramov on 9/4/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "NNUtilities.h"
#import "NNLogger.h"
#import "NSString+NNAdditions.h"
#import "NNConstants.h"

@implementation NNUtilities

#pragma mark - Object Validations

+ (id)validObjectFromObject:(id)object {
    if(object == [NSNull null] || object == nil) {
        return nil;
    }
    return object;
}

+ (NSString *)validStringFromObject:(id)object {
    if([self validObjectFromObject: object]) {
        if([object isKindOfClass: [NSString class]]) {
            return object;
        }
        return [object stringValue];
    }
    return @"";
}

+ (NSInteger)validIntegerFromObject:(id)object {
    if([self validObjectFromObject: object]) {
        return [object integerValue];
    }
    return 0;
}

+ (float)validFloatFromObject:(id)object {
    if([self validObjectFromObject: object]) {
        return [object floatValue];
    }
    return 0.0f;
}

+ (double)validDoubleFromObject:(id)object {
    if([self validObjectFromObject: object]) {
        return [object doubleValue];
    }
    return 0.0;
}

+ (BOOL)validBooleanFromObject:(id)object {
    return [self validBooleanFromObject: object fallbackValue: NO];
}

+ (BOOL)validBooleanFromObject:(id)object fallbackValue:(BOOL)fallback {
    if([self validObjectFromObject: object]) {
        return [object boolValue];
    }
    return fallback;
}

+ (NSString *)descriptionFromObject:(id)object {
    NSString *description = nil;
    if([object isKindOfClass: [NSString class]]) {
        description = object;
    } else if([object isKindOfClass: [NSData class]]) {
        description = [[NSString alloc] initWithData: object encoding: NSUTF8StringEncoding];
    } else if([object isKindOfClass: [NSDictionary class]]) {
        
    }
    
    if(!description || description.length == 0) {
        description = [object description];
    }
    return description;
}

#pragma mark - JSON

+ (id)parseJSONFromData:(NSData *)data {
    return [self parseJSONFromData: data error: nil];
}

+ (id)parseJSONFromData:(NSData *)data error:(NSError **)error {
    if(!data) {
        [NNLogger logFromInstance: self message: @"'parseJSONFromData:' not valid data"];
        return nil;
    }
    NSError *err = nil;
    id json = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingAllowFragments error: &err];
    
    if(err) {
        [NNLogger logFromInstance: self message: @"'parseJSONFromData:' unable to parse data" data: err];
        return nil;
    } else {
        return json;
    }
}

+ (NSData *)JSONDataFromDictionary:(NSDictionary *)json {
    return [self JSONDataFromDictionary: json prettyPrinted: NO];
}

+ (NSData *)JSONDataFromDictionary:(NSDictionary *)json prettyPrinted:(BOOL)pretty {
    if(!json) {
        [NNLogger logFromInstance: self message: @"'JSONDataFromDictionary:' not valid JSON/Dictionary object"];
    }
    NSData *retVal = nil;
    if([NSJSONSerialization isValidJSONObject: json]) {
        NSError *err = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject: json options: pretty ? NSJSONWritingPrettyPrinted : kNilOptions error: &err];
        
        if(err) {
            [NNLogger logFromInstance: self message: @"'JSONDataFromDictionary:' unable to create JSON data from object" data: err];
        } else {
            retVal = jsonData;
        }
    } else {
        [NNLogger logFromInstance: self message: @"Not a valid json object" data: json];
    }
    return retVal;
}

#pragma mark - File Paths

+ (NSString *)pathToDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,  YES);
    return [paths objectAtIndex: 0];
}

+ (NSString *)pathToFileInDocumentsDirectory:(NSString *)fileName {
    return [[self pathToDocumentsDirectory] stringByAppendingPathComponent: fileName];
}

+ (BOOL)fileExistsInDocumentsDirectory:(NSString *)fileName {
    NSString *path = [self pathToFileInDocumentsDirectory: fileName];
    return [self fileExistsAtPath: path];
}

+ (BOOL)fileExistsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath: path];
}

+ (BOOL)archiveObjectToDocumentsDirectory:(id)object withName:(NSString *)fileName {
    NSString *path = [self pathToFileInDocumentsDirectory: fileName];
    return [NSKeyedArchiver archiveRootObject: object toFile: path];
}

+ (id)unarchiveObjectFromDocumentsDirectory:(NSString *)fileName {
    if([self fileExistsInDocumentsDirectory: fileName]) {
        return [NSKeyedUnarchiver unarchiveObjectWithFile: [self pathToFileInDocumentsDirectory: fileName]];
    }
    return nil;
}

#pragma mark - Device Utilities

+ (BOOL)isDeviceSimulator {
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else 
    return NO;
#endif
}

+ (BOOL)iPhone4Screen {
    return [self screenHeight] == 480;
}

+ (BOOL)iPhone5Screen {
    return [self screenHeight] == 568;
}

+ (BOOL)iPhone6Screen {
    return [self screenHeight] == 667;
}

+ (BOOL)iPhone6PlusScreen {
    return [self screenHeight] == 736;
}

+ (BOOL)isBigDevice {
    return [[UIScreen mainScreen] bounds].size.height > 480;
}

+ (CGFloat)deviceWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)screenHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (NSString *)UDID {
    NSUUID *udid = [[UIDevice currentDevice] identifierForVendor];
    return [udid UUIDString];
}

#pragma mark - Color Utilities

+ (UIColor *)colorWithHexString: (NSString *)stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString length] != 6) return [UIColor blackColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height {
    CGSize size = CGSizeMake(1, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    NSArray* colors = [NSArray arrayWithObjects:(id)c1.CGColor, (id)c2.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, NULL);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(0, size.height), 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];
}

#pragma mark - Other

+ (NSString *)uniqueIdentifier {
    NSUUID *uuid = [NSUUID UUID];
    NSString *uuidStr = [uuid UUIDString];
    uuidStr = [uuidStr stringByReplacingOccurrencesOfString: @"-" withString: @""];
    return uuidStr;
}

+ (NSString *)appShortVersionNumber {
    NSString *shortVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    return shortVersion;
}

+ (NSString *)appLongVersionNumber {
    NSString *shortVersion = [self appShortVersionNumber];
    NSString *longVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    return [shortVersion stringByAppendingFormat: @" (%@)", longVersion];
}

+ (NSString *)appLongLocalizedVersionNumber {
    NSString *shortVersion = [self appShortVersionNumber];
    NSString *longVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    return [shortVersion stringByAppendingFormat: @" (%@ %@)", NNLocalizedString(@"Build"), longVersion];
}

+ (NSString *)currentTimestampString {
    NSTimeInterval interval = [NSDate timeIntervalSinceReferenceDate];
    return [NSString stringWithFormat: @"%d", (int)interval];
}

+ (BOOL)numberBetween0And1:(float)number {
    BOOL retVal = NO;
    if(number >= 0 && number <= 1) {
        retVal = YES;
    }
    return retVal;
}

+ (NSArray *)uniqueCopyArray:(NSArray *)array {
    NSSet *set = [NSSet setWithArray: array];
    return [set allObjects];
}

+ (UIImage *)imageNamedWithOriginalRendering:(NSString *)imageName {
    return [[UIImage imageNamed: imageName] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
}

+ (CGRect)CGRectByInseting:(CGRect)rect insets:(UIEdgeInsets)insets {
    return CGRectMake(CGRectGetMinX(rect)+insets.left,
                      CGRectGetMinY(rect)+insets.top,
                      CGRectGetWidth(rect)-insets.left-insets.right,
                      CGRectGetHeight(rect)-insets.top-insets.bottom);
}

+ (CGRect)CGRectByOffseting:(CGRect)rect offset:(UIEdgeInsets)insets {
    return CGRectMake(CGRectGetMinX(rect) - insets.left,
                      CGRectGetMinY(rect) - insets.top,
                      CGRectGetWidth(rect) + insets.right,
                      CGRectGetHeight(rect) +insets.bottom);
}

+ (NSString *)NSStringFromUIInterfaceOrientation:(UIInterfaceOrientation)orientation {
    switch (orientation) {
        case UIInterfaceOrientationPortrait:           return @"UIInterfaceOrientationPortrait";
        case UIInterfaceOrientationPortraitUpsideDown: return @"UIInterfaceOrientationPortraitUpsideDown";
        case UIInterfaceOrientationLandscapeLeft:      return @"UIInterfaceOrientationLandscapeLeft";
        case UIInterfaceOrientationLandscapeRight:     return @"UIInterfaceOrientationLandscapeRight";
        case UIInterfaceOrientationUnknown:            return @"UIInterfaceOrientationUnknown";
    }
    return @"Unexpected";
}

+ (BOOL)isValidEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", emailRegex];
    BOOL validEmail = [emailPredicate evaluateWithObject: email];
    return validEmail;
}

+ (BOOL)isDebugMode {
#ifdef DEBUG
    return YES;
#else 
    return NO;
#endif
}

#pragma mark - URLs

+ (BOOL)navigateWazeOrMapsWithAddress:(NSString *)address {
    [NNLogger logFromInstance: self message: @"Navigating to address" data: address];
    NSString *mapsURL = [NSString stringWithFormat: @"waze://?q=%@&navigate=yes", address];
    BOOL success = [self applicationURLOpenIfCan: mapsURL];
    if(!success) {
        mapsURL = [NSString stringWithFormat: @"http://maps.apple.com/?q=%@", address];
        success = [self applicationURLOpenIfCan: mapsURL];
    }
    return success;
}

+ (BOOL)navigateWazeOrMapsWithLongitude:(double)longitude latitude:(double)latitude {
    NSString *coordinateString = [NSString stringWithFormat: @"%f,%f", latitude, longitude];
    [NNLogger logFromInstance: self message: @"Navigating to coordinates" data: coordinateString];
    NSString *mapsURL = [NSString stringWithFormat: @"waze://?ll=%@&navigate=yes", coordinateString];
    BOOL success = [self applicationURLOpenIfCan: mapsURL];
    if(!success) {
        mapsURL = [NSString stringWithFormat: @"http://maps.apple.com/?ll=%@", coordinateString];
        success = [self applicationURLOpenIfCan: mapsURL];
    }
    return success;
}

+ (BOOL)applicationURLOpenIfCan:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString: urlString];
    BOOL success = [[UIApplication sharedApplication] openURL: url];
    if(!success) {
        [NNLogger logFromInstance: self message: @"Failed to open URL" data: urlString];
    }
    return success;
}

+ (BOOL)callNumber:(NSString *)number {
    NSString *numberWithoutSpaces = [number stringByRemovingAllWhiteSpace];
    NSString *phoneURL = [@"tel://" stringByAppendingString: numberWithoutSpaces];
    return [self applicationURLOpenIfCan: phoneURL];
}

@end
