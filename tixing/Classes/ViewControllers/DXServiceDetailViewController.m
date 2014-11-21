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
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) BOOL hasLoaded;
@end

@implementation DXServiceDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadWebView];
  self.title = self.service.name;
  self.buildBridge = YES;
  self.hasLoaded = NO;
}

- (void)dealloc
{
  [self.timer invalidate];
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

- (void)webViewDidStartLoad:(UIWebView *)webView
{
  if (!self.hasLoaded) { //first time
    self.timer = [NSTimer scheduledTimerWithTimeInterval:15.0 target:self selector:@selector(retryLoading) userInfo:nil repeats:NO];
  }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  [super webViewDidFinishLoad:webView];
  [self.timer invalidate];
  self.hasLoaded = YES;
  self.loadingIndicator.hidden = YES;
}

- (void)retryLoading
{
  [self.webView stopLoading];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"服务加载失败，请点击重试" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
  [alert show];
  [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *index) {
    if (index.integerValue == 1) { //retry
      [self loadWebView];
    }else{
      [self.navigationController popViewControllerAnimated:YES];
    }
  }];
}

#pragma mark -
#pragma mark JS Bridge
- (void)js_actionUninstallService:(id)parameters
{
  [self uninstallService:nil];
}

@end
