//
//  DXDefaultsStoreTests.m
//  tixing
//
//  Created by Du Xin on 12/16/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXTestHelper.h"
#import "DXDefaultsStore.h"
#import "DXCredentialStore.h"
#import "DXUser.h"
#import <Mantle/Mantle.h>

SpecBegin(DXDefaultsStore)

DXUser *user1 = [MTLJSONAdapter modelOfClass:[DXUser class] fromJSONDictionary:@{@"id": @"1"} error:nil];
DXUser *user2 = [MTLJSONAdapter modelOfClass:[DXUser class] fromJSONDictionary:@{@"id": @"2"} error:nil];

beforeEach(^{
  NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
  [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
});

describe(@"-setObject:forKey", ^{
  it(@"works correctly", ^{
    [DXCredentialStore sharedStore].user = user1;
    [DXDefaultsStore setObject:@"1" forKey:@"a"];
    expect([DXDefaultsStore objectForKey:@"a"]).to.equal(@"1");
  });
  
  it(@"stores defaults separately", ^{
    [DXCredentialStore sharedStore].user = user1;
    [DXDefaultsStore setObject:@"1" forKey:@"a"];
    expect([DXDefaultsStore objectForKey:@"a"]).to.equal(@"1");
    
    [DXCredentialStore sharedStore].user = user2;
    expect([DXDefaultsStore objectForKey:@"a"]).to.beNil();
  });
});

describe(@"-removeCurrentUser", ^{
  it(@"removes defaults of the current user", ^{
    [DXCredentialStore sharedStore].user = user1;
    [DXDefaultsStore setObject:@"1" forKey:@"a"];
    expect([DXDefaultsStore objectForKey:@"a"]).to.equal(@"1");
    [DXDefaultsStore removeCurrentUser];
    expect([DXDefaultsStore objectForKey:@"a"]).to.beNil();
  });
});

describe(@"-autoOpenNotificationLinkEnabled", ^{
  it(@"returns YES when there is no defaults", ^{
    expect([DXDefaultsStore autoOpenNotificationLinkEnabled]).to.beTruthy();
    [DXDefaultsStore setAutoOpenNotificationLinkEnabled:NO];
    expect([DXDefaultsStore autoOpenNotificationLinkEnabled]).to.beFalsy();
  });
});

SpecEnd
