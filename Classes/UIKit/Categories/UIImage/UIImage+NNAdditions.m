//
//  UIImage+NNAdditions.m
//  GlobeKeeper
//
//  Created by Natan Abramov on 11/14/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "UIImage+NNAdditions.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (NNAdditions)

+ (UIImage *)imageNamedWithOriginalRendering:(NSString *)imageName {
    return [[UIImage imageNamed: imageName] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)resizeImageTo640 {
    // Create the image source
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)UIImageJPEGRepresentation(self, 0.8), NULL);
    // Create thumbnail options
    CFDictionaryRef options = (__bridge CFDictionaryRef) @{
                                                           (id) kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                           (id) kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                           (id) kCGImageSourceThumbnailMaxPixelSize : @(640)
                                                           };
    // Generate the thumbnail
    CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(src, 0, options); 
    CFRelease(src);
    UIImage *img = [UIImage imageWithCGImage: thumbnail];;
    CGImageRelease(thumbnail);
    return img;
}

- (UIImage *)imageResizedToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self drawInRect: CGRectMake(0, 0, size.width, size.height)];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}

@end

