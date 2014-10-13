//
//  UIButton+NNAdditions.h
//  FourSigns
//
//  Created by Natan Abramov on 10/7/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (NNAdditions)
/** Remove all targets and all actions for all events associated with the button. */
- (void)removeAllTargetsAndActions;
@end
