//
//  NNAsyncRequest.h
//  FourSigns
//
//  Created by Natan Abramov on 9/4/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NNAsyncCompleteBlock)(NSData *responseData, NSError *error);


/** Simple asynchronous request */
@interface NNAsyncRequest : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSMutableURLRequest *_request;
    NSURLConnection *_connection;
    NSMutableData *_responseData;
    
    NNAsyncCompleteBlock _callback;
}

- (instancetype)initWithRequest:(NSURLRequest *)request;
- (instancetype)initWithRequest:(NSURLRequest *)request complete:(NNAsyncCompleteBlock)block;
- (instancetype)initWithURL:(NSURL *)url complete:(NNAsyncCompleteBlock)block;

/** Key/Value http headers. Read as is. */
- (void)setHTTPHeaders:(NSDictionary *)headers;
/** Accepts only GET and POST for now. */
- (void)setHTTPMethod:(NSString *)method;
/** This string needs to be formatted like so: 'param1=value1&param2=value2' other formats will return an error. */
- (void)setHTTPBody:(NSString *)postString;

- (void)startAsyncConnection;

- (NSString *)responseString;
- (NSString *)responseStringWithEncoding:(NSStringEncoding)encoding;
@end
