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

NSInteger NNOfflineError = -1009;

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

- (instancetype)initWithURL:(NSString *)url withParams:(NSDictionary *)params
                withHeaders:(NSDictionary *)headers withHTTPMethod:(NNHTTPMethod)method completionBlock:(NNAsyncCompleteBlock)block {
    if(self = [super init]) {
        _request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]];
        if(method == NNHTTPMethodGET) {
            NSMutableString *query = [NSMutableString string];
            [params enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
                if(query.length == 0) {
                    [query appendString: @"?"];
                } else {
                    [query appendString: @"&"];
                }
                NSString *escapedKey = [[key description] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                NSString *escapedValue = [[obj description] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
                [query appendFormat: @"%@=%@", escapedKey, escapedValue];
            }];
            NSString *requestURL = [url stringByAppendingString: query];
            [_request setURL: [NSURL URLWithString: requestURL]];
        } else if(method == NNHTTPMethodPOST) {
            NSData *data = [NNJSONUtilities JSONDataFromObject: params prettyPrint: YES error: nil];
            _request.HTTPBody = data;
        }
        _request.HTTPMethod = [NNAsyncRequest httpMethodName: method];
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if([obj isKindOfClass: [NSString class]] && [key isKindOfClass: [NSString class]]) {
                [_request setValue: obj forHTTPHeaderField: key];
            }
        }];
        
        _callback = block;
        
        [NNLogger logFromInstance: self message: @"Request created" data: self];
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
        NSDictionary *headers = [_response allHeaderFields];
        if([headers[@"content-type"] rangeOfString: @"json"].location != NSNotFound) {
            id object = [NNJSONUtilities JSONObjectFromData: _responseData error: nil];
            if(object) {
                return [object description];
            }
        }
        return [[NSString alloc] initWithData: _responseData encoding: encoding];
    }
    return nil;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [NNLogger logFromInstance: self message: [NSString stringWithFormat: @"Received response: %@", response]];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        _callback(_response, _responseData, [self requestError]);
    });
    
    NSMutableString *string = [NSMutableString string];
    [string appendFormat: @"Connection: %@", connection];
    NSError *error = [self requestError];
    if(error) {
        [string appendFormat: @",\nError: %@", error];
    }
    NSString *data = [self responseString];
    if(data.length > 0) {
        [string appendFormat: @",\nData: %@", data];
    }
    
    [NNLogger logFromInstance: self message: @"Connection success" data: string];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        _callback(_response, nil, error);
    });
    [NNLogger logFromInstance: self message: @"Connection failed"
                         data: [NSString stringWithFormat: @"\nConnection: %@, Error: %@", connection, error]];
}

- (BOOL)badRequest {
    return (_statusCode < 200 || _statusCode >= 300);
}

- (NSError *)requestError {
    if([self badRequest]) {
        NSString *errorDomain = nil;
        
        switch(_statusCode) {
            case NNHTTPErrorNotFound:
                errorDomain = @"com.NNAsyncRequest.notFound";
                break;
            case NNHTTPErrorForbidden:
                errorDomain = @"com.NNAsyncRequest.forbidden";
                break;
            case NNHTTPErrorBadRequest:
                errorDomain = @"com.NNAsyncRequest.badRequest";
                break;
            case NNHTTPErrorNotAuthorized:
                errorDomain = @"com.NNAsyncRequest.notAuthorized";
                break;
            default:
                errorDomain = @"com.NNAsyncRequest.undefined";
                break;
        }
        if(errorDomain.length > 0) {
            return [NSError errorWithDomain: errorDomain code: _statusCode userInfo: nil];
        }
    }
    return nil;
}

#pragma mark - Helper Methods

+ (NSString *)httpMethodName:(NNHTTPMethod)method {
    NSString *retVal = @"GET";
    if(method == NNHTTPMethodPOST) {
        retVal = @"POST";
    }
    return retVal;
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
