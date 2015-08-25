//
//  NNURLConnection.m
//  NNLibraries
//
//  Created by Natan Abramov on 16/08/15.
//  Copyright (c) 2015 natanavra. All rights reserved.
//

#import "NNURLConnection.h"
#import "NNURLRequestSerializer.h"
#import "NNURLResponseSerializer.h"

#import "NNLibrariesEssentials.h"
#import "NSDictionary+NNAdditions.h"
#import "NSObject+NNAdditions.h"


#pragma mark - Private Declarations

@interface NNURLConnection ()
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSURLSessionDataTask *currentTask;
@property (nonatomic, readwrite) NSHTTPURLResponse *response;
@property (nonatomic, readwrite) NSData *data;
@end

#pragma mark - Implementation

@implementation NNURLConnection


#pragma mark - Init

- (instancetype)initWithRequest:(NSURLRequest *)request withCompletion:(NNURLConnectionCompletion)completion {
    if(!request) {
        return nil;
    }
    if(self = [super init]) {
        self.request = request;
        self.completionBlock = completion;
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)url {
    return [self initWithURL: url withCompletion: nil];
}
- (instancetype)initWithURL:(NSURL *)url withCompletion:(NNURLConnectionCompletion)completion {
    return [self initWithURL: url withMethod: NNHTTPMethodGET withCompletion: completion];
}

- (instancetype)initWithURL:(NSURL *)url withMethod:(NNHTTPMethod)method withCompletion:(NNURLConnectionCompletion)completion {
    return [self initWithURL: url withParameters: nil withMethod: method withCompletion: completion];
}

- (instancetype)initWithURL:(NSURL *)url
             withParameters:(NSDictionary *)params
                 withMethod:(NNHTTPMethod)method
             withCompletion:(NNURLConnectionCompletion)completion {
    return [self initWithURL: url withHeaders: nil withParams: params withMethod: method withCompletion: completion];
}

- (instancetype)initWithURL:(NSURL *)url
                withHeaders:(NSDictionary *)headers
                 withParams:(NSDictionary *)params
                 withMethod:(NNHTTPMethod)method
             withCompletion:(NNURLConnectionCompletion)completion {
    if(!url) {
        return nil;
    }
    
    if(self = [super init]) {
        _url = url;
        self.completionBlock = completion;
        self.httpMethod = method;
        self.params = params;
        self.headers = headers;
        self.request = [[NNHTTPRequestSerializer serializer] requestWithURL: _url withMethod: _httpMethod withParams: _params withHeaders: _headers];
    }
    return self;
}

#pragma mark - Connection

- (void)start {
    if(!_request) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSURLSession *session = [NSURLSession sharedSession];
    _currentTask = [session dataTaskWithRequest: _request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
        weakSelf.data = data;
        
        NSError *retError = error;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if(!error && data) {
            weakSelf.response = httpResponse;
            NSInteger statusCode = httpResponse.statusCode;
            if(statusCode < 200 || statusCode >= 300) {
                //HTTP error, read error
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey : [NSHTTPURLResponse localizedStringForStatusCode: statusCode]};
                retError = [NSError errorWithDomain: NNURLConnectionResponseErrorDomain
                                               code: statusCode
                                           userInfo: userInfo];
            }
        }
        
        if(weakSelf.completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.completionBlock(httpResponse, data, retError);
            });
        }
    }];
    [self resume];
}

- (void)suspend {
    [_currentTask suspend];
}

- (void)resume {
    [_currentTask resume];
}

- (void)cancel {
    [_currentTask cancel];
}

@end


@implementation NNURLConnection (convinience)

+ (instancetype)connectionWithURL:(NSURL *)url {
    return [self connectionWithURL: url withCompletion: nil];
}

+ (instancetype)connectionWithURL:(NSURL *)url withCompletion:(NNURLConnectionCompletion)completion {
    return [self connectionWithURL: url withMethod: NNHTTPMethodGET withCompletion: completion];
}

+ (instancetype)connectionWithURL:(NSURL *)url withMethod:(NNHTTPMethod)method withCompletion:(NNURLConnectionCompletion)completion {
    return [self connectionWithURL: url withParameters: nil withMethod: method withCompletion: completion];
}

+ (instancetype)connectionWithURL:(NSURL *)url
                   withParameters:(NSDictionary *)params
                       withMethod:(NNHTTPMethod)method
                   withCompletion:(NNURLConnectionCompletion)completion {
    return [self connectionWithURL: url withHeaders: nil withParameters: params withMethod: method withCompletion: completion];
}

+ (instancetype)connectionWithURL:(NSURL *)url
                      withHeaders:(NSDictionary *)headers
                   withParameters:(NSDictionary *)params
                       withMethod:(NNHTTPMethod)method
                   withCompletion:(NNURLConnectionCompletion)completion {
    return [[NNURLConnection alloc] initWithURL: url withHeaders: headers withParams: params withMethod: method withCompletion: completion];
}

@end