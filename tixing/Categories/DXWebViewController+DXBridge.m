//
//  DXWebViewController+DXBridge.m
//  tixing
//
//  Created by Du Xin on 11/3/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXWebViewController+DXBridge.h"
#import "DXMacros.h"
#import "DXSoundStore.h"
#import "DXQRScannerViewController.h"

@implementation DXWebViewController (DXBridge)

#pragma mark -
#pragma mark Basic
- (void)js_actionAlert:(id)parameters
{
  NSString *message = parameters[@"message"];
  DXAlert(message).show;
}

- (void)js_actionGoBack:(id)parameters
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)js_actionAppVersion:(id)parameters
{
  NSString *callback = parameters[@"callback"];
  [self callJSFunction:callback parameters:@{@"versionNumber": DXVersionNumber, @"buildNumber": DXBuildNumber}];
}

#pragma mark - 
#pragma makr Media
- (void)js_actionPlaySound:(id)parameters
{
  NSString *fileName = parameters[@"name"];
  [[DXSoundStore sharedStore] playSound:fileName];
}

- (void)js_actionScanQRCode:(id)parameters
{
  NSString *callback = parameters[@"callback"];
  if(!callback) return;
  DXQRScannerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"QRScannerViewController"];
  [self.navigationController presentViewController:vc animated:YES completion:nil];
  vc.successBlock = ^(NSString *code){
    [self callJSFunction:callback parameters:code];
  };
}

@end
