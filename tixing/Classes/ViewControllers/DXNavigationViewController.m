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
#import <MBProgressHUD/MBProgressHUD.h>

@interface DXNavigationViewController ()
@property (nonatomic, strong) MBProgressHUD *hud;
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
    [self openWebURL:notificationURL];
  }else if ([application canOpenURL:notificationURL]) {
    [application openURL:notificationURL];
  }
}

- (void)openWebURL:(NSURL *)webURL
{
  DXWebViewController *web;
  UINavigationController *nav;
  
  //Reuse DXWebViewController
  if ([self.presentedViewController isKindOfClass:[UINavigationController class]]) {
    nav = (UINavigationController *)self.presentedViewController;
    web = (DXWebViewController *)nav.topViewController;
    web.title = @"正在加载...";
    [web LoadURL:webURL];
  }else{
    nav = [self.storyboard instantiateViewControllerWithIdentifier:@"DXWebNavigationController"];
    [self presentViewController:nav animated:YES completion:nil];
    web = (DXWebViewController *)nav.topViewController;
    web.title = @"正在加载...";
    web.showProgressBar = YES;
    web.automaticTitleDetectionEnabled = YES;
    web.URL = webURL;
  }
}

#pragma mark -
#pragma mark Accessors

- (MBProgressHUD *)hud
{
  if (!_hud) {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.opacity = 0.55f;
  }
  return _hud;
}

#pragma mark -
#pragma mark Public methods
- (void)showLoadingIndicator
{
  self.hud.transform = CGAffineTransformMakeScale(1.5, 1.5);
  [self.hud show:YES];
  [UIView animateWithDuration:0.15 animations:^{
    self.hud.transform = CGAffineTransformIdentity;
  }];
}

- (void)hideLoadingIndicator
{
  [self.hud hide:YES];
}

@end
