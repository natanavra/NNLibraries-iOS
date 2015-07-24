//
//  WMOtherXibUIView.m
//  WorldMate Live
//
//  Created by Natan Abramov on 3/10/15.
//
//

#import "NNFromXIBView.h"

@implementation NNFromXIBView

/** This here replaces the view that was loaded in another xib with a view loaded in our xib */
- (instancetype)awakeAfterUsingCoder:(NSCoder *)aDecoder {
    if(self.subviews.count == 0) {
        NSString *nibName = NSStringFromClass(self.class);
        if([[NSBundle mainBundle] pathForResource: nibName ofType: @"nib"] != nil) {
            NSArray *allViews = [[NSBundle mainBundle] loadNibNamed: nibName owner: nil options: nil];
            if(allViews.count > 0) {
                __typeof__(self) loadedView = allViews[0];
                if(!CGRectEqualToRect(self.frame, CGRectZero)) {
                    loadedView.frame = self.frame;
                }
                loadedView.autoresizingMask = self.autoresizingMask;
                loadedView.translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints;
                
                /** Copy all constraints */
                for (NSLayoutConstraint *constraint in self.constraints) {
                    id firstItem = constraint.firstItem;
                    if (firstItem == self) {
                        firstItem = loadedView;
                    }
                    
                    id secondItem = constraint.secondItem;
                    if (secondItem == self) {
                        secondItem = loadedView;
                    }
                    
                    [loadedView addConstraint: [NSLayoutConstraint constraintWithItem: firstItem
                                                                            attribute: constraint.firstAttribute
                                                                            relatedBy: constraint.relation
                                                                               toItem: secondItem
                                                                            attribute: constraint.secondAttribute
                                                                           multiplier: constraint.multiplier
                                                                             constant: constraint.constant]];
                }
                [loadedView loadedFromOtherXIB];
                return loadedView;
            }
        }
    }
    return self;
}

- (void)loadedFromOtherXIB {
    
}

@end
