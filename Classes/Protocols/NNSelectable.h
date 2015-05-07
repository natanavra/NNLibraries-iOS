//
//  NNSelectable.h
//  NNLibraries
//
//  Created by Natan Abramov on 1/9/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

//Kills duplicate imports
#pragma once

#ifndef NNSELECTABLE_IMPORT_ONCE
#define NNSELECTABLE_IMPORT_ONCE

#import <Foundation/Foundation.h>

@protocol NNSelectable <NSObject>
@required
- (NSString *)title;
@optional
- (NSInteger)objectID;
- (NSString *)objectStringID;
@end

#endif