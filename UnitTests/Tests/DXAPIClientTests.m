//
//  DXAPIClientTests.m
//  tixing
//
//  Created by Du Xin on 12/16/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXTestHelper.h"
#import "DXAPIClient.h"
#import "DXCredentialStore.h"

#define MOCK_API_URL @"http://mock.api"

SpecBegin(DXAPIClient)

[OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
  return [[request.URL absoluteString] isEqualToString:MOCK_API_URL];
} withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
  NSDictionary* response = @{@"headers":request.allHTTPHeaderFields, @"method": request.HTTPMethod};
  return [OHHTTPStubsResponse responseWithJSONObject:response statusCode:200 headers:nil];
}];

describe(@"DXAPIClient", ^{
  __block DXAPIClient *client;
  
  beforeAll(^{
    client = [DXAPIClient sharedClient];
  });
  
  describe(@"+sharedClient", ^{
    it(@"works correctly", ^{
      expect(client).to.beIdenticalTo([DXAPIClient sharedClient]);
    });
  });
  
  it(@"has correct user agent", ^{
    __block id blockNextObject;
    [[[DXAPIClient sharedClient] GET:MOCK_API_URL parameters:nil] subscribeNext:^(id x) {
      blockNextObject = x;
    }];
    expect(blockNextObject[@"headers"][@"User-Agent"]).will.beTruthy();
    expect(blockNextObject[@"headers"][@"User-Agent"]).will.match(@"^tixing/\\d\\.\\d\\.\\d\\.(\\d+) ");
  });
    
  it(@"can set auth token header automatically", ^{
    
    NSString *authToken = @"923de4bd95508e078c82b4311abafbeb13068711";
    
    expect(^{
      [DXCredentialStore sharedStore].authToken = authToken;
    }).notify(TixingNotificationTokenChanged);
    
    __block id blockNextObject;
    [[[DXAPIClient sharedClient] GET:MOCK_API_URL parameters:nil] subscribeNext:^(id x) {
      blockNextObject = x;
    }];
    expect(blockNextObject[@"headers"][@"Auth-Token"]).will.equal(authToken);
    
    // Remove auth token
    [DXCredentialStore sharedStore].authToken = nil;
    [[[DXAPIClient sharedClient] GET:MOCK_API_URL parameters:nil] subscribeNext:^(id x) { blockNextObject = x; }];
    expect(blockNextObject[@"headers"][@"Auth-Token"]).will.beNil();
    
  });
  
  it(@"can make GET HTTP request", ^{
    __block id blockNextObject;
    [[[DXAPIClient sharedClient] GET:MOCK_API_URL parameters:nil] subscribeNext:^(id x) { blockNextObject = x; }];
    expect(blockNextObject[@"method"]).will.equal(@"GET");
  });
  
  it(@"can make POST HTTP request", ^{
    __block id blockNextObject;
    [[[DXAPIClient sharedClient] POST:MOCK_API_URL parameters:nil] subscribeNext:^(id x) { blockNextObject = x; }];
    expect(blockNextObject[@"method"]).will.equal(@"POST");
  });
  
  it(@"can make PATCH HTTP request", ^{
    __block id blockNextObject;
    [[[DXAPIClient sharedClient] PATCH:MOCK_API_URL parameters:nil] subscribeNext:^(id x) { blockNextObject = x; }];
    expect(blockNextObject[@"method"]).will.equal(@"PATCH");
  });
  
  it(@"can make PUT HTTP request", ^{
    __block id blockNextObject;
    [[[DXAPIClient sharedClient] PUT:MOCK_API_URL parameters:nil] subscribeNext:^(id x) { blockNextObject = x; }];
    expect(blockNextObject[@"method"]).will.equal(@"PUT");
  });
  
  it(@"can make DELETE HTTP request", ^{
    __block id blockNextObject;
    [[[DXAPIClient sharedClient] DELETE:MOCK_API_URL parameters:nil] subscribeNext:^(id x) { blockNextObject = x; }];
    expect(blockNextObject[@"method"]).will.equal(@"DELETE");
  });
  
});

SpecEnd
