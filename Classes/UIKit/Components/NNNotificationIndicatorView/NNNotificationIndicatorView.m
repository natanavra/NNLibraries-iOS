//
//  GKNotificationIndicator.m
//  GlobeKeeper
//
//  Created by Natan Abramov on 6/8/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNNotificationIndicatorView.h"
#import "UIView+NNGeometry.h"

@interface NNNotificationIndicatorView ()
@property (nonatomic, weak) UILabel *countLabel;
@end


@implementation NNNotificationIndicatorView

static CGFloat const kDefaultPadding = 3.0f;

- (instancetype)init {
    if(self = [super init]) {
        [self setupViews];
        [self setNotificationCount: 0];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder: aDecoder]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor colorWithRed: 239.0/255.0 green: 0 blue: 23.0/255.0 alpha: 1];
    
    CGPoint viewCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    if(!_countLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize: 10.0];
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 1;
        label.text = @"";
        [label sizeToFit];
        label.center = viewCenter;
        [self addSubview: label];
        _countLabel = label;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGPoint viewCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    _countLabel.center = viewCenter;
    
    self.layer.cornerRadius = self.bounds.size.width / 2;
}

- (CGSize)intrinsicContentSize {
    [_countLabel sizeToFit];
    CGSize labelSize = _countLabel.frame.size;
    CGSize requiredSize = CGSizeMake(labelSize.width + kDefaultPadding * 2, labelSize.height + kDefaultPadding * 2);
    
    CGFloat diameter = MAX(requiredSize.width, requiredSize.height);
    return CGSizeMake(diameter, diameter);
}

- (void)sizeToFit {
    CGSize intrinsicSize = [self intrinsicContentSize];
    [self setFrameSize: intrinsicSize];
}

- (void)setNotificationCount:(NSUInteger)count {
    _countLabel.text = [NSString stringWithFormat: @"%li", (long)count];
    self.hidden = (count == 0);
    [self layoutSubviews];
}

@end
