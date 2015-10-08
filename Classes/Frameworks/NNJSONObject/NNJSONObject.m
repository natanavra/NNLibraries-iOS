//
//  NNJSONObject.m
//  NNLibraries
//
//  Created by Natan Abramov on 23/08/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNJSONObject.h"

static NSString *const kJsonDictKey = @"jsonDict";

@implementation NNJSONObject

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if(self = [super init]) {
        if(![dict isKindOfClass: [NSDictionary class]]) {
            return nil;
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if(self = [super init]) {
        NSDictionary *json = [decoder decodeObjectForKey: kJsonDictKey];
        if(json) {
            self = [self initWithDictionary: json];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    NSDictionary *json = [self jsonRepresentation];
    [encoder encodeObject: json forKey: kJsonDictKey];
}

- (NSDictionary *)jsonRepresentation {
    return nil;
}

- (NSDictionary *)dictionaryRepresentation {
    return nil;
}

- (NSString *)description {
    NSString *description = [super description];
    return [NSString stringWithFormat: @"%@: %@", description, [self jsonRepresentation]];
}

@end