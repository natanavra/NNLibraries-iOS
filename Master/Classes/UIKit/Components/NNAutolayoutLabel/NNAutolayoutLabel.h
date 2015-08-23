//
//  NNAutolayoutLabel.h
//  NNLibraries
//
//  Created by Natan Abramov on 3/5/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  <strong>Use this for multiline labels.</strong><br/>
 *  This UILabel subclass handles the label's 'preferred width' and determines it in runtime to be the label's calculated width.
 *  Essentially lets you set the 'preferred width' of the label in Interface Builder to be anything and avoid compiler warnings.
 *  Just set the UILabel to be a subclass of NNAutolayoutLabel in the Identity inspector.
 */
@interface NNAutolayoutLabel : UILabel

@end
