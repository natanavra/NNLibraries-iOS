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
    NSURLRequest *_request;
    NSURLConnection *_connection;
    NSMutableData *_responseData;
    
    NNAsyncCompleteBlock _callback;
}

- (instancetype)initWithRequest:(NSURLRequest *)request;
- (instancetype)initWithRequest:(NSURLRequest *)request complete:(NNAsyncCompleteBlock)block;
- (instancetype)initWithURL:(NSURL *)url complete:(NNAsyncCompleteBlock)block;

- (void)startAsyncConnection;

- (NSString *)responseString;
- (NSString *)responseStringWithEncoding:(NSStringEncoding)encoding;
@end
