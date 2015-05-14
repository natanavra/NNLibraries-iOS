//
//  UIImage+NNAdditions.m
//  GlobeKeeper
//
//  Created by Natan Abramov on 11/14/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "UIImage+NNAdditions.h"

@implementation UIImage (NNAdditions)

+ (UIImage *)imageNamedWithOriginalRendering:(NSString *)imageName {
    return [[UIImage imageNamed: imageName] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
}

- (UIImage *)imageResizedToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self drawInRect: CGRectMake(0, 0, size.width, size.height)];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}

@end

