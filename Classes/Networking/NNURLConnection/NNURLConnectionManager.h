//
//  NNURLConnectionManager.h
//  NNLibraries
//
//  Created by Natan Abramov on 17/08/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NNURLConstants.h"
#import "NNURLRequestSerializer.h"
#import "NNURLResponseSerializer.h"


@interface NNURLConnectionManager : NSObject
@property (nonatomic, readonly) NSMutableArray *connections;

@property (nonatomic, strong) NNHTTPRequestSerializer *requestSerializer;
@property (nonatomic, strong) NNHTTPResponseSerializer *responseSerializer;
@property (nonatomic, strong) NSURLSessionConfiguration *configuration;

+ (instancetype)sharedManager;

- (void)GET:(NSURL *)url headers:(NSDictionary *)headers parameters:(NSDictionary *)params completion:(NNURLConnectionCompletion)completion;
- (void)POST:(NSURL *)url headers:(NSDictionary *)headers parameters:(NSDictionary *)params completion:(NNURLConnectionCompletion)completion;
- (void)POST:(NSURL *)url headers:(NSDictionary *)headers parameters:(NSDictionary *)params processBlock:(NNURLRequestProcess)process completion:(NNURLConnectionCompletion)completion;

@end
