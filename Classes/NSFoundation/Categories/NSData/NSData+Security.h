//
//  NSData+Security.h
//  NNLibraries
//
//  Created by Natan Abramov on 3/23/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef uint32_t CCOperation;

@interface NSMutableData (Security)
- (BOOL)doCipher:(NSString *)key operation:(CCOperation)operation;
- (BOOL)encryptWithKey:(NSString *)key;
- (BOOL)decryptWithKey:(NSString *)key;
@end

@interface NSData (Security)
- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSString*)hexStringFromData:(NSData *)data;
+ (NSData *)dataFromHexString:(NSString *)string;
@end