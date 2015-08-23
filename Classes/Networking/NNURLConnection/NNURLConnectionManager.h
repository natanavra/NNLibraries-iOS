//
//  NNURLConnectionManager.h
//  NNLibraries
//
//  Created by Natan Abramov on 17/08/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NNURLConnection;

@interface NNURLConnectionManager : NSObject
@property (nonatomic, readonly) NSMutableArray *connections;

+ (instancetype)sharedManager;

- (void)startConnection:(NNURLConnection *)connection;

@end
