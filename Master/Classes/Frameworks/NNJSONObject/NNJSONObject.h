//
//  NNJSONObject.h
//  NNLibraries
//
//  Created by Natan Abramov on 3/20/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NNJSONObject <NSObject>
@required
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)jsonRepresentation;
@end

@interface NNJSONObject : NSObject <NNJSONObject>
@end