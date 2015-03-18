//
//  NNSecurity.m
//  NNLibraries
//
//  Created by Natan Abramov on 3/16/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNSecurity.h"
#import "NNLogger.h"

@import Security;
#import <CommonCrypto/CommonCrypto.h>

@implementation NNSecurity

NSString *const kEncryptionKey = @"mQENBFUGdGcBCADC2zkjLNz3DBvQZzGxU/y1c2aDdWz/0YLYrgJIqOg78V5GKyit\nR7W14oo5D2yxc97AQBDhqYcB3fTMMHxwHOGQiLL7gW9z/8yWbVjSzrM7Qk3XhOFm\nn/iluxAzprCq2jZySNJ95Uya7cyS6oCmf0PpPpYhoZIhhQgp0wD0nXXsZ/p5rHOH\ncdGpZXuv5DdRW1D3zq0OZZloLmgzk9+Y4q0SL1psy3fYB4prhWgeWvrVmoAacbsx\n2SFJcwPqrvS5S2DaXeE8KuTKaHW1k9sDTKP3VxzcPmBCoHg0r6/HtV9NT9lehUsY\nM0puA263TOSuVP2hP5AROFQ8UT6LvEJ+cSqhABEBAAG0AIkBHAQQAQIABgUCVQZ0\nZwAKCRDmcJWf0GnGal49CACG6tqjKKe3VImGcxR/3BLyOa3cDd2XljzuRGE8+N3i\nFChWQHH2dWP4eeluBnVsqcTADrKaL9kmjX9Vp7dyTk8yoVULra6A84iwvfnHJAQC\nJMDfjJw4iJTL3KOA7Ovv3Jgxw+q2/MnEBAY1VW9yB25pmuXujKaEiyEGAMDDWMp1\ndPP/4zxpWcPH8PmN72tHVBCuPr9c8bKO5dNp2ednV2tBuPhDYz8jMaWK5KOI9m1B\nCBnhkweAusvpvA+heZ9tQl/Rc86gnA8IdrPQeHzQLXWmf+GwHVR+ajZJMB1RVMWK\nREQm3yiG1J9IeFNtsalKA4+K0V51Xgbd781Xxbd/UQay\n=LWFP";

+ (NSData *)encryptedDataFromData:(NSData *)data {
    NSData *key = [kEncryptionKey dataUsingEncoding: NSUTF8StringEncoding];
    size_t outLength;
    NSMutableData *cipherData = [NSMutableData dataWithLength: data.length + kCCBlockSizeAES128];
    CCCryptorStatus status = CCCrypt(kCCEncrypt,
                                     kCCAlgorithmAES,
                                     kCCOptionPKCS7Padding,
                                     key.bytes,
                                     key.length,
                                     NULL,
                                     data.bytes,
                                     data.length,
                                     cipherData.mutableBytes,
                                     cipherData.length,
                                     &outLength);
    if(status == kCCSuccess) {
        [NNLogger logFromInstance: self message: @"Encrypted data" data: cipherData];
    } else {
        [NNLogger logFromInstance: self message: @"Failed encryption" data: @(status)];
    }
    return cipherData;
}

const CCAlgorithm kAlgorithm = kCCAlgorithmAES128;
const NSUInteger kAlgorithmKeySize = kCCKeySizeAES128;
const NSUInteger kAlgorithmBlockSize = kCCBlockSizeAES128;
const NSUInteger kAlgorithmIVSize = kCCBlockSizeAES128;
const NSUInteger kPBKDFSaltSize = 8;
const NSUInteger kPBKDFRounds = 10000;  // ~80ms on an iPhone 4

// ===================

+ (NSData *)encryptedDataForData:(NSData *)data
                        password:(NSString *)password
                              iv:(NSData **)iv
                            salt:(NSData **)salt
                           error:(NSError **)error {
    NSAssert(iv, @"IV must not be NULL");
    NSAssert(salt, @"salt must not be NULL");
    
    *iv = [self randomDataOfLength:kAlgorithmIVSize];
    *salt = [self randomDataOfLength:kPBKDFSaltSize];
    
    NSData *key = [self AESKeyForPassword: kEncryptionKey salt: *salt];
    
    size_t outLength;
    NSMutableData *
    cipherData = [NSMutableData dataWithLength:data.length +
                  kAlgorithmBlockSize];
    
    CCCryptorStatus
    result = CCCrypt(kCCEncrypt, // operation
                     kAlgorithm, // Algorithm
                     kCCOptionPKCS7Padding, // options
                     key.bytes, // key
                     key.length, // keylength
                     (*iv).bytes,// iv
                     data.bytes, // dataIn
                     data.length, // dataInLength,
                     cipherData.mutableBytes, // dataOut
                     cipherData.length, // dataOutAvailable
                     &outLength); // dataOutMoved
    
    if (result == kCCSuccess) {
        cipherData.length = outLength;
    }
    else {
        if (error) {
            
        }
        return nil;
    }
    
    return cipherData;
}

// ===================

+ (NSData *)randomDataOfLength:(size_t)length {
    NSMutableData *data = [NSMutableData dataWithLength:length];
    
    int result = SecRandomCopyBytes(kSecRandomDefault,
                                    length,
                                    data.mutableBytes);
    NSAssert(result == 0, @"Unable to generate random bytes: %d",
             errno);
    
    return data;
}

// ===================

// Replace this with a 10,000 hash calls if you don't have CCKeyDerivationPBKDF
+ (NSData *)AESKeyForPassword:(NSString *)password
                         salt:(NSData *)salt {
    NSMutableData *
    derivedKey = [NSMutableData dataWithLength:kAlgorithmKeySize];
    
    int
    result = CCKeyDerivationPBKDF(kCCPBKDF2,            // algorithm
                                  password.UTF8String,  // password
                                  [password lengthOfBytesUsingEncoding:NSUTF8StringEncoding],  // passwordLength
                                  salt.bytes,           // salt
                                  salt.length,          // saltLen
                                  kCCPRFHmacAlgSHA1,    // PRF
                                  kPBKDFRounds,         // rounds
                                  derivedKey.mutableBytes, // derivedKey
                                  derivedKey.length); // derivedKeyLen
    
    // Do not log password here
    NSAssert(result == kCCSuccess,
             @"Unable to create AES key for password: %d", result);
    
    return derivedKey;
}

@end
