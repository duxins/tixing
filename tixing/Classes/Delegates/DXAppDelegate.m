//
//  DXAppDelegate.m
//  tixing
//
//  Created by Xin Du on 10/6/14
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXAppDelegate.h"

@implementation DXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [self setupLogging];
  return YES;
}

- (void)setupLogging
{
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
  [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
}

@end
