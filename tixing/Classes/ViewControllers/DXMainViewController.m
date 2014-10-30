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

static NSInteger const kSpacing = 5;

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
  
  [self setupTableView];
  [self refresh];
}

- (void)setupTableView
{
  UINib *nib = [UINib nibWithNibName:@"DXNotificationCardCell" bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"NotificationCell"];
  self.tableView.separatorColor = [UIColor clearColor];
  
  self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
  self.pullToRefreshView.contentView = [[DXPullToRefreshSimpleContentView alloc] init];
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

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return (NSInteger)self.notifications.count * 2 - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row % 2 == 1){
    UITableViewCell *spacingCell = [tableView dequeueReusableCellWithIdentifier:@"SpacingCell"];
    spacingCell.backgroundColor = [UIColor clearColor];
    return spacingCell;
  }
  
  DXNotificationCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell" forIndexPath:indexPath];
  DXNotification *notification = self.notifications[(NSUInteger)indexPath.row/2];
  
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
  if (indexPath.row % 2 == 1) return kSpacing;
  
  if (!self.offscreenCell) {
    // Load UITableViewCell from Nib file
    // http://stackoverflow.com/questions/540345/how-do-you-load-custom-uitableviewcells-from-xib-files
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DXNotificationCardCell" owner:self options:nil];
    self.offscreenCell = [topLevelObjects objectAtIndex:0];
  }
  
  DXNotification *notification = self.notifications[(NSUInteger)indexPath.row/2];
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
  if (indexPath.row % 2 == 1) return kSpacing;
  return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return (CGFloat)kSpacing + 3;
}

- (NSString*) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
  return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  //Hide UITableView separator
  if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
    [tableView setSeparatorInset:UIEdgeInsetsZero];
  }
  
  //iOS 8
  if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
    [tableView setLayoutMargins:UIEdgeInsetsZero];
  }
  
  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    [cell setLayoutMargins:UIEdgeInsetsZero];
  }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(editingStyle == UITableViewCellEditingStyleDelete){
    DXNotification *notification = self.notifications[(NSUInteger)indexPath.row/2];
    [self.notifications removeObject:notification];
    [tableView beginUpdates];
    //Delete notification along with the associated spacing cell.
    NSIndexPath *spacingIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    [tableView deleteRowsAtIndexPaths:@[indexPath, spacingIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [tableView endUpdates];
    [[[DXAPIClient sharedClient] deleteNotificationWithId:notification.notificationId] subscribeNext:^(id x) {}];
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
  return @"删除";
}

#pragma mark -
#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  
}

@end
