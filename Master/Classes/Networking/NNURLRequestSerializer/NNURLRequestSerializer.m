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

@implementation NNHTTPRequestSerializer

+ (instancetype)serializer {
    return [[self alloc] init];
}

- (NSURLRequest *)requestWithURL:(NSURL *)url withMethod:(NNHTTPMethod)method withParameters:(NSDictionary *)params withHeaders:(NSDictionary *)headers {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    [request setValue: @"application/json" forHTTPHeaderField: @"Content-Type"];
    [request setHTTPMethod: [self methodFromHTTPMethod: method]];
    [headers enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        [request setValue: [obj nnDescription] forHTTPHeaderField: [key nnDescription]];
    }];
    
    switch(method) {
        case NNHTTPMethodGET: {
            NSURL *newURL = [url nnURLByAddingGETQueryParams: params];
            [request setURL: newURL];
            break;
        }
        case NNHTTPMethodPOST: {
            NSError *err = nil;
            NSData *postData = nil;
            if(params) {
                postData = [NNJSONUtilities JSONDataFromObject: params error: &err];
            }
            [request setHTTPBody: postData];
            break;
        }
    }
    
    return request;
}

- (NSString *)methodFromHTTPMethod:(NNHTTPMethod)method {
    NSString *retVal = @"GET";
    switch(method) {
        case NNHTTPMethodGET:
            break;
        case NNHTTPMethodPOST:
            retVal = @"POST";
            break;
        default:
            break;
    }
    return retVal;
}

@end
