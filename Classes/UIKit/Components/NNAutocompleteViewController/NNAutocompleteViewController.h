//
//  NNAutocompleteViewController.h
//  NNLibraries
//
//  Created by Natan Abramov on 1/9/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NNSelectable.h"

@protocol NNAutoCompleteDelegate <NSObject>
@required
- (void)selectionDone:(id<NNSelectable>)selected;
@optional
- (void)selectionCancelled;
@end

/**
 *  @author natanavra
 *  @description Use this for displaying autocomplete selection with UITableView and search bar. 
 *  @warning object in data must conform to the 'NNSelectable' protocol.
 *  @warning ONLY Use with Modal presentation style. This view has its own UINavigationBar.
 *  @warning To use the Built-in UI, copy the xib file to your application bundle.
 */
@interface NNAutocompleteViewController : UIViewController
@property (nonatomic, weak) id<NNAutoCompleteDelegate> delegate;
@property (nonatomic, strong) NSArray *autocompleteData;
@property (nonatomic, copy) NSString *closeTitle;
@property (nonatomic) NSTextAlignment textAlignment;

- (instancetype)initWithTitle:(NSString *)title delegate:(id<NNAutoCompleteDelegate>)delegate data:(NSArray *)data;
@end
