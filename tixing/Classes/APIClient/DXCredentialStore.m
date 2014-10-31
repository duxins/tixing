//
//  DXCredentialStore.m
//  tixing
//
//  Created by Du Xin on 10/20/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXCredentialStore.h"
#import <SSKeychain/SSKeychain.h>
#import <TMCache/TMCache.h>
#import "DXUser.h"
#import "DXMacros.h"

NSString *const TixingNotificationTokenChanged = @"TixingNotificationTokenChanged";
NSString *const TixingNotificationLogout = @"TixingNotificationLogout";
NSString *const TixingNotificationLogin = @"TixingNotificationLogin";

static NSString *const kServiceName = @"Tixing";
static NSString *const kAuthTokenKey = @"AuthToken";

static NSString *const kCurrentUserCacheKey = @"io.tixing.cache.user";

@implementation DXCredentialStore

+ (instancetype)sharedStore
{
  static id __instance;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __instance = [[self alloc] init];
  });
  
  return __instance;
}

- (BOOL)isLoggedIn
{
  return self.authToken && self.user;
}

#pragma mark -
#pragma mark Accessors

- (NSString *)authToken
{
  return [SSKeychain passwordForService:kServiceName account:kAuthTokenKey];
}

- (void)setAuthToken:(NSString *)authToken
{
  if (!authToken) {
    [SSKeychain deletePasswordForService:kServiceName account:kAuthTokenKey];
  }else if(![self.authToken isEqualToString:authToken]){
    [SSKeychain setPassword:authToken forService:kServiceName account:kAuthTokenKey];
  }
  
  DXPostNotification(TixingNotificationTokenChanged);
}

- (DXUser *)user
{
  return [[TMCache sharedCache] objectForKey:kCurrentUserCacheKey];
}

- (void)setUser:(DXUser *)user
{
  if (!user) {
    [[TMCache sharedCache] removeObjectForKey:kCurrentUserCacheKey];
  }else{
    [[TMCache sharedCache] setObject:user forKey:kCurrentUserCacheKey];
  }
}

#pragma mark -
#pragma mark Pubilc methods

- (void)userDidLogin:(DXUser *)user
{
  self.user = user;
  self.authToken = user.authToken;
  DXPostNotification(TixingNotificationLogin);
}

- (void)userDidLogout
{
  DXPostNotification(TixingNotificationLogout);
  self.user = nil;
  self.authToken = nil;
}

@end
