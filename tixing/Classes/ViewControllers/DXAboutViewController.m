//
//  DXAboutViewController.m
//  tixing
//
//  Created by Du Xin on 10/27/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXAboutViewController.h"
#import "DXMacros.h"

@interface DXAboutViewController ()

@end

@implementation DXAboutViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSURL *URL = [[NSBundle mainBundle] URLForResource:@"about" withExtension:@"html"];
  NSString *HTMLString = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:nil];
  
  NSString *version = [NSString stringWithFormat:@"%@ build %@", DXVersionNumber, DXBuildNumber];
  
  HTMLString = [HTMLString stringByReplacingOccurrencesOfString:@"#{VERSION}" withString:version];
  
  [self.webView loadHTMLString:HTMLString baseURL:nil];
  
}


@end
