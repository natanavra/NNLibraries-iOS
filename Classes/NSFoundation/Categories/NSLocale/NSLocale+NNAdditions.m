//
//  NSLocale+NNAdditions.m
//  Pods
//
//  Created by Natan Abramov on 20/07/2016.
//
//

#import "NSLocale+NNAdditions.h"

@implementation NSLocale (NNAdditions)

+ (NSString *)preferredLanguageId {
    NSString *language = @"en";
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    if(preferredLanguages.count > 0) {
        NSString *firstLang = preferredLanguages[0];
        NSDictionary *components = [NSLocale componentsFromLocaleIdentifier: firstLang];
        language = components[NSLocaleLanguageCode];
    }
    return language;
}

@end
