//
//  NSData+Security.h
//  NNLibraries
//
//  Created by Natan Abramov on 3/23/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonCryptor.h>

@interface NSMutableData (Security)
- (BOOL)doCipher:(NSString *)key operation:(CCOperation)operation;
@end

@interface NSData (Security)
- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSString*)hexStringFromData:(NSData *)data;
- (NSData *)dataFromHexString:(NSString *)string;
@end