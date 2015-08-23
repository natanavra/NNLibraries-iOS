//
//  NSData+NNAdditions.h
//  NNLibraries
//
//  Created by Natan Abramov on 4/5/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (NNAdditions)
+ (NSData *)nnDataFromHexString:(NSString *)string;

- (NSString *)nnHexString;
- (NSString *)nnStringWithEncoding:(NSStringEncoding)encoding;
@end
