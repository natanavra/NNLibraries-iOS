//
//  NNAsyncImageView.h
//  iSale
//
//  Created by Natan Abramov on 10/1/14.
//  Copyright (c) 2014 Natan Abramov. All rights reserved.
//

#import <UIKit/UIKit.h>


/** Simple UIImageView subclass that loads an image from a URL, uses NNAsyncRequest.
    Displays a UIActivityIndicator whilest loading. */
@interface NNAsyncImageView : UIImageView {
    UIActivityIndicatorView *_indicator;
}
- (void)setImageFromURL:(NSURL *)imgUrl;
- (void)setImageWithURL:(NSURL *)imgUrl;
@end
