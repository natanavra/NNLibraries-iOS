//
//  NSURL+NNAddtions.h
//  NNLibraries
//
//  Created by Natan Abramov on 4/18/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (NNAddtions)
/**
 *  @author natanavra
 *  If the URL has a scheme - tries to create a URL.
 *  If no scheme, tries to create a file url in documents directory
 */
+ (NSURL *)nnValidURLFromString:(NSString *)string;

- (NSURL *)nnURLByAddingGETQueryParams:(NSDictionary *)params;
@end
