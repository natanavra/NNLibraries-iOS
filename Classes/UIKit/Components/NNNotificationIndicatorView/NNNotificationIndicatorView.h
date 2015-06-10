//
//  GKNotificationIndicator.h
//  GlobeKeeper
//
//  Created by Natan Abramov on 6/8/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  @author natanavra
 *  Red Circle with white count label for displaying notification count
 */
@interface NNNotificationIndicatorView : UIView
- (void)setNotificationCount:(NSUInteger)count;
@end
