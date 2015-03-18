//
//  LocationManager.m
//  MaKasher
//
//  Created by Natan Abramov on 4/7/14.
//  Copyright (c) 2014 Natan Abramov. All rights reserved.
//

#import "NNLocationManager.h"
#import "NNLogger.h"
#import "NNConstants.h"
#import "UIAlertView+NNAdditions.h"

#define DEBUG_LOCATION 0

@import CoreLocation;

@interface NNLocationManager () <CLLocationManagerDelegate> {
    BOOL failed;
}
@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, strong) CLLocation *currentLoc;
@property (nonatomic, strong) CLLocation *lastLocation;
@end

@implementation NNLocationManager

#pragma mark - init

+ (instancetype)sharedLocation {
    static NNLocationManager *mgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [[self alloc] init];
    });
    return mgr;
}

+ (NNLocationManager *)defaultManager {
    return [self sharedLocation];
}

- (id)init {
    if(self = [super init]) {
        failed = NO;
        if([CLLocationManager locationServicesEnabled]) {
            [NNLogger logFromInstance: self message: @"Location Enabled"];
            CLAuthorizationStatus gpsStatus = [CLLocationManager authorizationStatus];
            if(gpsStatus != kCLAuthorizationStatusDenied &&
               gpsStatus != kCLAuthorizationStatusRestricted) {
                //Can use location
                self.locMgr = [[CLLocationManager alloc] init];
                if([_locMgr respondsToSelector: @selector(requestWhenInUseAuthorization)]) {
                    [_locMgr performSelector: @selector(requestWhenInUseAuthorization)];
                }
                _locMgr.delegate = self;
                _locMgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
                [_locMgr startUpdatingLocation];
                
                self.currentLoc = _locMgr.location;
            } else {
                //Can't use location
                failed = YES;
            }
        } else {
            //No location services
            failed = YES;
        }
    }
    return self;
}

#pragma mark - Class Methods

+ (BOOL)locationServicesEnabled {
    return [CLLocationManager locationServicesEnabled];
}

+ (BOOL)authorizedToUseLocation {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if([CLLocationManager respondsToSelector: @selector(requestWhenInUseAuthorization)]) {
        return (status == kCLAuthorizationStatusAuthorizedWhenInUse) ? YES : NO;
    } else {
        return (status != kCLAuthorizationStatusRestricted &&
                status != kCLAuthorizationStatusDenied &&
                status != kCLAuthorizationStatusNotDetermined) ? YES : NO;
    }
}

+ (BOOL)locationCanBeUsed {
    return ([self locationServicesEnabled] && [self authorizedToUseLocation]);
}

+ (BOOL)userDecided {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return (status == kCLAuthorizationStatusNotDetermined) ? NO : YES;
}

#pragma mark - Location Delegate

- (BOOL)failedGettingLocation {
    return failed;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [NNLogger logFromInstance: self message: @"Authorization changed"];
    if(status != kCLAuthorizationStatusRestricted && status != kCLAuthorizationStatusDenied) {
        [self.locMgr startUpdatingLocation];
        self.currentLoc = _locMgr.location;
    } else {
        [self.locMgr stopUpdatingLocation];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName: kLocationAuthChanged object: nil];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [NNLogger logFromInstance: self message: @"didFailWithError" data: error];
    failed = YES;
    if(error.code == kCLErrorLocationUnknown) {
        //Keeps updating location
        [NNLogger logFromInstance: self message: @"Location is unknown"];
    } else if(error.code == kCLErrorDenied) {
        [self.locMgr stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject]; //Get last known position;
    failed = NO;
    self.currentLoc = location;
    if(DEBUG_LOCATION) {
        [NNLogger logFromInstance: self message: @"Location changed" data: location];
    }
}

#pragma mark - Getters

- (BOOL)locationChanged {
    if([self.lastLocation distanceFromLocation: _currentLoc] > 50) {
        return YES;
    }
    return NO;
}

- (CLLocation *)currentLocation {
    self.lastLocation = _currentLoc;
    return self.currentLoc;
}

- (double)currentLongitude {
    return self.currentLoc.coordinate.longitude;
}

- (double)currentLatitude {
    return self.currentLoc.coordinate.latitude;
}

- (CLLocationCoordinate2D)currentLocationCoordinate {
    self.lastLocation = _currentLoc;
    return self.currentLoc.coordinate;
}

- (double)distanceFromCurrentLocation:(CLLocationCoordinate2D)coordinate {
    if(_currentLoc != nil) {
        CLLocation *loc = [[CLLocation alloc] initWithLatitude: coordinate.latitude longitude: coordinate.longitude];
        return (double)[_currentLoc distanceFromLocation: loc];
    }
    return 0;
}

- (BOOL)currentLocationAvailable {
    if(_currentLoc != nil) {
        //BOOL accurate = (currentLoc.horizontalAccuracy <= kAccuracyThreshold && currentLoc.verticalAccuracy <= kAccuracyThreshold);
        BOOL notZero = (_currentLoc.coordinate.latitude != 0 && _currentLoc.coordinate.longitude != 0);
        if(notZero) {
            return YES;
        } else {
            //Location is not accurate enough
            return NO;
        }
    }
    return NO;
}

- (NSString *)parsedDistance:(double)distance {
    if(distance != 0) {
        if(distance >= 1000) {
            double kilometers = distance / 1000.0f;
            if(kilometers >= 100) {
                return [NSString stringWithFormat: @"%zd ק״מ", (NSInteger)kilometers];
            } else {
                return [NSString stringWithFormat: @"%.1f ק״מ", kilometers];
            }
        } else {
            return [NSString stringWithFormat: @"%zi מטר", (NSInteger)distance];
        }
    }
    return nil;
}

#pragma mark - Error handling

- (void)displayError {
    if(![self currentLocationAvailable]) {
        if(failed) {
            [self alertCantUseLocation];
        } else {
            [self alertLocationFailed];
        }
    }
}

- (void)alertLocationFailed {
    [UIAlertView showAlertWithTitle: @"Error" message: @"Location Services are unavailable. Please enable them in settings." cancelButtonTitle: @"OK" otherButtons: nil delegate: nil];
}

- (void)alertCantUseLocation {
    [UIAlertView showAlertWithTitle: @"Error" message: @"Failed to find your location." cancelButtonTitle: @"OK" otherButtons: nil delegate: nil];
}

#pragma mark - Methods

- (void)stopUpdatingLocation {
    failed = YES;
    [self.locMgr stopUpdatingLocation];
}

- (void)startUpdatingLocation {
    failed = NO;
    [self.locMgr startUpdatingLocation];
}

@end
