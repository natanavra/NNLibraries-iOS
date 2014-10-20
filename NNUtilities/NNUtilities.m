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

+ (BOOL)validBooleanFromObject:(id)object {
    if([self validObjectFromObject: object]) {
        return [object boolValue];
    }
    return NO;
}

#pragma mark - JSON

+ (NSDictionary *)parseJsonFromData:(NSData *)data {
    NSError *err = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingAllowFragments error: &err];
    if(err) {
        //Maybe implement some kind of error handling?
        [NNLogger logFromInstance: self message: [NSString stringWithFormat: @"Unable to parse JSON! %@", err]];
        return [NSDictionary dictionary];
    } else {
        return json;
    }
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

#pragma mark - Device Utilities

+ (BOOL)isBigDevice {
    return [[UIScreen mainScreen] bounds].size.height > 480;
}

+ (CGFloat)deviceWidth {
    return [[UIScreen mainScreen] bounds].size.width;
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

@end
