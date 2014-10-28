//
//  DXNotificationViewController.m
//  tixing
//
//  Created by Du Xin on 10/21/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXNotificationViewController.h"
#import "DXNotification.h"

@interface DXNotificationViewController ()

@property (weak, nonatomic) IBOutlet UITextView *notificationMessage;
@end

@implementation DXNotificationViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  if (self.notification) {
    self.notificationMessage.text = self.notification.message;
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
