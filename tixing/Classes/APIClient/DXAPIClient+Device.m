//
//  DXAPIClient+Device.m
//  tixing
//
//  Created by Du Xin on 10/20/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXAPIClient+Device.h"

@implementation DXAPIClient (Device)

- (RACSignal *)updateDeviceToken:(NSString *)deviceToken
{
  NSString *deviceName = [[UIDevice currentDevice] name];
  return [self PUT:@"devices"
        parameters:@{
                     @"name": deviceName,
                     @"token": deviceToken
                     }];
}

@end
