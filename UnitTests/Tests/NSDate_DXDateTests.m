//
//  NSDate_DXDateTests.m
//  tixing
//
//  Created by Du Xin on 12/16/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXTestHelper.h"
#import "NSDate+DXDate.h"

SpecBegin(NSDate_DXDate)

describe(@"dx_timeAgoWithDateFormatter", ^{
  it(@"should calculate correctly", ^{
    NSDate *now = [NSDate date];
    NSDate *twoSecondsAgo = [now dateByAddingTimeInterval: -2];
    NSDate *twoMinutesAgo = [now dateByAddingTimeInterval: -2 * 60];
    NSDate *twoHoursAgo = [now dateByAddingTimeInterval: -2 * 3600];
    NSDate *twoDaysAgo = [now dateByAddingTimeInterval: -2 * 3600 * 24];
    NSDate *sixDaysAgo = [now dateByAddingTimeInterval: -6 * 3600 * 24];
    NSDate *sevenDaysAgo = [now dateByAddingTimeInterval: -7 * 3600 * 24];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    
    expect([twoSecondsAgo dx_timeAgoWithDateFormatter:formatter]).to.equal(@"2秒钟前");
    expect([twoMinutesAgo dx_timeAgoWithDateFormatter:formatter]).to.equal(@"2分钟前");
    expect([twoHoursAgo dx_timeAgoWithDateFormatter:formatter]).to.equal(@"2小时前");
    expect([twoDaysAgo dx_timeAgoWithDateFormatter:formatter]).to.equal(@"2天前");
    expect([sixDaysAgo dx_timeAgoWithDateFormatter:formatter]).to.equal(@"6天前");
    expect([sevenDaysAgo dx_timeAgoWithDateFormatter:formatter]).to.equal([formatter stringFromDate:sevenDaysAgo]);
  });
});

SpecEnd
