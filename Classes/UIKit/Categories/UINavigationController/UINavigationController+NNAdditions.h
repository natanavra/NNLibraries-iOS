//
//  UINavigationController+NNAdditions.h
//  NNLibraries
//
//  Created by Natan Abramov on 2/3/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (NNAdditions)
- (void)pushViewControllerFromBottom:(UIViewController *)controller;
- (void)popViewControllerFromBottom;
@end
