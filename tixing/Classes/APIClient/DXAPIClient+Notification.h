//
//  DXAPIClient+Notifications.h
//  tixing
//
//  Created by Du Xin on 10/20/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXAPIClient.h"

@interface DXAPIClient (Notification)

- (RACSignal *)retrieveNotifications;
- (RACSignal *)retrieveNotificationWithId:(NSString *)notificationId;
- (RACSignal *)deleteNotificationWithId:(NSString *)notificationId;

@end
