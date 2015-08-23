//
//  NNConstants.h
//  FourSigns
//
//  Created by Natan Abramov on 10/5/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#define NNLocalizedString(key) NSLocalizedString(key, nil)

#define kStoreKitProductPurchasedNotification   @"NNStoreKit_ProductPurchased"
#define kLocationAuthChanged                    @"LocationAuthChanged"

#define kEmptyStatusCode 0

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT const NSUInteger kNNLibrariesMajorVersion;

FOUNDATION_EXPORT const NSTimeInterval NNDefaultAnimationDuration;
FOUNDATION_EXPORT const BOOL NNProductionBuild;

typedef void (^NNObjectAndErrorCallback)(id object, NSError *error);

@interface NNConstants : NSObject
@end