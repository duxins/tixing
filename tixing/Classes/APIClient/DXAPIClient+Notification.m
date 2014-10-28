//
//  DXAPIClient+Notifications.m
//  tixing
//
//  Created by Du Xin on 10/20/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXAPIClient+Notification.h"
#import "DXNotification.h"

@implementation DXAPIClient (Notification)

- (RACSignal *)retrieveNotifications
{
  return [[self GET:@"notifications" parameters:nil] tryMap:^id(NSDictionary *result, NSError *__autoreleasing *errorPtr) {
    NSError *error;
    NSArray *notifications = [MTLJSONAdapter modelsOfClass:[DXNotification class] fromJSONArray:result[@"data"] error:&error];
    if (!notifications) {
      return nil;
    }
    
    return @{ @"data": notifications };
    
  }];
}

- (RACSignal *)retrieveNotificationWithId:(NSString *)notificationId
{
  NSString *urlString = [NSString stringWithFormat:@"notifications/%@", notificationId];
  return [self GET:urlString parameters:nil];
}

- (RACSignal *)deleteNotificationWithId:(NSString *)notificationId
{
  NSString *urlString = [NSString stringWithFormat:@"notifications/%@", notificationId];
  return [self DELETE:urlString parameters:nil];
}

@end
