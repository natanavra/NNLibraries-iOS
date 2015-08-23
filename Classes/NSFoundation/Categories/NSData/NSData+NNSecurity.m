//
//  NSData+Security.m
//  NNLibraries
//
//  Created by Natan Abramov on 3/23/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NSData+NNSecurity.h"

#import <CommonCrypto/CommonCrypto.h>

@implementation NSMutableData (NNSecurity)

#define kChunkSizeBytes (1024 * 1024) // 1 MB

/**
 * Performs a cipher on an in-place buffer
 */
- (BOOL)doCipher:(NSString *)key operation:(CCOperation)operation {
    // The key should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr));     // fill with zeroes (for padding)
    
    // Fetch key data
    if (![key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding]) {
        return FALSE;
    } // Length of 'key' is bigger than keyPtr
    
    CCCryptorRef cryptor;
    CCCryptorStatus cryptStatus = CCCryptorCreate(operation,
                                                  kCCAlgorithmAES128,
                                                  kCCOptionPKCS7Padding,
                                                  keyPtr,
                                                  kCCKeySizeAES256,
                                                  NULL, // IV - needed?
                                                  &cryptor);
    
    if (cryptStatus != kCCSuccess) { // Handle error here
        return FALSE;
    }
    
    size_t dataOutMoved;
    size_t dataInLength = kChunkSizeBytes; // #define kChunkSizeBytes (16)
    size_t dataOutLength = CCCryptorGetOutputLength(cryptor, dataInLength, FALSE);
    size_t totalLength = 0; // Keeps track of the total length of the output buffer
    size_t filePtr = 0;   // Maintains the file pointer for the output buffer
    NSInteger startByte; // Maintains the file pointer for the input buffer
    
    char *dataIn = malloc(dataInLength);
    char *dataOut = malloc(dataOutLength);
    for (startByte = 0; startByte <= [self length]; startByte += kChunkSizeBytes) {
        if ((startByte + kChunkSizeBytes) > [self length]) {
            dataInLength = [self length] - startByte;
        }
        else {
            dataInLength = kChunkSizeBytes;
        }
        
        // Get the chunk to be ciphered from the input buffer
        NSRange bytesRange = NSMakeRange((NSUInteger) startByte, (NSUInteger) dataInLength);
        [self getBytes:dataIn range:bytesRange];
        cryptStatus = CCCryptorUpdate(cryptor, dataIn, dataInLength, dataOut, dataOutLength, &dataOutMoved);
        
        if (dataOutMoved != dataOutLength) {
            //NSLog(@"dataOutMoved (%zd) != dataOutLength (%zd)", dataOutMoved, dataOutLength);
        }
        
        if ( cryptStatus != kCCSuccess)
        {
            NSLog(@"Failed CCCryptorUpdate: %d", cryptStatus);
        }
        
        // Write the ciphered buffer into the output buffer
        bytesRange = NSMakeRange(filePtr, (NSUInteger) dataOutMoved);
        [self replaceBytesInRange:bytesRange withBytes:dataOut];
        totalLength += dataOutMoved;
        
        filePtr += dataOutMoved;
    }
    
    // Finalize encryption/decryption.
    cryptStatus = CCCryptorFinal(cryptor, dataOut, dataOutLength, &dataOutMoved);
    totalLength += dataOutMoved;
    
    if ( cryptStatus != kCCSuccess)
    {
        NSLog(@"Failed CCCryptorFinal: %d", cryptStatus);
    }
    
    // In the case of encryption, expand the buffer if it required some padding (an encrypted buffer will always be a multiple of 16).
    // In the case of decryption, truncate our buffer in case the encrypted buffer contained some padding
    [self setLength:totalLength];
    
    // Finalize the buffer with data from the CCCryptorFinal call
    NSRange bytesRange = NSMakeRange(filePtr, (NSUInteger) dataOutMoved);
    [self replaceBytesInRange:bytesRange withBytes:dataOut];
    
    CCCryptorRelease(cryptor);
    
    free(dataIn);
    free(dataOut);
    
    return 1;
}

- (BOOL)encryptWithKey:(NSString *)key {
    return [self doCipher:key operation:kCCEncrypt];
}

- (BOOL)decryptWithKey:(NSString *)key {
    return [self doCipher:key operation:kCCDecrypt];
}
@end

@implementation NSData (Security)

- (NSData *)AES256EncryptWithKey:(NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

+ (NSData *)dataFromHexString:(NSString *)string
{
    NSMutableData *stringData = [NSMutableData data];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [string length] / 2; i++) {
        byte_chars[0] = [string characterAtIndex:i*2];
        byte_chars[1] = [string characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    return stringData;
}

- (NSString*)hexStringFromData:(NSData *)data
{
    unichar* hexChars = (unichar*)malloc(sizeof(unichar) * (data.length*2));
    unsigned char* bytes = (unsigned char*)data.bytes;
    for (NSUInteger i = 0; i < data.length; i++) {
        unichar c = bytes[i] / 16;
        if (c < 10) c += '0';
        else c += 'a' - 10;
        hexChars[i*2] = c;
        c = bytes[i] % 16;
        if (c < 10) c += '0';
        else c += 'a' - 10;
        hexChars[i*2+1] = c;
    }
    NSString* retVal = [[NSString alloc] initWithCharactersNoCopy:hexChars
                                                           length:data.length*2
                                                     freeWhenDone:YES];
    return retVal;
}

@end
