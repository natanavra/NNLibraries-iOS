//
//  NNUtilities.m
//  FourSigns
//
//  Created by Natan Abramov on 9/4/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "NNUtilities.h"
#import "NNLogger.h"

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
    if([self validObjectFromObject: object]) {
        return [object boolValue];
    }
    return NO;
}

+ (NSString *)trimWhiteSpace:(NSString *)string {
    return [string stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - JSON

+ (id)parseJsonFromData:(NSData *)data {
    if(data) {
        NSError *err = nil;
        id json = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingAllowFragments error: &err];
        if(err) {
            //Maybe implement some kind of error handling?
            [NNLogger logFromInstance: self message: [NSString stringWithFormat: @"Unable to parse JSON! %@", err]];
            return nil;
        } else {
            return json;
        }
    }
    return nil;
}

+ (NSData *)jsonDataFromDictionary:(NSDictionary *)json {
    NSError *err = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject: json options: 0 error: &err];
    if(err) {
        [NNLogger logFromInstance: self message: [NSString stringWithFormat: @"Unable to create data from NSDictionary: %@", err]];
        return [NSData data];
    } else {
        return jsonData;
    }
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

+ (BOOL)isBigDevice {
    return [[UIScreen mainScreen] bounds].size.height > 480;
}

+ (CGFloat)deviceWidth {
    return [[UIScreen mainScreen] bounds].size.width;
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

+ (NSArray *)uniqueCopy:(NSArray *)array {
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

#pragma mark - URLs
+ (void)navigateWazeOrMapsWithAddress:(NSString *)address {
    [NNLogger logFromInstance: self message: @"Navigating to address" data: address];
    NSString *mapsURL = [NSString stringWithFormat: @"waze://?q=%@&navigate=yes", address];
    if([self applicationURLOpenIfCan: mapsURL]) {
        mapsURL = [NSString stringWithFormat: @"http://maps.apple.com/?q=%@", address];
        [self applicationURLOpenIfCan: mapsURL];
    }
}

+ (void)navigateWazeOrMapsWithLongitude:(double)longitude latitude:(double)latitude {
    NSString *coordinateString = [NSString stringWithFormat: @"%f,%f", latitude, longitude];
    [NNLogger logFromInstance: self message: @"Navigating to coordinates" data: coordinateString];
    NSString *mapsURL = [NSString stringWithFormat: @"waze://?ll=%@&navigate=yes", coordinateString];
    if(![self applicationURLOpenIfCan: mapsURL]) {
        mapsURL = [NSString stringWithFormat: @"http://maps.apple.com/?ll=%@", coordinateString];
        [self applicationURLOpenIfCan: mapsURL];
    }
}

+ (BOOL)applicationURLOpenIfCan:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString: urlString];
    return [[UIApplication sharedApplication] openURL: url];
}

+ (void)callNumber:(NSString *)number {
    NSString *phoneURL = [@"tel://" stringByAppendingString: number];
    if([self applicationURLOpenIfCan: phoneURL]) {
        [NNLogger logFromInstance: self message: @"Calling number" data: number];
    } else {
        [NNLogger logFromInstance: self message: @"Failed to call number" data: number];
    }
}

@end
