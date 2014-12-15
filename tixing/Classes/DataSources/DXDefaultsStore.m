//
//  DXDefaultsStore.m
//  tixing
//
//  Created by Du Xin on 12/15/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXDefaultsStore.h"
#import "DXUser.h"
#import "DXCredentialStore.h"

static NSString *const kAutoOpenLinkKey = @"auto_open_link";

@implementation DXDefaultsStore

+ (NSDictionary *)defaultDict
{
  return @{kAutoOpenLinkKey: @(YES)};
}

+ (void)setObject:(id)object forKey:(NSString *)key
{
  NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] objectForKey:[self currentUserId]] mutableCopy];
  
  if (!dict) {
    dict = [[NSMutableDictionary alloc] initWithCapacity:10];
  }
  
  dict[key] = object;
  
  [[NSUserDefaults standardUserDefaults] setObject:dict forKey:[self currentUserId]];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectForKey:(NSString *)key
{
  NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:[self currentUserId]];
  id object = [dict objectForKey:key];
  if (object != nil) return object;
  return [self defaultDict][key];
}

+ (void)removeCurrentUser
{
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self currentUserId]];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)currentUserId
{
  DXUser *currentUser = [DXCredentialStore sharedStore].user;
  return [NSString stringWithFormat:@"user:%@", currentUser.userId];
}

#pragma mark -
#pragma mark Settings

+ (BOOL)autoOpenNotificationLinkEnabled
{
  return [[self objectForKey:kAutoOpenLinkKey] boolValue];
}

+ (void)setAutoOpenNotificationLinkEnabled:(BOOL)enabled
{
  [self setObject:@(enabled) forKey:kAutoOpenLinkKey];
}

@end
