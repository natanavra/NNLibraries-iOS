//
//  UIDevice+NNAdditions.m
//  NNLibraries
//
//  Created by Natan Abramov on 19/07/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "UIDevice+NNAdditions.h"
#import "NNUICKeyChainStore.h"

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

@end
