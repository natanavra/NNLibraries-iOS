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
    }
    
    if(!description || description.length == 0) {
        description = [object description];
    }
    return description;
}

@end
