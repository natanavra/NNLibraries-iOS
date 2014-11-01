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

+ (void)logFromInstance:(id)sender message:(NSString *)logMessage data:(NSString *)data {
    if(sender && logMessage) {
        NSMutableString *output = [NSMutableString stringWithFormat: @"%@--%@", NSStringFromClass([sender class]), logMessage];
        if(data) {
            [output appendFormat: @"--%@", data];
        }
#ifdef DEBUG
        NSLog(@"%@", output);
#endif
    }
}

@end
