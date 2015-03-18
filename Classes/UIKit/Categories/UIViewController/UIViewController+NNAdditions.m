//
//  UIViewController+NNAdditions.m
//  GlobeKeeper
//
//  Created by Natan Abramov on 11/15/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "UIViewController+NNAdditions.h"

#import "MBProgressHUD.h"
#import "NNLogger.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import "UIAlertView+NNAdditions.h"

@implementation UIViewController (NNAdditions)

#pragma mark - UIImagePicker

- (BOOL)presentPictureSelectFromSource:(UIImagePickerControllerSourceType)source allowsEditing:(BOOL)editingAllowed andDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate {
    BOOL available = [UIImagePickerController isSourceTypeAvailable: source];
    if(available && delegate) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = source;
        imagePicker.delegate = delegate;
        imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        imagePicker.allowsEditing = editingAllowed;
        [self presentViewController: imagePicker animated: YES completion: nil];
        return YES;
    } else if(!available) {
        [NNLogger logFromInstance: self message: @"Camera/Picture Library is not available! Probably simulator!"];
    }
    return NO;
}

- (BOOL)presentCameraPictureCaptureWithDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate {
    BOOL available = [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
    if(available && delegate) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = delegate;
        imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [self presentViewController: imagePicker animated: YES completion: nil];
        return YES;
    } else if(!available) {
        [NNLogger logFromInstance: self message: @"Camera is not available! Probably simulator!"];
        [UIAlertView showAlertWithTitle: @"Error!" message: @"Camera is not available"
                      cancelButtonTitle: @"OK" otherButtons: nil delegate: nil];
    }
    return NO;
}

- (BOOL)presentCameraVideoCaptureWithDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate {
    BOOL available = [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
    if(available && delegate) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = delegate;
        imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        imagePicker.allowsEditing = NO;
        [self presentViewController: imagePicker animated: YES completion: nil];
        return YES;
    } else if(!available) {
        [NNLogger logFromInstance: self message: @"Camera is not available! Probably simulator!"];
        [UIAlertView showAlertWithTitle: @"Error!" message: @"Camera is not available"
                      cancelButtonTitle: @"OK" otherButtons: nil delegate: nil];
    }
    return NO;
}

#pragma mark - MBProgressHUD

- (void)showLoadingViewWithText:(NSString *)text withSubtitle:(NSString *)subtitle {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [MBProgressHUD hideAllHUDsForView: window animated: YES];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo: window animated: YES];
        hud.dimBackground = YES;
        hud.labelText = text;
        hud.detailsLabelText = subtitle;
    });
}

- (void)hideLoadingView {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [MBProgressHUD hideAllHUDsForView: window animated: YES];
    });
}

#pragma mark - Sharing

- (void)presentSharingMenuWithItems:(NSArray *)items completion:(void(^)())completion {
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems: items applicationActivities: nil];
    [self presentViewController: activity animated: YES completion: completion];
}


@end
