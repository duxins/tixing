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
  NSString *version = [NSString stringWithFormat:@"%@ build %@", DXVersionNumber, DXBuildNumber];
  [self loadLocalFile:@"about.html" replacements:@{@"#{VERSION}": version}];
}


@end
