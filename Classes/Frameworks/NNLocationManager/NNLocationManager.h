//
//  LocationManager.h
//  MaKasher
//
//  Created by Natan Abramov on 4/7/14.
//  Copyright (c) 2014 Natan Abramov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CLLocation.h>

/** CLLocationManager wrapper */
@interface NNLocationManager : NSObject

+ (instancetype)sharedLocation;
+ (NNLocationManager *)defaultManager __attribute__((deprecated));
+ (BOOL)locationServicesEnabled;
+ (BOOL)authorizedToUseLocation;
+ (BOOL)userDecided;
+ (BOOL)locationCanBeUsed;

- (BOOL)currentLocationAvailable;
- (CLLocation *)currentLocation;
- (CLLocationCoordinate2D)currentLocationCoordinate;
- (double)distanceFromCurrentLocation:(CLLocationCoordinate2D)coordinate;

- (double)currentLongitude;
- (double)currentLatitude;

- (BOOL)locationChanged;

- (BOOL)failedGettingLocation;
- (void)stopUpdatingLocation;
- (void)startUpdatingLocation;

- (NSString *)parsedDistance:(double)distance;

/** This method displays the error (if exists) to the user. (Localized) */
- (void)displayError;

@end
