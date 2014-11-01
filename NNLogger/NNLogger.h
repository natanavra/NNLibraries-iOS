//
//  NNLogger.h
//  FourSigns
//
//  Created by Natan Abramov on 9/4/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Simple Logger */
@interface NNLogger : NSObject

/** 'className' and 'logMessage' must be valid objects, if either is 'nil' nothing will be logged! */
+ (void)logFromInstance:(id)sender message:(NSString *)logMessage;

/** 
 This method lets you print a message and an object.
 'className' and 'logMessage' must be valid objects, if either is 'nil' nothing will be logged! 
 */
+ (void)logFromInstance:(id)sender message:(NSString *)logMessage data:(NSString *)data;
@end
