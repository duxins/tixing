//
//  DXNotificationViewController.h
//  tixing
//
//  Created by Du Xin on 10/21/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXNotification;

@interface DXNotificationViewController : UIViewController

@property (nonatomic, strong) DXNotification *notification;
@property (nonatomic, assign) BOOL autoOpen;

@end
