//
//  DXAPIClient+User.m
//  tixing
//
//  Created by Du Xin on 10/20/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXAPIClient+User.h"
#import "DXCredentialStore.h"
#import <Mantle/Mantle.h>
#import "DXUser.h"

@implementation DXAPIClient (User)

- (RACSignal *)loginWithName:(NSString *)name password:(NSString *)password
{
  return [[[self POST:@"login" parameters:@{@"name": name, @"password": password}]
          tryMap:^id(NSDictionary *result, NSError *__autoreleasing *errorPtr) {
            return [MTLJSONAdapter modelOfClass:[DXUser class] fromJSONDictionary:result error:errorPtr];
          }] doNext:^(DXUser *user) {
           DDLogDebug(@"Login successfully.");
           [[DXCredentialStore sharedStore] userDidLogin:user];
          }];
}

- (RACSignal *)signupWithName:(NSString *)name password:(NSString *)password
{
  return [[[self POST:@"signup" parameters:@{@"name": name, @"password": password}]
          tryMap:^id(NSDictionary *result, NSError *__autoreleasing *errorPtr) {
            return [MTLJSONAdapter modelOfClass:[DXUser class] fromJSONDictionary:result error:errorPtr];
          }] doNext:^(DXUser *user) {
             DDLogDebug(@"Signup successfully.");
             [[DXCredentialStore sharedStore] userDidLogin:user];
          }];
}

- (RACSignal *)retrieveMyInfo
{
  return [self GET:@"user" parameters:nil];
}

- (RACSignal *)updateCustomSound:(NSString *)sound
{
  return [self PUT:@"user/sound"
        parameters:@{ @"sound": sound } ];
}

- (RACSignal *)keepSilentAtNight:(BOOL)silent
{
  if (silent) {
    return [self PUT:@"user/silence_at_night" parameters:@{}];
  }else{
    return [self DELETE:@"user/silence_at_night" parameters:@{}];
  }
}

@end
