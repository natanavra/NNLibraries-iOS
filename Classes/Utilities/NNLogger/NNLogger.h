//
//  NNLogger.h
//  FourSigns
//
//  Created by Natan Abramov on 9/4/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NNLogDebug(m, d) [NNLogger logFromInstance: self fromSelector: _cmd withLine: __LINE__ message: m data: d]

extern BOOL const kGlobalForceLogAll;

/** Simple Logger */
@interface NNLogger : NSObject

+ (NSArray *)logEntries;
+ (NSString *)logEntriesFormatted;
+ (NSArray *)clearLogs;

+ (void)setLogging:(BOOL)log;

/**
 *  Logs a message from a sender object when in DEBUG.
 *  @param sender     The object that requests to log the message.
 *  @param logMessage The message to be logged (Capped to 1024 characters)
 *  @warning To see the full content of you message - use 'logFromInstance:message:data:forceLogAll'.
 */
+ (void)logFromInstance:(id)sender message:(NSString *)logMessage;

/**
 *  Logs a message and an object description from a sender object when in DEBUG.
 *  @param sender     The object that requests to log the message.
 *  @param logMessage The message to be logged (Capped to 1024 characters)
 *  @param object     The object that a description will be logged for.
 *  @warning To see the full content of you message - use 'logFromInstance:message:data:forceLogAll'.
 */
+ (void)logFromInstance:(id)sender message:(NSString *)logMessage data:(id)object;

+ (void)logFromInstance:(id)sender fromSelector:(SEL)cmd withLine:(NSUInteger)line message:(NSString *)logMessage;
+ (void)logFromInstance:(id)sender fromSelector:(SEL)cmd withLine:(NSUInteger)line message:(NSString *)logMessage data:(id)object;

/**
 *  Logs a message and an object description from a sender object when in DEBUG.
 *  @param sender     The object that requests to log the message.
 *  @param logMessage The message to be logged (Capped to 1024 characters)
 *  @param object     The object that a description will be logged for.
 *  @param force      If 'YES' the max message cap will be ignored and everything will be logged to console.
 */
+ (void)logFromInstance:(id)sender message:(NSString *)logMessage data:(id)object forceLogAll:(BOOL)force;

/**
 *  Convinience method to get the message needed to be logged.
 *  @param sender     The sender of the log
 *  @param logMessage The message the sender wants to log.
 *  @return Log formatted string, can be used by NSLog, etc.
 */
+ (NSString *)logStringFromInstance:(id)sender message:(NSString *)logMessage;

/**
 *  Convinience method built to get a message logged with params
 *  @param sender     The sender of the log.
 *  @param logMessage The message the sender wants to log.
 *  @param object     The object that has to do with the message.
 *  @return Log formatted string, can be used by NSLog, etc.
 */
+ (NSString *)logStringFromInstance:(id)sender message:(NSString *)logMessage data:(id)object;
@end
