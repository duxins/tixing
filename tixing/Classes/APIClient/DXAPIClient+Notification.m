//
//  DXAPIClient+Notifications.m
//  tixing
//
//  Created by Du Xin on 10/20/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXAPIClient+Notification.h"
#import "DXNotification.h"
#import "DXPagination.h"

@implementation DXAPIClient (Notification)

- (RACSignal *)retrieveNotifications
{
  return [[self GET:@"notifications" parameters:nil] tryMap:^id(NSDictionary *result, NSError *__autoreleasing *errorPtr) {
    NSError *error;
    
    NSArray *notifications = [MTLJSONAdapter modelsOfClass:[DXNotification class] fromJSONArray:result[@"data"] error:&error];
    if (!notifications) { return nil; }
    
    NSDictionary *pagination = [MTLJSONAdapter modelOfClass:[DXPagination class] fromJSONDictionary:result[@"pagination"] error:&error];
    if (!pagination) { return nil; }
    
    return @{ @"data": notifications, @"pagination": pagination };
    
  }];
}

- (RACSignal *)retrieveNotificationWithId:(NSString *)notificationId
{
  NSString *urlString = [NSString stringWithFormat:@"notifications/%@", notificationId];
  return [[self GET:urlString parameters:nil]
          tryMap:^id(id value, NSError *__autoreleasing *errorPtr) {
            return [MTLJSONAdapter modelOfClass:[DXNotification class] fromJSONDictionary:value error:errorPtr];
          }];
}

- (RACSignal *)deleteNotificationWithId:(NSString *)notificationId
{
  NSString *urlString = [NSString stringWithFormat:@"notifications/%@", notificationId];
  return [self DELETE:urlString parameters:nil];
}

- (RACSignal *)clearNotificationsUntil:(NSString *)notificationId
{
  if (!notificationId) { return [RACSignal empty]; }
  return [self DELETE:@"notifications" parameters:@{@"until": notificationId}];
}

@end
