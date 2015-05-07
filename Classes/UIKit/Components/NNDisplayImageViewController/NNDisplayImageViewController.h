//
//  NNDisplayImageViewController.h
//  NNLibraries
//
//  Created by Natan Abramov on 3/30/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNDisplayImageViewController : UIViewController
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, copy) NSString *closeBtnTitle;
@end
