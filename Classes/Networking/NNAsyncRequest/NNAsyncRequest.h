//
//  NNAsyncRequest.h
//  FourSigns
//
//  Created by Natan Abramov on 9/4/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NNHTTPMethod) {
    NNHTTPMethodGET = 0,
    NNHTTPMethodPOST = 1,
};

typedef NS_ENUM(NSInteger, NNHTTPErrorCode) {
    NNHTTPErrorBadRequest = 400,
    NNHTTPErrorNotAuthorized = 401,
    NNHTTPErrorForbidden = 403,
    NNHTTPErrorNotFound = 404,
};

extern NSInteger NNOfflineError;

/* The completion block is called on the main thread. */
typedef void(^NNAsyncCompleteBlock)(NSURLResponse *response, NSData *responseData, NSError *error);
typedef void(^NNAsyncOldCompleteBlock)(NSData *responseData, NSError *error);

static NSString *const httpMethodPOST   = @"POST";
static NSString *const httpMethodGET    = @"GET";

/** Simple asynchronous request */
@interface NNAsyncRequest : NSObject <NSURLConnectionDataDelegate> {
    NSMutableURLRequest *_request;
    NSHTTPURLResponse *_response;
    NSURLConnection *_connection;
    NSMutableData *_responseData;
    
    NNAsyncCompleteBlock _callback;
}
@property (nonatomic, readonly) NSInteger statusCode;

- (instancetype)initWithRequest:(NSURLRequest *)request;
- (instancetype)initWithRequest:(NSURLRequest *)request complete:(NNAsyncCompleteBlock)block;
- (instancetype)initWithURL:(NSURL *)url complete:(NNAsyncCompleteBlock)block;
- (instancetype)initWithURL:(NSString *)url withParams:(NSDictionary *)params
                withHeaders:(NSDictionary *)headers withHTTPMethod:(NNHTTPMethod)method completionBlock:(NNAsyncCompleteBlock)block;

/** Key/Value http headers. Read as is. */
- (void)setHTTPHeaders:(NSDictionary *)headers;
/** Accepts only GET and POST for now. */
- (void)setHTTPMethod:(NSString *)method;
/** This string needs to be formatted like so: 'param1=value1&param2=value2' other formats will return an error. */
- (void)setHTTPBody:(NSString *)postString;
/** Any data you see fit as the HTTP Post data. */
- (void)setHTTPBodyData:(NSData *)postData;

- (void)startAsyncConnection;

- (NSString *)responseString;
- (NSString *)responseStringWithEncoding:(NSStringEncoding)encoding;
@end
