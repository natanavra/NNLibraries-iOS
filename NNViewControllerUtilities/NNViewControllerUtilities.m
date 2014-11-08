//
//  NNViewControllerUtilities.m
//  GlobeKeeper
//
//  Created by Natan Abramov on 11/8/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "NNViewControllerUtilities.h"
#import "NNLogger.h"

#import <MobileCoreServices/MobileCoreServices.h>

@implementation NNViewControllerUtilities

+ (BOOL)presentImagePickerFromController:(UIViewController *)viewController
                            withDelegate:(id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate {
    BOOL available = [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
    if(available && delegate && viewController) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = delegate;
        imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
        imagePicker.allowsEditing = NO;
        [viewController presentViewController: imagePicker animated: YES completion: nil];
        return YES;
    } else if(!available) {
        [NNLogger logFromInstance: self message: @"Camera is not available! Probably simulator!"];
    }
    return NO;
}

@end
