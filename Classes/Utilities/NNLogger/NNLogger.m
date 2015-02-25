//
//  NNLogger.m
//  FourSigns
//
//  Created by Natan Abramov on 9/4/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "NNLogger.h"

@implementation NNLogger

+ (void)logFromInstance:(id)sender message:(NSString *)logMessage {
    [self logFromInstance: sender message: logMessage data: nil];
}

+ (void)logFromInstance:(id)sender message:(NSString *)logMessage data:(id)object {
#ifdef DEBUG
    NSString *log = [self logStringFromInstance: sender message: logMessage data: object];
    NSLog(@"🅳 %@", log);
#endif
}

+ (NSString *)logStringFromInstance:(id)sender message:(NSString *)logMessage {
    return [self logStringFromInstance: sender message: logMessage data: nil];
}

+ (NSString *)logStringFromInstance:(id)sender message:(NSString *)logMessage data:(id)object {
    if(sender && logMessage) {
        NSMutableString *output = [NSMutableString stringWithFormat: @"%@--%@", NSStringFromClass([sender class]), logMessage];
        NSString *data = (NSString *)([object isKindOfClass: NSString.class] ? object : [object description]);
        if(data) {
            [output appendFormat: @"--%@", data];
        }
        return output;
    } else if(logMessage) {
        return logMessage;
    } else if(object) {
        NSString *data = (NSString *)([object isKindOfClass: NSString.class] ? object : [object description]);
        return [NSString stringWithFormat: @"%@", data];
    } else {
        return @"BAD LOG";
    }
}

@end
