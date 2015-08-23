//
//  NNResponseSerializer.h
//  NNLibraries
//
//  Created by Natan Abramov on 18/08/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNHTTPResponseSerializer : NSObject

+ (instancetype)serializer;

- (id)responseObjectForResponse:(NSHTTPURLResponse *)response withData:(NSData *)data error:(NSError **)error;

@end

@interface NNJSONResponseSerializer : NNHTTPResponseSerializer

@end