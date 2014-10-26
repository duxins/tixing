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
  NSInteger deviceTimezone = [[NSTimeZone localTimeZone] secondsFromGMT] / 3600;
  
  return [self PUT:@"devices"
        parameters:@{
                     @"name": deviceName,
                     @"token": deviceToken,
                     @"timezone": @(deviceTimezone)
                     }];
}

- (RACSignal *)revokeDeviceToken:(NSString *)deviceToken
{
  return [self DELETE:@"devices"
           parameters:@{
                        @"token": deviceToken
                        }];
}
@end
