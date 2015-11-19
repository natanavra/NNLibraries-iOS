//
//  UIDevice+NNAdditions.m
//  NNLibraries
//
//  Created by Natan Abramov on 19/07/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "UIDevice+NNAdditions.h"
#import "NNUICKeyChainStore.h"
#import <sys/utsname.h>

static NSString *const kKeychainKey_Udid = @"nnlib_device_udid";

@implementation UIDevice (NNAdditions)

+ (BOOL)isDeviceSimulator {
#if TARGET_IPHONE_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

+ (BOOL)iPhone4Screen {
    return [self deviceHeight] == 480;
}

+ (BOOL)iPhone5Screen {
    return [self deviceHeight] == 568;
}

+ (BOOL)iPhone6Screen {
    return [self deviceHeight] == 667;
}

+ (BOOL)iPhone6PlusScreen {
    return [self deviceHeight] == 736;
}

+ (BOOL)isBigDevice {
    return [[UIScreen mainScreen] bounds].size.height > 480;
}

+ (CGFloat)deviceWidth {
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)deviceHeight {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (NSString *)UDID {
    return [self vendorUdid];
}

+ (NSString *)vendorUdid {
    NSUUID *udid = [[UIDevice currentDevice] identifierForVendor];
    return [udid UUIDString];
}

+ (NSString *)udidFromKeychain:(BOOL *)fromKeychain {
    NSString *udid = [NNUICKeyChainStore stringForKey: kKeychainKey_Udid];
    if(!udid) {
        udid = [self vendorUdid];
        [NNUICKeyChainStore setString: udid forKey: kKeychainKey_Udid];
        if(fromKeychain) {
            *fromKeychain = NO;
        }
    } else if(fromKeychain) {
        *fromKeychain = YES;
    }
    return udid;
}

#pragma mark - Device Descript Model

+ (NSString *)machineModel {
    NSString *modelString = @"Unknown Device";
    // Simulator
    if (TARGET_IPHONE_SIMULATOR) {
        BOOL iPadScreen = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        modelString = iPadScreen ? @"iPad Simulator": @"iPhone Simulator";
    }
    // Actual device
    else {
        NSString *systemInfoString = [self _rawSystemInfoString];
        
        
        NSArray *deviceFamilies = @[@"iPhone", @"iPad", @"iPod"];
        
        NSDictionary *modelManifest = @{
                                        @"iPhone": @{
                                                // 1st Gen
                                                @[@(1), @(1)]: @"iPhone 1",
                                                
                                                // 3G
                                                @[@(1), @(2)]: @"iPhone 3G",
                                                
                                                // 3GS
                                                @[@(2), @(1)]: @"iPhone 3GS",
                                                
                                                // 4
                                                @[@(3), @(1)]: @"iPhone 4",
                                                @[@(3), @(2)]: @"iPhone 4",
                                                @[@(3), @(3)]: @"iPhone 4",
                                                
                                                // 4S
                                                @[@(4), @(1)]: @"iPhone 4S",
                                                
                                                // 5
                                                @[@(5), @(1)]: @"iPhone 5",
                                                @[@(5), @(2)]: @"iPhone 5",
                                                
                                                // 5C
                                                @[@(5), @(3)]: @"iPhone 5C",
                                                @[@(5), @(4)]: @"iPhone 5C",
                                                
                                                // 5S
                                                @[@(6), @(1)]: @"iPhone 5S",
                                                @[@(6), @(2)]: @"iPhone 5S",
                                                
                                                // 6 Plus
                                                @[@(7), @(1)]: @"iPhone 6 Plus",
                                                
                                                // 6
                                                @[@(7), @(2)]: @"iPhone 6",
                                                
                                                // 6S
                                                @[@(8), @(1)]: @"iPhone 6S",
                                                
                                                // 6S Plus
                                                @[@(8), @(2)]: @"iPhone 6S Plus",
                                                },
                                        @"iPad": @{
                                                // 1
                                                @[@(1), @(1)]: @"iPad 1",
                                                
                                                // 2
                                                @[@(2), @(1)]: @"iPad 2",
                                                @[@(2), @(2)]: @"iPad 2",
                                                @[@(2), @(3)]: @"iPad 2",
                                                @[@(2), @(4)]: @"iPad 2",
                                                
                                                // Mini
                                                @[@(2), @(5)]: @"iPad Mini 1",
                                                @[@(2), @(6)]: @"iPad Mini 1",
                                                @[@(2), @(7)]: @"iPad Mini 1",
                                                
                                                // 3
                                                @[@(3), @(1)]: @"iPad 3",
                                                @[@(3), @(2)]: @"iPad 3",
                                                @[@(3), @(3)]: @"iPad 3",
                                                
                                                // 4
                                                @[@(3), @(4)]: @"iPad 4",
                                                @[@(3), @(5)]: @"iPad 4",
                                                @[@(3), @(6)]: @"iPad 4",
                                                
                                                // Air
                                                @[@(4), @(1)]: @"iPad Air 1",
                                                @[@(4), @(2)]: @"iPad Air 1",
                                                @[@(4), @(3)]: @"iPad Air 1",
                                                
                                                // Mini 2
                                                @[@(4), @(4)]: @"iPad Mini 2",
                                                @[@(4), @(5)]: @"iPad Mini 2",
                                                @[@(4), @(6)]: @"iPad Mini 2",
                                                
                                                // Mini 3
                                                @[@(4), @(7)]: @"iPad Mini 3",
                                                @[@(4), @(8)]: @"iPad Mini 3",
                                                @[@(4), @(9)]: @"iPad Mini 3",
                                                
                                                // Air 2
                                                @[@(5), @(3)]: @"iPad Air 2",
                                                @[@(5), @(4)]: @"iPad Air 2",
                                                
                                                // Pro
                                                @[@(6), @(8)]: @"iPad Pro",
                                                },
                                        @"iPod": @{
                                                // 1st Gen
                                                @[@(1), @(1)]: @"iPod Touch 1",
                                                
                                                // 2nd Gen
                                                @[@(2), @(1)]: @"iPod Touch 2",
                                                
                                                // 3rd Gen
                                                @[@(3), @(1)]: @"iPod Touch 3",
                                                
                                                // 4th Gen
                                                @[@(4), @(1)]: @"iPod Touch 4",
                                                
                                                // 5th Gen
                                                @[@(5), @(1)]: @"iPod Touch 5",
                                                },
                                        };
        
        for (NSString *familyString in deviceFamilies) {
            if ([systemInfoString hasPrefix:familyString]) {
                modelString = modelManifest[familyString][[self deviceVersion]];
                break;
            }
        }
    }
    
    return modelString;
}

+ (NSString *)_rawSystemInfoString {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSArray *)deviceVersion {
    NSString *systemInfoString = [self _rawSystemInfoString];
    
    NSUInteger positionOfFirstInteger = [systemInfoString rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location;
    NSUInteger positionOfComma = [systemInfoString rangeOfString:@","].location;
    
    NSUInteger major = 0;
    NSUInteger minor = 0;
    
    if (positionOfComma != NSNotFound) {
        major = [[systemInfoString substringWithRange:NSMakeRange(positionOfFirstInteger, positionOfComma - positionOfFirstInteger)] integerValue];
        minor = [[systemInfoString substringFromIndex:positionOfComma + 1] integerValue];
    }
    
    return @[@(major), @(minor)];
}

@end
