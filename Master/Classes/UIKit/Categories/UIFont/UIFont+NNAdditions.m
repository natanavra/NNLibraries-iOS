//
//  UIFont+NNAdditions.m
//  NNLibraries
//
//  Created by Natan Abramov on 4/26/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "UIFont+NNAdditions.h"
#import "NNLogger.h"

@implementation UIFont (NNAdditions)

+ (void)printAllFonts {
    NSMutableString *allFonts = [NSMutableString string];
    NSArray *fontFamilies = [UIFont familyNames];
    fontFamilies = [fontFamilies sortedArrayUsingSelector: @selector(compare:)];
    for(NSString *familyName in fontFamilies) {
        [allFonts appendFormat: @"+ %@\n", familyName];
        NSArray *family = [UIFont fontNamesForFamilyName: familyName];
        family = [family sortedArrayUsingSelector: @selector(compare:)];
        for(NSString *fontName in family) {
            [allFonts appendFormat: @"  - %@", fontName];
        }
    }
    [NNLogger logFromInstance: self message: @"All Fonts" data: allFonts];
}

+ (NSArray *)allFontNames {
    NSMutableArray *allFonts = [NSMutableArray array];
    NSArray *fontFamilies = [UIFont familyNames];
    fontFamilies = [fontFamilies sortedArrayUsingSelector: @selector(compare:)];
    for(NSString *familyName in fontFamilies) {
        NSArray *family = [UIFont fontNamesForFamilyName: familyName];
        family = [family sortedArrayUsingSelector: @selector(compare:)];
        for(NSString *fontName in family) {
            [allFonts addObject: fontName];
        }
    }
    return [allFonts copy];
}

@end
