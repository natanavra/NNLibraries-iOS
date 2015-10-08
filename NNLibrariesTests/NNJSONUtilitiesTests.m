//
//  NNJSONUtilitiesTests.m
//  NNLibraries
//
//  Created by Natan Abramov on 25/08/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NNJSONUtilities.h"

@interface NNJSONUtilitiesTests : XCTestCase

@end

@implementation NNJSONUtilitiesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExtractValidJSON {
    NSObject *badVal = [[NSObject alloc] init];
    NSDictionary *testObject = @{@"key" : @"value",
                                 @123 : @"NOT GOOD VALUE",
                                    @"NOT GOOD KEY" : badVal};
    NSDictionary *outcome = [NNJSONUtilities makeValidJSONObject: testObject];
    NSDictionary *expected = @{@"key" : @"value"};
    XCTAssertEqualObjects(outcome, expected, @"outcome contains bad values");
    
    NSString *stringVal = @"123";
    id extractedString = [NNJSONUtilities makeValidJSONObject: stringVal];
    XCTAssertEqualObjects(extractedString, stringVal, @"Should return the string");
}

@end
