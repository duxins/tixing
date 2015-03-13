//
//  DXAppDelegate.m
//  tixing
//
//  Created by Xin Du on 10/6/14
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXAppDelegate.h"
#import "DXDeviceTokenStore.h"
#import "DXStartupViewController.h"
#import "UIColor+DXColor.h"
#import <Crashlytics/Crashlytics.h>
#import "DXCredentialStore.h"
#import <MTMigration/MTMigration.h>
#import "DXCredentialStore.h"

@implementation DXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [self migrate];
  [self setupLogging];
  [self setupCrashlytics];
  [self registerForNotification];
  [self customizeUI];
  
  NSDictionary *pushNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
  if (pushNotification) {
    [self application:application didReceiveRemoteNotification:pushNotification];
  }
  return YES;
}

- (void)migrate
{
  [MTMigration migrateToVersion:@"1.1.5" block:^{
    DDLogDebug(@"Migrate to version 1.1.5");
    // 修改用户缓存位置
    [[DXCredentialStore sharedStore] moveUserCacheToUserdefaults];
  }];
}

- (void)setupLogging
{
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
  [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
}

- (void)setupCrashlytics
{
#ifndef DEBUG
  [Crashlytics startWithAPIKey:@"04310f07710ec9ec8b285820ee7637ae1fe37e36"];
#endif
}

#pragma mark -
#pragma makr UI Customization
- (void)customizeUI
{
  [self.window setTintColor: [UIColor dx_tintColor]];
}

#pragma mark - 
#pragma mark Remote Notification
- (void)registerForNotification
{
  UIApplication *application = [UIApplication sharedApplication];
  //iOS 8
  if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
                                            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil];
    [application registerUserNotificationSettings: settings];
  } else { //iOS 7
    [application registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
  }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
  [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
  DDLogDebug(@"identifier=%@", identifier);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
  NSString *token = [[[deviceToken description]
                      stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                     stringByReplacingOccurrencesOfString:@" " withString:@""];
  
  DDLogDebug(@"DeviceToken = %@", token);
  [DXDeviceTokenStore sharedStore].token = token;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
  DDLogError(@"%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
  DDLogDebug(@"Notification Received: %@", userInfo);
  UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
  DXStartupViewController *vc = [nav.viewControllers firstObject];
  if (application.applicationState == UIApplicationStateActive) {
    [vc reportPushNotification:userInfo];
  }else{
    [vc openPushNotification:userInfo];
  }
}

@end
