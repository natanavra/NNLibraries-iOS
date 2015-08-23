//
//  NSData+NNAdditions.m
//  NNLibraries
//
//  Created by Natan Abramov on 4/5/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NSData+NNAdditions.h"

@implementation NSData (NNAdditions)

+ (NSData *)nnDataFromHexString:(NSString *)string {
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

- (NSString *)nnHexString {
    NSString *desc = [self description];
    NSString *trim = [desc stringByTrimmingCharactersInSet: [self nnDescriptionCharacterSet]];
    return [trim stringByReplacingOccurrencesOfString: @" " withString: @""];
}

- (NSString *)nnStringWithEncoding:(NSStringEncoding)encoding {
    return [[NSString alloc] initWithData: self encoding: encoding];
}

#pragma mark - Helpers

- (NSCharacterSet *)nnDescriptionCharacterSet {
    static NSCharacterSet *charSet = nil;
    if(!charSet) {
        charSet = [NSCharacterSet characterSetWithCharactersInString: @"< >"];
    }
    return charSet;
}

@end
