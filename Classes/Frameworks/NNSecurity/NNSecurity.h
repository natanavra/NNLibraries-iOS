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

+ (NSData *)encryptedDataFromData:(NSData *)data;
+ (NSData *)encryptedDataForData:(NSData *)data
                        password:(NSString *)password
                              iv:(NSData **)iv
                            salt:(NSData **)salt
                           error:(NSError **)error;

@end
