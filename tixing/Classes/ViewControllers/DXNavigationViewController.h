//
//  DXNavigationViewController.h
//  tixing
//
//  Created by Du Xin on 12/15/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DXNotification;

@interface DXNavigationViewController : UINavigationController

- (void)openNotification:(DXNotification *)notification;
- (void)openURLforNotification:(DXNotification *)notification;

@end
