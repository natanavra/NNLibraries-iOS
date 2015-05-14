//
//  UIImage+NNAdditions.h
//  GlobeKeeper
//
//  Created by Natan Abramov on 11/14/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NNAdditions)
+ (UIImage *)imageNamedWithOriginalRendering:(NSString *)imageName;
- (UIImage *)imageResizedToSize:(CGSize)size;
@end
