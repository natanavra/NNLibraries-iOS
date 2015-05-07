//
//  NNLogger.m
//  FourSigns
//
//  Created by Natan Abramov on 9/4/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "NNLogger.h"
#import "NNUtilities.h"

static NSUInteger kMaxLogLength = 1024; //characters
BOOL const kGlobalForceLogAll = YES;

@interface NNLogger ()
@end

@implementation NNLogger

static NSMutableArray *_logs = nil;

+ (NSArray *)logEntries {
    return [_logs copy];
}

+ (NSString *)logEntriesFormatted {
    return [_logs componentsJoinedByString: @"\n"];
}

+ (NSArray *)clearLogs {
    NSArray *logs = [self logEntries];
    [_logs removeAllObjects];
    return logs;
}

+ (void)logFromInstance:(id)sender message:(NSString *)logMessage {
    [self logFromInstance: sender message: logMessage data: nil];
}

+ (void)logFromInstance:(id)sender message:(NSString *)logMessage data:(id)object {
    [self logFromInstance: sender message: logMessage data: object forceLogAll: NO];
}

+ (void)logFromInstance:(id)sender message:(NSString *)logMessage data:(id)object forceLogAll:(BOOL)force {
    if([NNUtilities isDebugMode]) {
        NSString *log = [self logStringFromInstance: sender message: logMessage data: object];
        if(log.length > kMaxLogLength && !force && !kGlobalForceLogAll) {
            log = [log substringToIndex: kMaxLogLength];
            log = [log stringByAppendingString: @"\n... (Use 'forceLogAll' to see all content)"];
        }
        NSLog(@"😡 %@", log);
        
        if(!_logs) {
            _logs = [[NSMutableArray alloc] init];
        }
        [_logs addObject: log];
    }
}

+ (NSString *)logStringFromInstance:(id)sender message:(NSString *)logMessage {
    return [self logStringFromInstance: sender message: logMessage data: nil];
}

+ (NSString *)logStringFromInstance:(id)sender message:(NSString *)logMessage data:(id)object {
    NSMutableString *output = [NSMutableString string];
    NSString *dataString = [self descriptionFromObject: object];
    if(sender) {
        [output appendFormat: @"%@", NSStringFromClass([sender class])];
    }
    if(logMessage) {
        if(output.length > 0) {
            [output appendString: @": "];
        }
        [output appendFormat: @"%@", logMessage];
    }
    if(dataString.length > 0) {
        if(output.length > 0) {
            [output appendString: @", "];
        }
        [output appendFormat: @"%@", dataString];
    }
    if(output.length == 0) {
        [output appendString: @"BAD LOG"];
    }
    return output;
}

+ (NSString *)descriptionFromObject:(id)object {
    NSString *description = nil;
    if([object isKindOfClass: [NSString class]]) {
        description = object;
    } else if([object isKindOfClass: [NSData class]]) {
        description = [[NSString alloc] initWithData: object encoding: NSUTF8StringEncoding];
    } else if([object isKindOfClass: [NSDictionary class]]) {
        
    }
    
    if(!description || description.length == 0) {
        description = [object description];
    }
    return description;
}

@end
