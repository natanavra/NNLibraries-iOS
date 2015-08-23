//
//  NNJSONObject.m
//  NNLibraries
//
//  Created by Natan Abramov on 23/08/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNJSONObject.h"

@implementation NNJSONObject

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if(self = [super init]) {
        if(![dict isKindOfClass: [NSDictionary class]]) {
            return nil;
        }
    }
    return self;
}

- (NSDictionary *)jsonRepresentation {
    return nil;
}

- (NSString *)description {
    NSString *description = [super description];
    return [NSString stringWithFormat: @"%@: %@", description, [self jsonRepresentation]];
}

@end