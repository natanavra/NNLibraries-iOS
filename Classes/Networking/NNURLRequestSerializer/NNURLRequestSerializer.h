//
//  NNURLRequestSerializer.h
//  NNLibraries
//
//  Created by Natan Abramov on 18/08/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NNRequestConstants.h"

@interface NNHTTPRequestSerializer : NSObject

+ (instancetype)serializer;

- (NSURLRequest *)requestWithURL:(NSURL *)url withMethod:(NNHTTPMethod)method withParameters:(NSDictionary *)params withHeaders:(NSDictionary *)headers;

@end
