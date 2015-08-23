//
//  NNLibrariesTests.m
//  NNLibrariesTests
//
//  Created by Natan Abramov on 16/08/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NNURLConnection.h"
#import "NNLogger.h"

@interface NNURLConnectionTest : XCTestCase
@end

@implementation NNURLConnectionTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGETRequest {
    XCTestExpectation *getExpectation = [self expectationWithDescription: @"GET Expectation"];
    NSURL *GETURL = [NSURL URLWithString: @"http://httpbin.org/get"];
    NNURLConnectionCompletion getCompletion = [self completionTestWithExpectation: getExpectation];
    NNURLConnection *getConnection = [[NNURLConnection alloc] initWithURL: GETURL withCompletion: getCompletion];
    [getConnection start];
    
    [self waitForExpectationsWithTimeout: 10.0f handler: ^(NSError *error) {
        if(error) {
            NNLogDebug(@"Something went wrong with GET Request", error);
        }
        [getConnection cancel];
    }];
}

- (void)testPOSTRequest {
    XCTestExpectation *postExpectation = [self expectationWithDescription: @"POST Expectation"];
    NSURL *POSTURL = [NSURL URLWithString: @"http://httpbin.org/post"];
    NNURLConnectionCompletion postCompletion = [self completionTestWithExpectation: postExpectation];
    NNURLConnection *postConnection = [[NNURLConnection alloc] initWithURL: POSTURL withMethod: NNHTTPMethodPOST withCompletion: postCompletion];
    [postConnection start];
    
    [self waitForExpectationsWithTimeout: 10.0f handler: ^(NSError *error) {
        if(error) {
            NNLogDebug(@"Something went wrong with POST Request", error);
        }
        [postConnection cancel];
    }];
}

- (NNURLConnectionCompletion)completionTestWithExpectation:(XCTestExpectation *)expectation {
    return ^(NSURLResponse *response, NSData *data, NSError *error) {
        XCTAssertNil(error, @"Error should be nil");
        XCTAssertNotNil(data, @"Data should not be nil");
        
        if([response isKindOfClass: [NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSInteger statusCode = httpResponse.statusCode;
            if(statusCode < 200 || statusCode >= 300) {
                XCTFail(@"Status code is %li", (long)statusCode);
            }
        } else {
            XCTFail(@"Response is not of type 'NSHTTPURLResponse'");
        }
        [expectation fulfill];
    };
}

@end
