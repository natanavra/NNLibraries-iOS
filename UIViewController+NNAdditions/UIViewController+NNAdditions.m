//
//  UIViewController+NNAdditions.m
//  GlobeKeeper
//
//  Created by Natan Abramov on 11/15/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "UIViewController+NNAdditions.h"
#import "NNLogger.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation UIViewController (NNAdditions)

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
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
        imagePicker.allowsEditing = NO;
        [self presentViewController: imagePicker animated: YES completion: nil];
        return YES;
    } else if(!available) {
        [NNLogger logFromInstance: self message: @"Camera is not available! Probably simulator!"];
    }
    return NO;
}

@end
