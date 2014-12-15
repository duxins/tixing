//
//  DXNavigationViewController.m
//  tixing
//
//  Created by Du Xin on 12/15/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXNavigationViewController.h"
#import "DXNotification.h"
#import "DXDefaultsStore.h"
#import "DXWebViewController.h"
#import "DXNotificationViewController.h"

@interface DXNavigationViewController ()

@end

@implementation DXNavigationViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)openNotification:(DXNotification *)notification{
  if (notification.autoOpen && [DXDefaultsStore autoOpenNotificationLinkEnabled]) {
    [self openURLforNotification:notification];
  }else{
    DXNotificationViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DXNotificationViewController"];
    vc.notification = notification;
    [self pushViewController:vc animated:YES];
  }
}

- (void)openURLforNotification:(DXNotification *)notification {
  UIApplication *application = [UIApplication sharedApplication];
  NSURL *notificationURL;
  
  if ([application canOpenURL:notification.URL]) {
    notificationURL = notification.URL;
  }else if([application canOpenURL:notification.webURL]){
    notificationURL = notification.webURL;
  }
  
  if (!notificationURL) return;
  
  NSString *scheme = notificationURL.scheme;
  
  if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
    DXWebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DXWebViewController"];
    vc.URL = notificationURL;
    vc.title = notification.title;
    [self pushViewController:vc animated:YES];
  }else if ([application canOpenURL:notificationURL]) {
    [application openURL:notificationURL];
  }
}

@end
