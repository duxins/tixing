//
//  NSDate+DXDate.m
//  tixing
//
//  Created by Du Xin on 10/29/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "NSDate+DXDate.h"

@implementation NSDate (DXDate)

- (NSString *)dx_timeAgoWithDateFormatter:(NSDateFormatter *)dateFormatter
{
  NSDate *now = [NSDate date];
  double ti = fabs([self timeIntervalSinceDate:now]);
  
  if (ti < 1) {
    return @"1秒钟前";
  } else if (ti < 60) {
    return [NSString stringWithFormat:@"%d秒钟前", (int)ti];
  } else if (ti < 3600) {
    int diff = (int)round(ti / 60);
    return [NSString stringWithFormat:@"%d分钟前", diff];
  } else if (ti < (24 * 3600)) {
    int diff = (int)round(ti / 60 / 60);
    return[NSString stringWithFormat:@"%d小时前", diff];
  } else if (ti < (24 * 3600 * 7)) {
    int diff = (int)round(ti / 60 / 60 / 24);
    return[NSString stringWithFormat:@"%d天前", diff];
  } else {
    return [dateFormatter stringFromDate:self];
  }
}

@end
