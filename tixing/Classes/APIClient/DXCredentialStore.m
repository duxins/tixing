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

NSString *const TixingNotificationTokenChanged = @"TixingNotificationTokenChanged";
NSString *const TixingNotificationLogout = @"TixingNotificationLogout";

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
  return self.authToken != nil;
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
    DDLogDebug(@"Delete authtoken");
    [[NSNotificationCenter defaultCenter] postNotificationName:TixingNotificationLogout
                                                      object:self
                                                    userInfo:nil];
  }else if(![self.authToken isEqualToString:authToken]){
    DDLogDebug(@"Set authtoken: %@", authToken);
    [SSKeychain setPassword:authToken forService:kServiceName account:kAuthTokenKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:TixingNotificationTokenChanged
                                                      object:self
                                                    userInfo:nil];
  }
}

- (DXUser *)user
{
  return [[TMCache sharedCache] objectForKey:kCurrentUserCacheKey];
}

- (void)setUser:(DXUser *)user
{
  if (!user) {
    self.authToken = nil;
    [[TMCache sharedCache] removeObjectForKey:kCurrentUserCacheKey];
  }else{
    self.authToken = user.authToken;
    [[TMCache sharedCache] setObject:user forKey:kCurrentUserCacheKey];
  }
}

- (void)saveUser
{
  DXUser *user = self.user;
  [[TMCache sharedCache] setObject:user forKey:kCurrentUserCacheKey];
}

@end
