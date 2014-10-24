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

@interface DXServiceDetailViewController ()
@property(nonatomic, weak) IBOutlet UIWebView *webView;
@end

@implementation DXServiceDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self loadWebView];
}

- (void)loadWebView
{
  NSURL *URL = self.service.URL;
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
  [request setValue:@"abcd" forHTTPHeaderField:@"Auth-Token"];
  [self.webView loadRequest:request];
}

- (IBAction)uninstallService:(id)sender {
  NSString *message = [NSString stringWithFormat:@"是否确认卸载\"%@\"?", self.service.name];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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

@end
