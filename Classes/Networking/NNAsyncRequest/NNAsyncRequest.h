//
//  NNAsyncRequest.h
//  FourSigns
//
//  Created by Natan Abramov on 9/4/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNURLConstants.h"

/** Simple asynchronous request */
@interface NNAsyncRequest : NSObject <NSURLConnectionDataDelegate> {
    
}
@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic) NNHTTPMethod httpMethod;
@property (nonatomic, copy) NNURLConnectionCompletion completionBlock;

@property (nonatomic, readonly) NSInteger statusCode;
@property (nonatomic, readonly) NSHTTPURLResponse *response;
@property (nonatomic, readonly) NSData *data;


- (instancetype)initWithRequest:(NSURLRequest *)request;
- (instancetype)initWithRequest:(NSURLRequest *)request complete:(NNURLConnectionCompletion)block;
- (instancetype)initWithURL:(NSURL *)url complete:(NNURLConnectionCompletion)block;
- (instancetype)initWithURL:(NSURL *)url
                 withParams:(NSDictionary *)params
                withHeaders:(NSDictionary *)headers
             withHTTPMethod:(NNHTTPMethod)method
            completionBlock:(NNURLConnectionCompletion)block;


- (void)start;
- (void)cancel;

@end
