//
//  NSString+NNAdditions.m
//  NNLibraries
//
//  Created by Natan Abramov on 3/5/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NSString+NNAdditions.h"

@implementation NSString (NNAdditions)

- (NSString *)stringByTrimmingWhiteSpace {
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByRemovingAllWhiteSpace {
    return [self stringByReplacingOccurrencesOfString: @" " withString: @""];
}

#pragma mark - NNSelectable

- (NSString *)title {
    return self;
}

- (NSString *)objectStringID {
    return self;
}

- (NSInteger)objectID {
    return [self integerValue];
}

@end

@implementation NSString (NSAttributedString)

- (NSAttributedString *)attributedStringWithFontName:(NSString *)fontName withSize:(CGFloat)size {
    return [self attributedStringWithFont: [UIFont fontWithName: fontName size: size]];
}

- (NSAttributedString *)attributedStringWithFont:(UIFont *)font {
    if(!font) {
        return nil;
    }
    return [[NSAttributedString alloc] initWithString: self attributes: @{NSFontAttributeName : font}];
}

@end
