//
//  NNPickerField.h
//  NNLibraries
//
//  Created by Natan Abramov on 1/9/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNPickerField : UITextField
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, readonly) NSInteger selectedIndex;
@property (nonatomic, readonly) id selectedObject;

- (void)setCloseButtonTitle:(NSString *)title;
- (void)setClearButtonTitle:(NSString *)title;
@end
