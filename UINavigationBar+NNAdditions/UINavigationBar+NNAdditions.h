//
//  UINavigationBar+NNAdditions.h
//  GlobeKeeper
//
//  Created by Natan Abramov on 11/15/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (NNAdditions)

/** Scans for an UIImageView in the navigation bar and hides it + clipsToBounds. */
- (void)hideBottomHairline;
/** Scans for an UIImageView in the navigation bar and shows it. */
- (void)showBottomHairline;

@end
