//
//  NNRequestConstants.h
//  NNLibraries
//
//  Created by Natan Abramov on 18/08/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Constants

typedef void(^NNURLConnectionCompletion)(NSHTTPURLResponse *response, id responseObject, NSError *error);

typedef NS_ENUM(NSUInteger, NNHTTPMethod) {
    NNHTTPMethodGET = 0,
    NNHTTPMethodPOST,
};

FOUNDATION_EXPORT NSString *const NNURLConnectionResponseErrorDomain;


#pragma mark - Interface Declarations

@interface NNRequestConstants : NSObject

@end
