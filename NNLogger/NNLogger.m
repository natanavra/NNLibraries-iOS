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
#ifdef DEBUG
    if(sender && logMessage) {
        NSLog(@"%@--%@", NSStringFromClass([sender class]), logMessage);
    }
#endif
}

@end
