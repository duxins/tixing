//
//  DXWebViewController.m
//  tixing
//
//  Created by Du Xin on 10/24/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXWebViewController.h"

@interface DXWebViewController ()
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end

@implementation DXWebViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  if (self.URL) {
    [self loadWebView];
  }
}

- (void)loadWebView
{
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.URL];
  [request setValue:@"abcd" forHTTPHeaderField:@"Auth-Token"];
  [self.webView loadRequest:request];
}

@end
