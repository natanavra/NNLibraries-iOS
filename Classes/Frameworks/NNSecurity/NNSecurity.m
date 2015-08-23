//
//  NNSecurity.m
//  NNLibraries
//
//  Created by Natan Abramov on 3/16/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNSecurity.h"
#import "NNLogger.h"
#import "NSData+NNSecurity.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NNSecurity

NSString *const kEncryptionKey = @"natan";

+ (NSData *)encrypt:(NSString *)message error:(NSError **)err {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    return [self encrypt: message withKey: kEncryptionKey error: err];
}

+ (NSData *)encrypt:(NSString *)message withKey:(NSString *)key error:(NSError **)err {
    NSData *data = [message dataUsingEncoding: NSUTF8StringEncoding];
    return [self encryptData: data withKey: key error: err];
}

+ (NSData *)encryptData:(NSData *)data withKey:(NSString *)key error:(NSError **)err {
    if(!data || !key) {
        return nil;
    }
    
    NSMutableData *mutableData = [NSMutableData dataWithData: data];
    BOOL success = [mutableData encryptWithKey: key];
    if(success) {
        return mutableData;
    } else {
#warning TODO: generate error.
        return nil;
    }
}

+ (NSData *)decrypt:(NSData *)ciphered error:(NSError **)err{
    return [self decrypt: ciphered withKey: kEncryptionKey error: err];
}

+ (NSData *)decrypt:(NSData *)ciphered withKey:(NSString *)key error:(NSError **)err {
    NSMutableData *data = [NSMutableData dataWithData: ciphered];
    BOOL success = [data decryptWithKey: key];
    //[NNLogger logFromInstance: self message: success ? @"deciphered" : @"failed deciphering" data: data];
    
    if(success) {
        return data;
    } else {
#warning TODO: generate error.
        return nil;
    }
}


@end
