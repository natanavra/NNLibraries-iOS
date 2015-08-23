//
//  NNURLConnectionManager.m
//  NNLibraries
//
//  Created by Natan Abramov on 17/08/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNURLConnectionManager.h"
#import "NNURLConnection.h"

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

@end
