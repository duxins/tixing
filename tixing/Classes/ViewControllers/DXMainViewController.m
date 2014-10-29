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
#import "DXNotification.h"
#import "DXNotificationCell.h"
#import "DXPagination.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface DXMainViewController ()
@property (nonatomic, strong) NSArray *notifications;
@property (nonatomic, strong) DXPagination *pagination;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DXNotificationCell *offscreenCell;
@end

@implementation DXMainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UINib *nib = [UINib nibWithNibName:@"DXNotificationCell" bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"NotificationCell"];
  self.tableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
  [self refresh];
}

- (void)refresh
{
  [[[DXAPIClient sharedClient] retrieveNotifications] subscribeNext:^(NSDictionary *result) {
    self.notifications = result[@"data"];
    self.pagination = result[@"pagination"];
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
  DXNotificationCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell" forIndexPath:indexPath];
  DXNotification *notification = self.notifications[(NSUInteger)indexPath.row];
  cell.messageLabel.text = notification.message;
  return cell;
}

#pragma mark -
#pragma mark Tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ((NSUInteger)indexPath.row >= self.notifications.count) {
    return 88;
  }
  
  if (!self.offscreenCell) {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DXNotificationCell" owner:self options:nil];
    self.offscreenCell = [topLevelObjects objectAtIndex:0];
  }
  
  DXNotification *notification = self.notifications[(NSUInteger)indexPath.row];
  self.offscreenCell.messageLabel.text = notification.message;
  
  [self.offscreenCell setNeedsUpdateConstraints];
  [self.offscreenCell updateConstraintsIfNeeded];
  self.offscreenCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(self.offscreenCell.bounds));
  [self.offscreenCell setNeedsLayout];
  [self.offscreenCell layoutIfNeeded];
  
  CGFloat height = [self.offscreenCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  return height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 1.0f;
}

- (NSString*) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  return nil;
}

#pragma mark -
#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"ShowNotification"]) {
    UITableViewCell *cell = (UITableViewCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    DXNotification *notification = self.notifications[(NSUInteger)indexPath.row];
    DXNotificationViewController *vc = segue.destinationViewController;
    vc.notification = notification;
  }
}

@end
