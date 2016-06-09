//
//  NNConstants.h
//  FourSigns
//
//  Created by Natan Abramov on 10/5/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NNLocalizedString(key) NSLocalizedString(key, nil)

FOUNDATION_EXPORT NSString *const NNLibrariesVersion;

FOUNDATION_EXPORT NSString *const kNNStoreKitProductPurchasedNotification;

FOUNDATION_EXPORT const NSInteger kEmptyStatusCode;

FOUNDATION_EXPORT const NSTimeInterval NNDefaultAnimationDuration;
FOUNDATION_EXPORT const BOOL NNProductionBuild;

typedef void (^NNObjectAndErrorCallback)(id object, NSError *error);

@interface NNConstants : NSObject
@end