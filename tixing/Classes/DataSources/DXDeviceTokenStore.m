//
//  DXDeviceTokenStore.m
//  tixing
//
//  Created by Du Xin on 10/25/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXDeviceTokenStore.h"
#import "DXCredentialStore.h"
#import "DXAPIClient.h"

static NSString *const kDeviceTokenKey = @"TixingDeviceToken";

@implementation DXDeviceTokenStore

+ (instancetype)sharedStore
{
  static id __instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __instance = [self new];
  });
  return __instance;
}

- (id)init
{
  self = [super init];
  if(self){
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncDeviceToken) name:TixingNotificationLogin object:nil];
  }
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)syncDeviceToken
{
  NSString *deviceToken = self.token;
  if (deviceToken) {
    [[[DXAPIClient sharedClient] updateDeviceToken:deviceToken] subscribeNext:^(id x) {}];
  }
}

- (void)revokeDeviceTokenWithCompletionHandler:(void (^)())completion
{
  NSString *deviceToken = self.token;
  if (!deviceToken) {
    completion();
    return;
  }
  
  [[[DXAPIClient sharedClient] revokeDeviceToken:deviceToken] subscribeNext:^(id x) {
    completion();
  }error:^(NSError *error) {
    completion();
  }];
}

#pragma mark - 
#pragma mark - Accessors
- (void)setToken:(NSString *)token
{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setObject:token forKey:kDeviceTokenKey];
  [userDefaults synchronize];
  if ([DXCredentialStore sharedStore].isLoggedIn) {
    [self syncDeviceToken];
  }
}

- (NSString *)token
{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  return [userDefaults objectForKey:kDeviceTokenKey];
}

@end
