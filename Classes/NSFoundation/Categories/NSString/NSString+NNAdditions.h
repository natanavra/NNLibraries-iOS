//
//  NSString+NNAdditions.h
//  NNLibraries
//
//  Created by Natan Abramov on 3/5/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NNSelectable.h"

@interface NSString (NNAdditions) <NNSelectable>
/** 
 @return new NSString without white spaces in the begining and the end.
 */
- (NSString *)stringByTrimmingWhiteSpace;
/**
 @return new NSString without any white spaces in it
 */
- (NSString *)stringByRemovingAllWhiteSpace;
@end

/** ------------------------------------------ */

@interface NSString (NSAttributedString)
- (NSAttributedString *)attributedStringWithFontName:(NSString *)fontName withSize:(CGFloat)size;
- (NSAttributedString *)attributedStringWithFont:(UIFont *)font;
@end
