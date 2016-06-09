//
//  NNSecurity.h
//  NNLibraries
//
//  Created by Natan Abramov on 3/16/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kEncryptionKey;

@interface NNSecurity : NSObject

+ (NSData *)encrypt:(NSString *)message error:(NSError **)err;
+ (NSData *)encrypt:(NSString *)message withKey:(NSString *)key error:(NSError **)err;

+ (NSData *)encryptData:(NSData *)data withKey:(NSString *)key error:(NSError **)err;

+ (NSData *)decrypt:(NSData *)ciphered error:(NSError **)err;
+ (NSData *)decrypt:(NSData *)ciphered withKey:(NSString *)key error:(NSError **)err;

+ (NSData *)hmacSha256HashString:(NSString *)data withKey:(NSString *)key;

@end
