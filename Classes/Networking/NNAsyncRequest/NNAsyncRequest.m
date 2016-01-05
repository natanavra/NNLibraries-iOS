//
//  NNAsyncRequest.m
//  FourSigns
//
//  Created by Natan Abramov on 9/4/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "NNAsyncRequest.h"
#import "NNUtilities.h"
#import "NNLogger.h"
#import "NNJSONUtilities.h"
#import "NNURLRequestSerializer.h"

@interface NNAsyncRequest ()
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *accumlatedData;
@end

@implementation NNAsyncRequest

#pragma mark - init

- (instancetype)initWithRequest:(NSURLRequest *)request {
    return [self initWithRequest: request complete: nil];
}

- (instancetype)initWithURL:(NSURL *)url complete:(NNURLConnectionCompletion)block {
    return [self initWithRequest: [NSURLRequest requestWithURL: url] complete: block];
}

- (instancetype)initWithURL:(NSURL *)url
                 withParams:(NSDictionary *)params
                withHeaders:(NSDictionary *)headers
             withHTTPMethod:(NNHTTPMethod)method
            completionBlock:(NNURLConnectionCompletion)block {
    if(self = [super init]) {
        NSURLRequest *request = [[NNHTTPRequestSerializer serializer] requestWithURL: url withMethod: method
                                                                      withParams: params withHeaders: headers];
        self = [self initWithRequest: request complete: block];
    }
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request complete:(NNURLConnectionCompletion)block {
    if(self = [super init]) {
        if(request) {
            self.request = request;
            self.completionBlock = block;
        } else {
            self = nil;
        }
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"<%p> NNAsyncRequest URL: %@ \nMethod: %@ \nHeaders: %@ \nHTTPBody: %@", self, _request.URL.absoluteString, _request.HTTPMethod,_request.allHTTPHeaderFields, [[NSString alloc] initWithData: _request.HTTPBody encoding: NSUTF8StringEncoding]];
}

#pragma mark - Instance Methods

- (void)start {
    _connection = [[NSURLConnection alloc] initWithRequest: self.request delegate: self startImmediately: NO];
    [_connection start];
}

- (void)cancel {
    [_connection cancel];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [NNLogger logFromInstance: self message: [NSString stringWithFormat: @"Received response: %@", response]];
    if([response isKindOfClass: [NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        _statusCode = httpResponse.statusCode;
    }
    _response = [response copy];
    _accumlatedData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_accumlatedData appendData: data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    dispatch_async(dispatch_get_main_queue(), ^{
        _completionBlock(_response, _data, [self requestError]);
    });
    _data = [_accumlatedData copy];
    _accumlatedData = nil;
    [NNLogger logFromInstance: self message: @"finished loading" data: _data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        _completionBlock(_response, nil, error);
    });
}

- (BOOL)badRequest {
    return (_statusCode < 200 || _statusCode >= 300);
}

- (NSError *)requestError {
    if([self badRequest]) {
        NSString *errorDomain = @"com.NNAsyncRequest.error";
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : [NSHTTPURLResponse localizedStringForStatusCode: _statusCode]};
        return [NSError errorWithDomain: errorDomain code: _statusCode userInfo: userInfo];
    }
    return nil;
}

#pragma mark - dealloc

- (void)dealloc {
    _response = nil;
    _data = nil;
    _request = nil;
    _connection = nil;
    _completionBlock = nil;
}

@end
