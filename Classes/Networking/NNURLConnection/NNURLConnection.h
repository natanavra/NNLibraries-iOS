//
//  NNURLConnection.h
//  NNLibraries
//
//  Created by Natan Abramov on 16/08/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNURLConstants.h"

#pragma mark - Header Definitions

@class NNHTTPRequestSerializer;
@class NNHTTPResponseSerializer;

@interface NNURLConnection : NSObject
@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic) NNHTTPMethod httpMethod;

@property (nonatomic, copy) NNURLConnectionCompletion completionBlock;

@property (nonatomic, strong, readonly) NSHTTPURLResponse *response;
@property (nonatomic, strong, readonly) NSData *data;


- (instancetype)initWithRequest:(NSURLRequest *)request withCompletion:(NNURLConnectionCompletion)completion;

- (instancetype)initWithURL:(NSURL *)url;
- (instancetype)initWithURL:(NSURL *)url withCompletion:(NNURLConnectionCompletion)completion;

- (instancetype)initWithURL:(NSURL *)url withMethod:(NNHTTPMethod)method withCompletion:(NNURLConnectionCompletion)completion;

- (instancetype)initWithURL:(NSURL *)url
             withParameters:(NSDictionary *)params
                 withMethod:(NNHTTPMethod)method
             withCompletion:(NNURLConnectionCompletion)completion;

- (instancetype)initWithURL:(NSURL *)url withHeaders:(NSDictionary *)headers
                 withParams:(NSDictionary *)params withMethod:(NNHTTPMethod)method
             withCompletion:(NNURLConnectionCompletion)completion;


- (void)start;
- (void)suspend;
- (void)resume;
- (void)cancel;

@end

@interface NNURLConnection (convinience)

+ (instancetype)connectionWithURL:(NSURL *)url;
+ (instancetype)connectionWithURL:(NSURL *)url withCompletion:(NNURLConnectionCompletion)completion;
+ (instancetype)connectionWithURL:(NSURL *)url withMethod:(NNHTTPMethod)method withCompletion:(NNURLConnectionCompletion)completion;

+ (instancetype)connectionWithURL:(NSURL *)url
                   withParameters:(NSDictionary *)params
                       withMethod:(NNHTTPMethod)method
                   withCompletion:(NNURLConnectionCompletion)completion;

+ (instancetype)connectionWithURL:(NSURL *)url
                      withHeaders:(NSDictionary *)headers
                   withParameters:(NSDictionary *)params
                       withMethod:(NNHTTPMethod)method
                   withCompletion:(NNURLConnectionCompletion)completion;

@end
