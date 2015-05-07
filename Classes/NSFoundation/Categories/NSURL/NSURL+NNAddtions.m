//
//  NSURL+NNAddtions.m
//  NNLibraries
//
//  Created by Natan Abramov on 4/18/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NSURL+NNAddtions.h"
#import "NNUtilities.h"

@implementation NSURL (NNAddtions)

+ (NSURL *)validURLFromString:(NSString *)string {
    if([string rangeOfString: @"://"].location != NSNotFound) {
        return [self URLWithString: string];
    } else {
        NSString *path = [NNUtilities pathToFileInDocumentsDirectory: string];
        return [self fileURLWithPath: path];
    }
}

@end
