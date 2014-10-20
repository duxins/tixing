//
//  DXCredentialStore.m
//  tixing
//
//  Created by Du Xin on 10/20/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXCredentialStore.h"
#import <SSKeychain/SSKeychain.h>

NSString *const TixingNotificationTokenChanged = @"TixingNotificationTokenChanged";

static NSString *const kServiceName = @"Tixing";
static NSString *const kAuthTokenKey = @"AuthToken";

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
  }else{
    [SSKeychain setPassword:authToken forService:kServiceName account:kAuthTokenKey];
  }
  
  DDLogDebug(@"Set authtoken: %@", authToken);
  [[NSNotificationCenter defaultCenter] postNotificationName:TixingNotificationTokenChanged
                                                      object:self
                                                    userInfo:nil];
}


@end
