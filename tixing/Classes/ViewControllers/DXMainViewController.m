//
//  DXMainViewController.m
//  tixing
//
//  Created by Du Xin on 10/21/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXMainViewController.h"
#import "DXAPIClient.h"
#import "DXNotificationViewController.h"

@interface DXMainViewController ()
@property (nonatomic, copy) NSArray *notifications;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DXMainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[[DXAPIClient sharedClient] retrieveNotifications] subscribeNext:^(id x) {
    self.notifications = x[@"data"];
    [self.tableView reloadData];
  } error:^(NSError *error) {
    DDLogError(@"error:%@", error);
  }];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return (NSInteger)self.notifications.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell" forIndexPath:indexPath];
  NSDictionary *notification = self.notifications[(NSUInteger)indexPath.row];
  cell.textLabel.text = notification[@"message"];
  return cell;
}


#pragma mark -
#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"ShowNotification"]) {
    UITableViewCell *cell = (UITableViewCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *notification = self.notifications[(NSUInteger)indexPath.row];
    DXNotificationViewController *vc = segue.destinationViewController;
    vc.notification = notification;
  }
}



@end
