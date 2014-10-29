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
#import "NSDate+DXDate.h"
#import <SSPullToRefresh/SSPullToRefresh.h>
#import "DXPullToRefreshSimpleContentView.h"

@interface DXMainViewController () <SSPullToRefreshViewDelegate>
@property (nonatomic, strong) NSMutableArray *notifications;
@property (nonatomic, strong) DXPagination *pagination;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DXNotificationCell *offscreenCell;
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;

@end

@implementation DXMainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.dateFormatter = [[NSDateFormatter alloc] init];
  self.dateFormatter.dateFormat = @"yyyy-MM-dd";
  
  self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
  self.pullToRefreshView.contentView = [[DXPullToRefreshSimpleContentView alloc] init];
  
  [self setupTableView];
  [self refresh];
}

- (void)setupTableView
{
  UINib *nib = [UINib nibWithNibName:@"DXNotificationCell" bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"NotificationCell"];
  self.tableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
}

- (void)refresh
{
  [[[DXAPIClient sharedClient] retrieveNotifications] subscribeNext:^(NSDictionary *result) {
    [self.pullToRefreshView finishLoading];
    self.notifications = result[@"data"];
    self.pagination = result[@"pagination"];
    [self.tableView reloadData];
  } error:^(NSError *error) {
    [self.pullToRefreshView finishLoading];
    DDLogError(@"error:%@", error);
  }];
}

#pragma mark -
#pragma mark SSPullToRefreshDelegate
- (BOOL)pullToRefreshViewShouldStartLoading:(SSPullToRefreshView *)view
{
  return YES;
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view
{
  [self refresh];
}

- (void)pullToRefreshView:(SSPullToRefreshView *)view didUpdateContentInset:(UIEdgeInsets)contentInset
{
  if(contentInset.top == 0){
    self.tableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
  }
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
  cell.timeLabel.text = [notification.createdAt dx_timeAgoWithDateFormatter:self.dateFormatter];
  cell.serviceIconImageView.image = nil;
  [cell.serviceIconImageView setImageWithURL:notification.service.iconURL];
  return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(editingStyle == UITableViewCellEditingStyleDelete){
    DXNotification *notification = self.notifications[(NSUInteger)indexPath.row];
    [self.notifications removeObjectAtIndex:(NSUInteger)indexPath.row];
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [tableView endUpdates];
    [[[DXAPIClient sharedClient] deleteNotificationWithId:notification.notificationId] subscribeNext:^(id x) {}];
  }
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
