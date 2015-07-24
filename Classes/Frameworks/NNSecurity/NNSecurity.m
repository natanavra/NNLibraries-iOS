//
//  NNSecurity.m
//  NNLibraries
//
//  Created by Natan Abramov on 3/16/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNSecurity.h"
#import "NNLogger.h"
#import "NSData+Security.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NNSecurity

NSString *const kEncryptionKey = @"natan";/*@"mQENBFUGdGcBCADC2zkjLNz3DBvQZzGxU/y1c2aDdWz/0YLYrgJIqOg78V5GKyit\nR7W14oo5D2yxc97AQBDhqYcB3fTMMHxwHOGQiLL7gW9z/8yWbVjSzrM7Qk3XhOFm\nn/iluxAzprCq2jZySNJ95Uya7cyS6oCmf0PpPpYhoZIhhQgp0wD0nXXsZ/p5rHOH\ncdGpZXuv5DdRW1D3zq0OZZloLmgzk9+Y4q0SL1psy3fYB4prhWgeWvrVmoAacbsx\n2SFJcwPqrvS5S2DaXeE8KuTKaHW1k9sDTKP3VxzcPmBCoHg0r6/HtV9NT9lehUsY\nM0puA263TOSuVP2hP5AROFQ8UT6LvEJ+cSqhABEBAAG0AIkBHAQQAQIABgUCVQZ0\nZwAKCRDmcJWf0GnGal49CACG6tqjKKe3VImGcxR/3BLyOa3cDd2XljzuRGE8+N3i\nFChWQHH2dWP4eeluBnVsqcTADrKaL9kmjX9Vp7dyTk8yoVULra6A84iwvfnHJAQC\nJMDfjJw4iJTL3KOA7Ovv3Jgxw+q2/MnEBAY1VW9yB25pmuXujKaEiyEGAMDDWMp1\ndPP/4zxpWcPH8PmN72tHVBCuPr9c8bKO5dNp2ednV2tBuPhDYz8jMaWK5KOI9m1B\nCBnhkweAusvpvA+heZ9tQl/Rc86gnA8IdrPQeHzQLXWmf+GwHVR+ajZJMB1RVMWK\nREQm3yiG1J9IeFNtsalKA4+K0V51Xgbd781Xxbd/UQay\n=LWFP";*/

+ (NSData *)encrypt:(NSString *)message error:(NSError **)err {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    return [self encrypt: message withKey: kEncryptionKey error: err];
}

+ (NSData *)encrypt:(NSString *)message withKey:(NSString *)key error:(NSError **)err {
    NSMutableData *data = [NSMutableData dataWithData: [message dataUsingEncoding: NSUTF8StringEncoding]];
    BOOL success = [data encryptWithKey: key];
    [NNLogger logFromInstance: self message: success ? @"ciphered" : @"failed ciphering" data: data];
    return data;
}

+ (NSData *)decrypt:(NSData *)ciphered error:(NSError **)err{
    return [self decrypt: ciphered withKey: kEncryptionKey error: err];
}

+ (NSData *)decrypt:(NSData *)ciphered withKey:(NSString *)key error:(NSError **)err {
    NSMutableData *data = [NSMutableData dataWithData: ciphered];
    BOOL success = [data decryptWithKey: key];
    [NNLogger logFromInstance: self message: success ? @"deciphered" : @"failed deciphering" data: data];
    return data;
}


@end
