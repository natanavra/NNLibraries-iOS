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

@property (nonatomic, strong) NSDictionary *httpHeaders;
@property (nonatomic, strong) NNHTTPRequestSerializer *requestSerializer;
@property (nonatomic, strong) NNHTTPResponseSerializer *responseSerializer;

+ (instancetype)sharedManager;

- (void)GET:(NSURL *)url parameters:(NSDictionary *)params completion:(NNURLConnectionCompletion)completion;
- (void)POST:(NSURL *)url parameters:(NSDictionary *)params completion:(NNURLConnectionCompletion)completion;

@end
