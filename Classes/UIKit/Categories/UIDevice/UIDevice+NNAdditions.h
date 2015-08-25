//
//  UIDevice+NNAdditions.h
//  NNLibraries
//
//  Created by Natan Abramov on 19/07/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (NNAdditions)
+ (BOOL)isDeviceSimulator;
+ (BOOL)iPhone4Screen;
+ (BOOL)iPhone5Screen;
+ (BOOL)iPhone6Screen;
+ (BOOL)iPhone6PlusScreen;
+ (BOOL)isBigDevice __attribute__((deprecated("With the new iPhones introduced, this is irrelevant")));
+ (CGFloat)deviceHeight;
+ (CGFloat)deviceWidth;
+ (NSString *)UDID DEPRECATED_MSG_ATTRIBUTE("Use 'vendorUdid' instead");
+ (NSString *)vendorUdid;
+ (NSString *)udidFromKeychain:(BOOL *)fromKeychain;
@end
