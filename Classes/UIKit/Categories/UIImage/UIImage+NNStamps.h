//
//  UIImage+Timestamp.h
//  NNLibraries
//
//  Created by Natan Abramov on 5/14/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

#warning This whole class needs to be refactored. Written hackishly and not too efficiently to finish stuff as quick as possible.

typedef NS_ENUM(NSInteger, CGRectCorner) {
    CGRectCornerTopLeft = 0,
    CGRectCornerTopRight,
    CGRectCornerBottomLeft,
    CGRectCornerBottomRight
};

@interface UIImage (NNStamps)
- (UIImage *)imageByAddingWatermarkImage:(UIImage *)watermark inRect:(CGRect)rect;
- (UIImage *)imageByAddingPOSIXTimestampInRect:(CGRect)rect withFontSize:(CGFloat)size withColor:(UIColor *)stampColor;
- (UIImage *)imageByAddingPOSIXTimestampInCorner:(CGRectCorner)corner withFontSize:(CGFloat)size withColor:(UIColor *)stampColor;
- (UIImage *)imageByAddingPOSIXTimestampInCorner:(CGRectCorner)corner relativeSize:(CGFloat)relative;
- (UIImage *)imageByAddingStringStamp:(NSString *)string inCorner:(CGRectCorner)corner withRelativeSize:(CGFloat)relative;
@end


#warning WORK IN PROGRESS

@interface NNStringStampProperties : NSObject
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, readonly) CGRectCorner corner;
@property (nonatomic, readonly) CGFloat fontSize;
@property (nonatomic, readonly) CGFloat relativeSize;
@property (nonatomic, readonly) BOOL useRelativeSize;
@property (nonatomic, readonly) CGFloat rect;
- (instancetype)initWithCorner:(CGRectCorner)corner withRelativeSize:(CGFloat)relative;
@end
