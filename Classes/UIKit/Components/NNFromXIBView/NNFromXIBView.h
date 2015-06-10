//
//  WMOtherXibUIView.h
//  WorldMate Live
//
//  Created by Natan Abramov on 3/10/15.
//
//

#import <UIKit/UIKit.h>

/**
 *  Subclass of this class will load the interface (xib) of the same name upon initialization.
 *  Some potential uses: <br/>
 *  - Breakdown complex XIBs into multiple, smaller and easier to maintain XIBs.
 *  - Create modular XIBs, giving you the option to load the same XIB in different Views. (e.g. WMHotelStarsView)
 *
 *  @WARNING: The XIB's name must be the same as the class' name!
 */

@interface NNFromXIBView : UIView
- (void)loadedFromOtherXIB;
@end
