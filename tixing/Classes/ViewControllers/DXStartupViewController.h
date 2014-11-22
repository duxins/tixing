//
//  DXStartupViewController.h
//  tixing
//
//  Created by Du Xin on 10/30/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXStartupViewController : UIViewController

@property (nonatomic, copy) NSString *notificationId;

- (void)reportPushNotification:(NSDictionary *)userInfo;
- (void)openPushNotification:(NSDictionary *)userInfo;

@end
