//
//  LocationManager.h
//  MaKasher
//
//  Created by Natan Abramov on 4/7/14.
//  Copyright (c) 2014 Natan Abramov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;
@interface NNLocationManager : NSObject

+ (NNLocationManager *)defaultManager;
+ (BOOL)locationServicesEnabled;
+ (BOOL)authorizedToUseLocation;
+ (BOOL)userDecided;
+ (BOOL)locationCanBeUsed;

- (BOOL)currentLocationAvailable;
- (CLLocation *)getCurrentLocation;
- (BOOL)locationChanged;

- (BOOL)failedGettingLocation;
- (void)stopUpdatingLocation;
- (void)startUpdatingLocation;

//This method displays the error (if exists) to the user.
- (void)displayError;

@end
