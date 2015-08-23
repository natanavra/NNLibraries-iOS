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



- (NSURL *)nnURLByAddingGETQueryParams:(NSDictionary *)params {
    if(params.count == 0) {
        return self;
    }
    
    NSURL *retval = nil;
    NSMutableArray *queryItems = [NSMutableArray array];
    if([self query]) {
        NSArray *originalQueryItems = [[self query] componentsSeparatedByString: @"&"];
        [queryItems addObjectsFromArray: originalQueryItems];
    }
    [params enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        NSString *stringKey = [key nnDescription];
        NSString *stringObj = [obj nnDescription];
        NSString *item = [NSString stringWithFormat: @"%@=%@", stringKey, stringObj];
        if(![queryItems containsObject: item]) {
            [queryItems addObject: item];
        }
    }];
    NSString *query = [queryItems componentsJoinedByString: @"&"];
    
    NSString *urlString = [self absoluteString];
    NSRange markRange = [urlString rangeOfString: @"?"];
    if(markRange.location != NSNotFound) {
        urlString = [urlString substringToIndex: markRange.location];
    }
    if(query.length > 0) {
        NSString *fullURL = [urlString stringByAppendingFormat: @"?%@", query];
        retval = [NSURL URLWithString: fullURL];
    } else {
        retval = [NSURL URLWithString: urlString];
    }
    
    return retval;
}
@end
