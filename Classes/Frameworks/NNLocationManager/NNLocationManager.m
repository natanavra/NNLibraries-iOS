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

@import CoreLocation;

@interface NNLocationManager () <CLLocationManagerDelegate> {
    BOOL failed;
}
@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, strong) CLLocation *currentLoc;
@property (nonatomic, strong) CLLocation *lastLocation;
@end

@implementation NNLocationManager
@synthesize locMgr;
@synthesize currentLoc;
@synthesize lastLocation;

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
            NSLog(@"Location Enabled");
            CLAuthorizationStatus gpsStatus = [CLLocationManager authorizationStatus];
            if(gpsStatus == kCLAuthorizationStatusNotDetermined || gpsStatus == kCLAuthorizationStatusAuthorized) {
                //Can use location
                self.locMgr = [[CLLocationManager alloc] init];
                locMgr.delegate = self;
                locMgr.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
                
                self.currentLoc = locMgr.location;
                
                [locMgr startUpdatingLocation];
                if([locMgr respondsToSelector: @selector(requestWhenInUseAuthorization)]) {
                    [locMgr performSelector: @selector(requestWhenInUseAuthorization)];
                }
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
        return (status == kCLAuthorizationStatusAuthorized) ? YES : NO;
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
    if(status == kCLAuthorizationStatusAuthorized) {
        [self.locMgr startUpdatingLocation];
    } else {
        [self.locMgr stopUpdatingLocation];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName: kLocationAuthChanged object: nil];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location Manager Failed: %@", error.localizedDescription);
    failed = YES;
    if(error.code == kCLErrorLocationUnknown) {
        //Keeps updating location
        NSLog(@"Location is UNKNOWN!");
    } else if(error.code == kCLErrorDenied) {
        [self.locMgr stopUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject]; //Get last known position;
    //NSLog(@"Location Changed: %@", location.description);
    //NSLog(@"We Have location!");
    failed = NO;
    self.currentLoc = location;
}

#pragma mark - Getters

- (BOOL)locationChanged {
    if([self.lastLocation distanceFromLocation: currentLoc] > 50) {
        return YES;
    }
    return NO;
}

- (CLLocation *)currentLocation {
    self.lastLocation = currentLoc;
    return self.currentLoc;
}

- (CLLocationCoordinate2D)currentLocationCoordinate {
    self.lastLocation = currentLoc;
    return self.currentLoc.coordinate;
}

- (BOOL)currentLocationAvailable {
    if(![CLLocationManager locationServicesEnabled]) {
        //Location not enabled
        return NO;
    } else if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        //Not authorized to use location
        return NO;
    } else if(currentLoc == nil) {
        //No location set
        return NO;
    } else if(failed) {
        //Location services failed.
        return NO;
    } else {
        //BOOL accurate = (currentLoc.horizontalAccuracy <= kAccuracyThreshold && currentLoc.verticalAccuracy <= kAccuracyThreshold);
        BOOL notZero = (currentLoc.coordinate.latitude != 0 && currentLoc.coordinate.longitude != 0);
        if(notZero) {
            return YES;
        } else {
            //Location is not accurate enough
            return NO;
        }
    }
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
