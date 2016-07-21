//
//  NNURLRequestSerializer.m
//  NNLibraries
//
//  Created by Natan Abramov on 18/08/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNURLRequestSerializer.h"
#import "NSObject+NNAdditions.h"
#import "NSURL+NNAddtions.h"
#import "NNJSONUtilities.h"
#import "NNSecurity.h"


@implementation NNHTTPRequestSerializer

+ (instancetype)serializer {
    return [[self alloc] init];
}


- (instancetype)init {
    if(self = [super init]) {
        
    }
    return self;
}

- (NSURLRequest *)requestWithURL:(NSURL *)url withMethod:(NNHTTPMethod)method withParams:(NSDictionary *)params withHeaders:(NSDictionary *)headers {
    return [[self mutableRequestWithURL: url withMethod: method withParams: params withHeaders: headers] copy];
}

- (NSMutableURLRequest *)mutableRequestWithURL:(NSURL *)url withMethod:(NNHTTPMethod)method withParams:(NSDictionary *)params withHeaders:(NSDictionary *)headers {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    [request setHTTPMethod: [self methodFromHTTPMethod: method]];
    [headers enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        [request setValue: [obj nnDescription] forHTTPHeaderField: [key nnDescription]];
    }];
    
    if(![request valueForHTTPHeaderField: @"Content-Type"]) {
        [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField: @"Content-Type"];
    }
    
    switch(method) {
        case NNHTTPMethodGET: {
            NSURL *newURL = [url nnURLByAddingGETQueryParams: params];
            [request setURL: newURL];
            break;
        }
        case NNHTTPMethodPOST: {
            NSData *postData = nil;
            if(params) {
                NSString *query = [NSURL nnQueryWithParams: params];
                postData = [query dataUsingEncoding: NSUTF8StringEncoding];
            }
            [request setHTTPBody: postData];
            break;
        }
    }
    
    return request;
}

- (NSString *)methodFromHTTPMethod:(NNHTTPMethod)method {
    NSString *retVal = nil;
    switch(method) {
        case NNHTTPMethodGET:
            retVal = @"GET";
            break;
        case NNHTTPMethodPOST:
            retVal = @"POST";
            break;
        default:
            retVal = @"GET";
            break;
    }
    return retVal;
}

@end

@implementation NNJSONRequestSerializer

- (NSMutableURLRequest *)mutableRequestWithURL:(NSURL *)url withMethod:(NNHTTPMethod)method withParams:(NSDictionary *)params withHeaders:(NSDictionary *)headers {
    if(method != NNHTTPMethodPOST) {
        return [super mutableRequestWithURL: url withMethod: method withParams: params withHeaders: headers];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    [request setHTTPMethod: @"POST"];
    [headers enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        [request setValue: [obj nnDescription] forHTTPHeaderField: [key nnDescription]];
    }];
    
    if(![request valueForHTTPHeaderField: @"Content-Type"]) {
        [request setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    }
    
    if(params) {
        NSError *error = nil;
        NSData *jsonData = [NNJSONUtilities JSONDataFromObject: params prettyPrint: NO error: &error forceValid: YES];
        [request setHTTPBody: jsonData];
    }
    
    return request;
}

- (NSURLRequest *)requestWithURL:(NSURL *)url withMethod:(NNHTTPMethod)method withParams:(NSDictionary *)params withHeaders:(NSDictionary *)headers {
    return [[self mutableRequestWithURL: url withMethod: method withParams: params withHeaders: headers] copy];
}

@end

