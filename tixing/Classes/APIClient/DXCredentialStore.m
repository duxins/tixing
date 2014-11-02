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
static NSString *const kLastUserCacheKey = @"io.tixing.cache.user.last";

@interface DXCredentialStore()
@property (nonatomic, strong, readwrite) NSString *lastUserName;
@end

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
    DDLogDebug(@"Delete auth token");
    [SSKeychain deletePasswordForService:kServiceName account:kAuthTokenKey];
  }else if(![self.authToken isEqualToString:authToken]){
    DDLogDebug(@"Set auth token = %@", authToken);
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
    DDLogDebug(@"Delete user cache");
    [[TMCache sharedCache] removeObjectForKey:kCurrentUserCacheKey];
  }else{
    DDLogDebug(@"Cache User = %@", user.name);
    [[TMCache sharedCache] setObject:user forKey:kCurrentUserCacheKey];
  }
}

- (NSString *)lastUserName
{
  return [[TMCache sharedCache] objectForKey:kLastUserCacheKey];
}

- (void)setLastUserName:(NSString *)lastUserName
{
  [[TMCache sharedCache] setObject:lastUserName forKey:kLastUserCacheKey];
}

#pragma mark -
#pragma mark Pubilc methods

- (void)userDidLogin:(DXUser *)user
{
  self.user = user;
  self.authToken = user.authToken;
  self.lastUserName = user.name;
  DXPostNotification(TixingNotificationLogin);
}

- (void)userDidLogout
{
  DXPostNotification(TixingNotificationLogout);
  self.user = nil;
  self.authToken = nil;
}

@end
