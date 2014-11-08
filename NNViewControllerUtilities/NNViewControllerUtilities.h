//
//  NNViewControllerUtilities.h
//  GlobeKeeper
//
//  Created by Natan Abramov on 11/8/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NNViewControllerUtilities : NSObject

+ (BOOL)presentImagePickerFromController:(UIViewController *)viewController
                            withDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate;

@end
