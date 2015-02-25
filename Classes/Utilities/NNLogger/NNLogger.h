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

/** 
 'className' and 'logMessage' must be valid objects, if either is 'nil' nothing will be logged! 
 Logs message only in DEBUG mode.
 */
+ (void)logFromInstance:(id)sender message:(NSString *)logMessage;

/** 
 This method lets you print a message and an object.
 'className' and 'logMessage' must be valid objects, if either is 'nil' nothing will be logged!
 Prints the data object using UTF8 string encoding
 Logs message only in DEBUG mode.
 */
+ (void)logFromInstance:(id)sender message:(NSString *)logMessage data:(id)object;

/**
 *  Convinience method built for use with NSAssert, to get the message needed to be logged.
 *  @param sender     The sender of the log
 *  @param logMessage The message the sender wants to log.
 *  @return Log formatted string, can be used by NSLog, etc.
 */
+ (NSString *)logStringFromInstance:(id)sender message:(NSString *)logMessage;

/**
 *  Convinience method built for use with NSAssert, to get a message logged with params
 *  @param sender     The sender of the log.
 *  @param logMessage The message the sender wants to log.
 *  @param object     The object that has to do with the message.
 *  @return Log formatted string, can be used by NSLog, etc.
 */
+ (NSString *)logStringFromInstance:(id)sender message:(NSString *)logMessage data:(id)object;
@end
