//
//  NSURL+NNAddtions.m
//  NNLibraries
//
//  Created by Natan Abramov on 4/18/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NSURL+NNAddtions.h"
#import "NNUtilities.h"
#import "NSObject+NNAdditions.h"

@implementation NSURL (NNAddtions)

+ (NSURL *)nnValidURLFromString:(NSString *)string {
    if([string rangeOfString: @"://"].location != NSNotFound) {
        return [self URLWithString: string];
    } else {
        NSString *path = [NNUtilities pathToFileInDocumentsDirectory: string];
        return [self fileURLWithPath: path];
    }
}

+ (NSString *)nnQueryWithParams:(NSDictionary *)params {
    NSMutableString *query = [NSMutableString string];
    [params enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        NSString *stringKey = [key nnDescription];
        NSString *stringObj = [obj nnDescription];
        NSString *item = [NSString stringWithFormat: @"%@=%@", stringKey, stringObj];
        if(query.length != 0) {
            [query appendString: @"&"];
        }
        [query appendString: item];
    }];
    return query;
}

+ (NSDictionary *)nnDictionaryFromQueryString:(NSString *)query {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *components = [query componentsSeparatedByString: @"&"];
    for(NSString *item in components) {
        NSArray *queryItems = [item componentsSeparatedByString: @"="];
        if(queryItems.count > 1) {
            dict[queryItems[0]] = queryItems[1];
        }
    }
    return dict;
}

- (NSURL *)nnURLByAddingGETQueryParams:(NSDictionary *)params {
    if(params.count == 0) {
        return self;
    }
    
    NSURL *retval = nil;
    NSDictionary *existingParams = [[self class] nnDictionaryFromQueryString: [self query]];
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary: existingParams];
    [allParams addEntriesFromDictionary: params];
    NSString *query = [[self class] nnQueryWithParams: allParams];
    
    NSString *urlString = [self absoluteString];
    NSRange markRange = [urlString rangeOfString: @"?"];
    if(markRange.location != NSNotFound) {
        urlString = [urlString substringToIndex: markRange.location];
    }
    
    if(query.length > 0) {
        NSString *fullURL = [NSString stringWithFormat: @"%@?%@", urlString, query];
        retval = [NSURL URLWithString: fullURL];
    } else {
        retval = [NSURL URLWithString: urlString];
    }
    
    return retval;
}
@end
