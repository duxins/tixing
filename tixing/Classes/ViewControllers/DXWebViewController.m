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
  if (self.urlString) {
    [self loadWebView];
  }
}

- (void)loadWebView
{
  NSURL *url = [NSURL URLWithString:self.urlString];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [request setValue:@"abcd" forHTTPHeaderField:@"Auth-Token"];
  [self.webView loadRequest:request];
}

@end
