//
//  NNStoreKitHelper.m
//  FourSigns
//
//  Created by Natan Abramov on 10/5/14.
//  Copyright (c) 2014 natanavra. All rights reserved.
//

#import "NNStoreKitHelper.h"
#import "NNLogger.h"
#import "NNConstants.h"

#import <StoreKit/StoreKit.h>

@interface NNStoreKitHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    @protected
    NNStoreKitCompletionBlock _callback;
}
@property (nonatomic, strong) SKProductsRequest *productsRequest;
@property (nonatomic, strong) NSSet *productIdentifiers;
@property (nonatomic, strong) NSArray *products;
@end

@implementation NNStoreKitHelper

- (instancetype)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    if(self = [super init]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver: self];
        self.productIdentifiers = productIdentifiers;
    }
    return self;
}

#pragma mark - Requests

- (void)requestProductsWithCompletionBlock:(NNStoreKitCompletionBlock)callback {
    if(_productIdentifiers.count > 0) {
        [NNLogger logFromInstance: self message: [NSString stringWithFormat: @"Requesting products with identifiers: %@", _productIdentifiers]];
        _callback = callback;
        self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers: _productIdentifiers];
        _productsRequest.delegate = self;
        [_productsRequest start];
    } else {
        [NNLogger logFromInstance: self message: @"No product identifiers, not trying to request in-app purchase products."];
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    [NNLogger logFromInstance: self message: @"Request did receive response!"];
    self.products = response.products;
    
    [self.products sortedArrayUsingComparator: ^NSComparisonResult(id obj1, id obj2) {
        SKProduct *prod1 = (SKProduct *)obj1;
        SKProduct *prod2 = (SKProduct *)obj2;
        return [prod1.productIdentifier compare: prod2.productIdentifier];
    }];

    _callback(_products, nil);
    _productsRequest = nil;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    _productsRequest = nil;
    _callback(nil, error);
}

#pragma mark - Payment

- (void)buyProductWithIdentifier:(NSString *)productIdentifier {
    if(_products.count > 0) {
        SKProduct *productToBuy = nil;
        for(SKProduct *product in _products) {
            if([product.productIdentifier isEqualToString: productIdentifier]) {
                productToBuy = product;
                break;
            }
        }
        if(productToBuy) {
            [self buyProduct: productToBuy];
        } else {
            [NNLogger logFromInstance: self message: @"Product Identifier not found ('buyProductWithIdentifier:')"];
        }
    } else {
        [NNLogger logFromInstance: self message: @"No products to buy from!"];
    }
}

- (void)buyProduct:(SKProduct *)product {
    if(_products.count > 0) {
        [NNLogger logFromInstance: self message: [NSString stringWithFormat: @"Buying Product: %@", product.localizedTitle]];
        SKPayment *payment = [SKPayment paymentWithProduct: product];
        [[SKPaymentQueue defaultQueue] addPayment: payment];
    } else {
        [NNLogger logFromInstance: self message: @"No Products to buy from!"];
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for(SKPaymentTransaction *transaction in transactions) {
        switch(transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing: {
                //Processing purchase
                break;
            }
            case SKPaymentTransactionStateRestored: {
                //Restored from previous purchase
                break;
            }
            case SKPaymentTransactionStatePurchased: {
                [self transactionComplete: transaction];
                break;
            }
            case SKPaymentTransactionStateFailed: {
                [self transactionFailed: transaction];
                break;
            }
            default:
                break;
        }
    }
}

- (void)transactionComplete:(SKPaymentTransaction *)transaction {
    [NNLogger logFromInstance: self message: [NSString stringWithFormat: @"Transaction Complete: %@", transaction.payment.productIdentifier]];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [[NSNotificationCenter defaultCenter] postNotificationName: kNNStoreKitProductPurchasedNotification object: transaction.payment.productIdentifier];
}

- (void)transactionFailed:(SKPaymentTransaction *)transaction {
    [NNLogger logFromInstance: self message: [NSString stringWithFormat: @"Transaction Failed: %@", transaction.error]];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

#pragma mark - Dealloc

- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver: self];
}

@end
