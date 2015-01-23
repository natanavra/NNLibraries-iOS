//
//  UIViewController+NNAdditions.h
//  GlobeKeeper
//
//  Created by Natan Abramov on 11/15/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NNAdditions)

/** UIImagePicker */
- (BOOL)presentPictureSelectFromSource:(UIImagePickerControllerSourceType)source allowsEditing:(BOOL)editingAllowed andDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate;
- (BOOL)presentCameraPictureCaptureWithDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate;
- (BOOL)presentCameraVideoCaptureWithDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate;

/** MBProgressHUD */
- (void)showLoadingViewWithText:(NSString *)text withSubtitle:(NSString *)subtitle;
- (void)hideLoadingView;
@end
