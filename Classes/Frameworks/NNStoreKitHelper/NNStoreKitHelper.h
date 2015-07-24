//
//  NNStoreKitHelper.h
//  FourSigns
//
//  Created by Natan Abramov on 10/5/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKProduct;
@class SKPaymentTransaction;

typedef void(^NNStoreKitCompletionBlock)(NSArray *products, NSError *error);

/** NNStoreKitHelper is a helper class for making requests to the StoreKit (in-app purchases).
    MISSING: Does not save any purchased states! */

@interface NNStoreKitHelper : NSObject {
    @protected
    NSArray *_products;
}

- (instancetype)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionBlock:(NNStoreKitCompletionBlock)callback;

- (void)buyProduct:(SKProduct *)product;
- (void)buyProductWithIdentifier:(NSString *)productIdentifier;

/* Strictly for overriding in subclasses! DO NOT USE! */
- (void)transactionComplete:(SKPaymentTransaction *)transaction;
@end
