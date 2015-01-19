//
//  UIImage+NNAdditions.m
//  GlobeKeeper
//
//  Created by Natan Abramov on 11/14/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "UIImage+NNAdditions.h"

@implementation UIImage (NNAdditions)

- (UIImage *)imageResizedToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect: CGRectMake(0, 0, size.width, size.height)];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}

@end
