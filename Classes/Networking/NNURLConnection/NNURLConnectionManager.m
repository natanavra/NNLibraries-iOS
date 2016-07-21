//
//  NNURLConnectionManager.m
//  NNLibraries
//
//  Created by Natan Abramov on 17/08/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNURLConnectionManager.h"
#import "NNURLConnection.h"
#import "NNAsyncRequest.h"

#import "NNURLRequestSerializer.h"
#import "NNURLResponseSerializer.h"

@interface NNURLConnectionManager ()
@property (nonatomic, readwrite) NSMutableArray *connections;
@end

@implementation NNURLConnectionManager

#pragma mark - Singleton

+ (instancetype)sharedManager {
    static id _shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (instancetype)init {
    if(self = [super init]) {
        _requestSerializer = [NNHTTPRequestSerializer serializer];
        _responseSerializer = [NNHTTPResponseSerializer serializer];
        _connections = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Connection

- (void)startConnection:(NNURLConnection *)connection {
    if(connection) {
        __weak typeof(self) weakSelf = self;
        
        NNURLConnectionCompletion originCompletion = connection.completionBlock;
        NNURLConnectionCompletion completion = ^(NSHTTPURLResponse *response, NSData *data, NSError *error) {
            [weakSelf.connections removeObject: connection];
            if(originCompletion) {
                originCompletion(response, data, error);
            }
        };
        [connection setCompletionBlock: completion];
        [_connections addObject: connection];
        [connection start];
    }
}

- (void)GET:(NSURL *)url headers:(NSDictionary *)headers parameters:(NSDictionary *)params completion:(NNURLConnectionCompletion)completion {
    NSURLRequest *request = [_requestSerializer requestWithURL: url withMethod: NNHTTPMethodGET
                                                withParams: params withHeaders: headers];
    [self runRequest: request withCompletion: completion];
}

- (void)POST:(NSURL *)url headers:(NSDictionary *)headers parameters:(NSDictionary *)params completion:(NNURLConnectionCompletion)completion {
    NSURLRequest *request = [_requestSerializer requestWithURL: url withMethod: NNHTTPMethodPOST
                                                withParams: params withHeaders: headers];
    [self runRequest: request withCompletion: completion];
}

- (void)POST:(NSURL *)url headers:(NSDictionary *)headers parameters:(NSDictionary *)params processBlock:(NNURLRequestProcess)process completion:(NNURLConnectionCompletion)completion {
    NSMutableURLRequest *request = [_requestSerializer mutableRequestWithURL: url withMethod: NNHTTPMethodPOST withParams: params withHeaders: headers];
    
    BOOL valid = YES;
    if(process) {
         valid = process(request);
    }
    if(valid) {
        [self runRequest: request withCompletion: completion];
    }
}

- (void)runRequest:(NSURLRequest *)request withCompletion:(NNURLConnectionCompletion)originalCompletion {
    __weak typeof(self) weakSelf = self;
    id connection = nil;
    if([NSURLSession class]) {
        connection = [[NNURLConnection alloc] initWithRequest: request withCompletion: nil];
    } else {
        connection = [[NNAsyncRequest alloc] initWithRequest: request complete: nil];
    }
    [_connections addObject: connection];
    
    NNURLConnectionCompletion completion = ^(NSHTTPURLResponse *response, id responseObject, NSError *error) {
        NSError *retError = error;
        
        //Parse with response serializer if available
        if(response && responseObject && !error && weakSelf.responseSerializer) {
            responseObject = [weakSelf.responseSerializer responseObjectForResponse: response withData: responseObject error: &retError];
        }
        
        [weakSelf.connections removeObject: connection];
        if(originalCompletion) {
            originalCompletion(response, responseObject, retError);
        }
    };
    [connection setCompletionBlock: completion];
    [connection start];
}

@end
