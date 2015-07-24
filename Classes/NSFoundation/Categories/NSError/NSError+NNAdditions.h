//
//  NSError+NNAdditions.h
//  NNLibraries
//
//  Created by Natan Abramov on 16/07/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const kNNErrorDomain;

enum {
    kNilObjectError = 101,
    kInvalidJSONObjectError = 4001,
};

@interface NSError (NNAdditions)
+ (NSError *)nnErrorWithCode:(NSUInteger)code;
@end
