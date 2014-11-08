//
//  NNAsyncImageView.m
//  iSale
//
//  Created by Natan Abramov on 10/1/14.
//  Copyright (c) 2014 Natan Abramov. All rights reserved.
//

#import "NNAsyncImageView.h"
#import "NNAsyncRequest.h"
#import "NNLogger.h"

@implementation NNAsyncImageView

- (void)setImageFromURL:(NSURL *)imgUrl {
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    CGPoint center = CGPointMake(self.image.size.width /2, self.image.size.height /2);
    _indicator.center = center;
    [self addSubview: _indicator];
    [_indicator startAnimating];
    
    NNAsyncRequest *request = [[NNAsyncRequest alloc] initWithURL: imgUrl complete: ^(NSURLResponse *response, NSData *responseData, NSError *error) {
        if(!error && responseData) {
            UIImage *img = [UIImage imageWithData: responseData];
            if(img) {
                self.image = img;
            }
        } else {
            [NNLogger logFromInstance: self message: [NSString stringWithFormat: @"Failed to load image: %@", error]];
        }
        [_indicator stopAnimating];
        [_indicator removeFromSuperview];
        _indicator = nil;
    }];
    [request startAsyncConnection];
}

@end
