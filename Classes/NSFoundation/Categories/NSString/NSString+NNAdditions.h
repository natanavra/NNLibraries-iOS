//
//  NSString+NNAdditions.h
//  NNLibraries
//
//  Created by Natan Abramov on 3/5/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NNAdditions)
/** 
 @return new NSString without white spaces in the begining and the end.
 */
- (NSString *)stringByTrimmingWhiteSpace;
/**
 @return new NSString without any white spaces in it
 */
- (NSString *)stringByRemovingAllWhiteSpace;
@end
