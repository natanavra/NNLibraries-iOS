//
//  NNAsyncRequest.m
//  FourSigns
//
//  Created by Natan Abramov on 9/4/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "NNAsyncRequest.h"
#import "NNLogger.h"

@implementation NNAsyncRequest

#pragma mark - init

- (instancetype)initWithRequest:(NSURLRequest *)request {
    return [self initWithRequest: request complete: nil];
}

- (instancetype)initWithRequest:(NSURLRequest *)request complete:(NNAsyncCompleteBlock)block {
    return [self initWithMutableRequest: [request mutableCopy] complete: block];
}

- (instancetype)initWithURL:(NSURL *)url complete:(NNAsyncCompleteBlock)block {
    return [self initWithMutableRequest: [NSMutableURLRequest requestWithURL: url] complete: block];
}

- (instancetype)initWithMutableRequest:(NSMutableURLRequest *)request complete:(NNAsyncCompleteBlock)block {
    if(self = [super init]) {
        _request = request;
        _callback = block;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"<%p> NNAsyncRequest URL: %@ \nMethod: %@ \nHeaders: %@ \nHTTPBody: %@", self, _request.URL.absoluteString, _request.HTTPMethod,_request.allHTTPHeaderFields, [[NSString alloc] initWithData: _request.HTTPBody encoding: NSUTF8StringEncoding]];
}

#pragma mark - HTTP Setters

- (void)setHTTPHeaders:(NSDictionary *)headers {
    for(NSString *key in [headers allKeys]) {
        [_request setValue: headers[key] forHTTPHeaderField: key];
    }
}

- (void)setHTTPMethod:(NSString *)method {
    if(![method caseInsensitiveCompare: @"POST"] && ![method caseInsensitiveCompare: @"GET"]) {
        //If not 'GET' or 'POST', do nothing.
        return;
    } else {
        [_request setHTTPMethod: method];
    }
}

- (void)setHTTPBody:(NSString *)postString {
    if(postString) {
        [_request setHTTPBody: [[postString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding] dataUsingEncoding: NSUTF8StringEncoding]];
    }
}

- (void)setHTTPBodyData:(NSData *)postData {
    if(postData) {
        [_request setHTTPBody: postData];
    }
}

#pragma mark - Instance Methods

- (void)startAsyncConnection {
    _connection = [[NSURLConnection alloc] initWithRequest: _request delegate: self startImmediately: NO];
    [_connection start];
}

- (NSString *)responseString {
    return [self responseStringWithEncoding: NSUTF8StringEncoding];
}

- (NSString *)responseStringWithEncoding:(NSStringEncoding)encoding {
    if(_responseData) {
        return [[NSString alloc] initWithData: _responseData encoding: encoding];
    }
    return @"";
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //[NNLogger logFromInstance: self message: [NSString stringWithFormat: @"Received response: %@", response]];
    if([response isKindOfClass: [NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        _statusCode = httpResponse.statusCode;
    }
    
    _response = [response copy];
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData: data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //[NNLogger logFromInstance: self message: [NSString stringWithFormat: @"Connection successful: %@", [self responseString]]];
    dispatch_async(dispatch_get_main_queue(), ^{
        _callback(_response, _responseData, nil);
    });
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //[NNLogger logFromInstance: self message: [NSString stringWithFormat: @"Connection Failed: %@", error]];
    dispatch_async(dispatch_get_main_queue(), ^{
        _callback(_response, nil, error);
    });
}

#pragma mark - dealloc

- (void)dealloc {
    _response = nil;
    _responseData = nil;
    _request = nil;
    _connection = nil;
    _callback = nil;
}

@end
