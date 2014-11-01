//
//  DXWebViewController.m
//  tixing
//
//  Created by Du Xin on 10/24/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXWebViewController.h"

@interface DXWebViewController () <UIWebViewDelegate>
@end

@implementation DXWebViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.buildBridge = NO;
}

- (void)loadLocalFile:(NSString *)fileName replacements:(NSDictionary *)replacements
{
  NSURL *URL = [[NSBundle mainBundle] URLForResource:fileName withExtension:@""];
  
  __block NSString *HTMLString = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:nil];
  
  [replacements enumerateKeysAndObjectsUsingBlock:^(NSString *pattern, NSString *replacement, BOOL *stop) {
    HTMLString = [HTMLString stringByReplacingOccurrencesOfString:pattern withString:replacement];
  }];
  
  [self.webView loadHTMLString:HTMLString baseURL:nil];
}

@end
