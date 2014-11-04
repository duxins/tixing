//
//  DXServiceDetailViewController.m
//  tixing
//
//  Created by Du Xin on 10/24/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXServiceDetailViewController.h"
#import "DXService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "DXAPIClient.h"
#import "DXMacros.h"
#import "DXCredentialStore.h"

@interface DXServiceDetailViewController ()
@property(nonatomic, weak) IBOutlet UIWebView *webView;
@end

@implementation DXServiceDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadWebView];
  self.title = self.service.name;
  self.buildBridge = YES;
}

- (void)loadWebView
{
  NSURL *URL = self.service.URL;
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
  NSString *authToken = [DXCredentialStore sharedStore].authToken;
  [request addValue:authToken forHTTPHeaderField:@"AUTHTOKEN"];
  [self.webView loadRequest:request];
}

- (IBAction)uninstallService:(id)sender {
  NSString *message = [NSString stringWithFormat:@"删除\"%@\"后，将不再收到其发送的提醒", self.service.name];
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                  message:message
                                                 delegate:nil
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"删除", nil];
  [alert show];
  
  [[[[alert rac_buttonClickedSignal] filter:^BOOL(NSNumber *index) {
    return [index integerValue] == 1;
  }] flattenMap:^RACStream *(id value) {
    return [[DXAPIClient sharedClient] uninstallServiceWithId:self.service.serviceId];
  }] subscribeNext:^(id x) {
    if (self.uninstallBlock) {
      self.uninstallBlock();
    }
  } error:^(NSError *error) {
    DDLogError(@"%@", error);
  }];
}

#pragma mark -
#pragma mark JS Bridge
- (void)js_actionUninstallService:(id)parameters
{
  [self uninstallService:nil];
}

@end
