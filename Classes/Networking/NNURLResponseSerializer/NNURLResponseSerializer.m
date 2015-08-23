//
//  NNResponseSerializer.m
//  NNLibraries
//
//  Created by Natan Abramov on 18/08/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNURLResponseSerializer.h"
#import "NSData+NNAdditions.h"
#import "NNJSONUtilities.h"

@implementation NNHTTPResponseSerializer

+ (instancetype)serializer {
    return [[self alloc] init];
}

- (id)responseObjectForResponse:(NSHTTPURLResponse *)response withData:(NSData *)data error:(NSError **)error {
    id retval = nil;
    if(data) {
        NSString *dataString = [data nnStringWithEncoding: NSUTF8StringEncoding];
        if(!dataString && error) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Failed to create string from data, used UTF-8 encoding"};
            *error = [NSError errorWithDomain: @"com.nnlibraries.response.serialize" code: 51 userInfo: userInfo];
        }
        retval = dataString;
    }
    return retval;
}

@end


@implementation NNJSONResponseSerializer

- (id)responseObjectForResponse:(NSHTTPURLResponse *)response withData:(NSData *)data error:(NSError **)error {
    id retval = nil;
    if(data) {
        id jsonObject = [NNJSONUtilities JSONObjectFromData: data error: error];
        retval = jsonObject;
    }
    return retval;
}

@end

