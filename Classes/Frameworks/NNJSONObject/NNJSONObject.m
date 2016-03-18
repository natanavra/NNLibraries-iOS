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
    NSDictionary *json = [self dictionaryRepresentation];
    [encoder encodeObject: json forKey: kJsonDictKey];
}

- (NSDictionary *)jsonRepresentation {
    return [self dictionaryRepresentation];
}

- (NSDictionary *)dictionaryRepresentation {
    return nil;
}

- (NSString *)description {
    NSString *description = [super description];
    return [NSString stringWithFormat: @"%@: %@", description, [self dictionaryRepresentation]];
}

#pragma mark - Validators

- (id)validObjectFromObject:(id)object {
    if(object == [NSNull null] || object == nil) {
        return nil;
    }
    return object;
}

- (NSInteger)validIntegerFromObject:(id)object {
    if([self validObjectFromObject: object]) {
        return [object integerValue];
    }
    return 0;
}

- (float)validFloatFromObject:(id)object {
    if([self validObjectFromObject: object]) {
        return [object floatValue];
    }
    return 0.0f;
}

- (double)validDoubleFromObject:(id)object {
    if([self validObjectFromObject: object]) {
        return [object doubleValue];
    }
    return 0.0;
}

- (BOOL)validBooleanFromObject:(id)object {
    return [self validBooleanFromObject: object fallbackValue: NO];
}

- (BOOL)validBooleanFromObject:(id)object fallbackValue:(BOOL)fallback {
    if([self validObjectFromObject: object]) {
        return [object boolValue];
    }
    return fallback;
}



@end