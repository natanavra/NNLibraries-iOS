//
//  UIImage+Timestamp.m
//  NNLibraries
//
//  Created by Natan Abramov on 5/14/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "UIImage+NNStamps.h"
#import "NSDate+NNAdditions.h"
#import "UIView+NNAdditions.h"

static const CGFloat kDefaultPadding = 5; //points

@implementation UIImage (NNStamps)

- (UIImage *)imageByAddingWatermarkImage:(UIImage *)watermark inRect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    [self drawInRect: CGRectMake(0, 0, self.size.width, self.size.height)];
    [watermark drawInRect: rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageByAddingPOSIXTimestampInRect:(CGRect)rect withFontSize:(CGFloat)size withColor:(UIColor *)stampColor; {
    UILabel *timestampLabel = [self generateTimestampLabel];
    if(size != 0) {
        timestampLabel.font = [UIFont systemFontOfSize: size];
    }
    if(stampColor) {
        timestampLabel.textColor = stampColor;
    }
    [timestampLabel sizeToFit];
    UIImage *timestampImage = [timestampLabel snapshotImage];
    return [self imageByAddingWatermarkImage: timestampImage inRect: rect];
}

- (UIImage *)imageByAddingPOSIXTimestampInCorner:(CGRectCorner)corner withFontSize:(CGFloat)size withColor:(UIColor *)stampColor {
    UILabel *timestampLabel = [self generateTimestampLabel];
    if(size != 0) {
        timestampLabel.font = [UIFont systemFontOfSize: size];
    }
    if(stampColor) {
        timestampLabel.textColor = stampColor;
    }
    [timestampLabel sizeToFit];
    UIImage *timestampImage = [timestampLabel snapshotImage];
    CGRect frame = CGRectMake(0, 0, self.size.width, self.size.height);
    CGRect cornerRect = CGRectFromRectWithCornerAndSize(frame, corner, timestampImage.size);
    return [self imageByAddingWatermarkImage: timestampImage inRect: cornerRect];
}

- (UIImage *)imageByAddingPOSIXTimestampInCorner:(CGRectCorner)corner relativeSize:(CGFloat)relative {
    UILabel *timestampLabel = [self generateTimestampLabel];
    if(!(relative > 0 && relative < 1)) {
        relative = 0.05;
    }
    timestampLabel.font = [UIFont systemFontOfSize: self.size.height * relative];
    [timestampLabel sizeToFit];
    UIImage *timestampImage = [timestampLabel snapshotImage];
    CGRect frame = CGRectMake(0, 0, self.size.width, self.size.height);
    CGRect cornerRect = CGRectFromRectWithCornerAndSize(frame, corner, timestampImage.size);
    return [self imageByAddingWatermarkImage: timestampImage inRect: cornerRect];
}

- (UIImage *)imageByAddingStringStamp:(NSString *)string inCorner:(CGRectCorner)corner withRelativeSize:(CGFloat)relative {
    UILabel *timestampLabel = [self generateTimestampLabel];
    timestampLabel.text = string;
    if(!(relative > 0 && relative < 1)) {
        relative = 0.05;
    }
    timestampLabel.font = [UIFont systemFontOfSize: self.size.height * relative];
    [timestampLabel sizeToFit];
    UIImage *timestampImage = [timestampLabel snapshotImage];
    CGRect frame = CGRectMake(0, 0, self.size.width, self.size.height);
    CGRect cornerRect = CGRectFromRectWithCornerAndSize(frame, corner, timestampImage.size);
    return [self imageByAddingWatermarkImage: timestampImage inRect: cornerRect];
}

#pragma mark - HELPERS

- (UILabel *)generateTimestampLabel {
    UILabel *timestampLabel = [[UILabel alloc] init];
    timestampLabel.text = [[NSDate date] POSIXFormatString];
    timestampLabel.textColor = [UIColor colorWithRed:0.235 green:0.784 blue:0.078 alpha:1.000];
    timestampLabel.font = [UIFont systemFontOfSize: 14];
    return timestampLabel;
}

static CGRect CGRectFromRectWithCornerAndSize(CGRect rect, CGRectCorner corner, CGSize size) {
    CGFloat x = kDefaultPadding, y = kDefaultPadding;
    if(size.width > rect.size.width) {
        size.width = rect.size.width - kDefaultPadding * 2;
    }
    if(size.height > rect.size.height) {
        size.height = rect.size.height - kDefaultPadding * 2;
    }
    switch(corner) {
        case CGRectCornerTopLeft: {
            break;
        }
        case CGRectCornerTopRight: {
            x = rect.size.width - size.width - kDefaultPadding;
            break;
        }
        case CGRectCornerBottomLeft: {
            y = rect.size.height - size.height - kDefaultPadding;
            break;
        }
        case CGRectCornerBottomRight: {
            x = rect.size.width - size.width - kDefaultPadding;
            y = rect.size.height - size.height - kDefaultPadding;
            break;
        }
    }
    return CGRectMake(x, y, size.width, size.height);
}

@end

@implementation NNStringStampProperties

- (instancetype)initWithCorner:(CGRectCorner)corner withRelativeSize:(CGFloat)relative {
    return nil;
}

@end
