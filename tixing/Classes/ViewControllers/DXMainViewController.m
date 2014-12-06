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
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+DXDate.h"
#import <SSPullToRefresh/SSPullToRefresh.h>
#import "DXPullToRefreshSimpleContentView.h"
#import "DXProgressHUD.h"
#import "NSString+DXString.h"
#import <EXTScope.h>

static NSInteger const kSpacing = 5;

@interface DXMainViewController () <SSPullToRefreshViewDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *notifications;
@property (nonatomic, strong) DXPagination *pagination;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSMutableDictionary *heightsCache;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *notFoundMessageLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearButton;

@property (nonatomic, strong) DXNotificationCell *offscreenCell;
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;

@property (nonatomic, strong) UIActionSheet *actionSheet;

@end

@implementation DXMainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.dateFormatter = [[NSDateFormatter alloc] init];
  self.dateFormatter.dateFormat = @"yyyy-MM-dd";
  self.heightsCache = [[NSMutableDictionary alloc] init];
  
  @weakify(self);
  [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil] subscribeNext:^(id x) {
    @strongify(self);
    if (self.actionSheet) {
      [self.actionSheet dismissWithClickedButtonIndex:0 animated:NO];
    }
  }];
  
  [self setupTableView];
  [self refresh];
}

- (void)loadNotification:(NSString *)notificationId
{
  [[[DXAPIClient sharedClient] retrieveNotificationWithId:notificationId]
   subscribeNext:^(DXNotification *notification) {
    notification.autoOpen = YES;
    [self performSegueWithIdentifier:@"ShowNotification" sender:notification];
  }];
}

- (void)setupTableView
{
  UINib *nib = [UINib nibWithNibName:@"DXNotificationCardCell" bundle:nil];
  [self.tableView registerNib:nib forCellReuseIdentifier:@"NotificationCell"];
  self.tableView.separatorColor = [UIColor clearColor];
  
  self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
  self.pullToRefreshView.contentView = [[DXPullToRefreshSimpleContentView alloc] init];
  
  UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
  longPressGesture.minimumPressDuration = 0.7;
  longPressGesture.delegate = self;
  [self.tableView addGestureRecognizer:longPressGesture];
}

- (void)refresh
{
  [[[DXAPIClient sharedClient] retrieveNotifications] subscribeNext:^(NSDictionary *result) {
    [self.pullToRefreshView finishLoading];
    self.notifications = result[@"data"];
    
    [self.loadingIndicator stopAnimating];
    self.loadingView.hidden = self.notifications.count != 0;
    self.clearButton.enabled = self.notifications.count != 0;
    self.notFoundMessageLabel.hidden = self.loadingView.hidden;
    self.heightsCache = [[NSMutableDictionary alloc] init];
    
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
  
  cell.titleLabel.text = notification.title;
  if (notification.highlight) {
    cell.messageLabel.attributedText = [notification.message dx_highlightWithString:notification.highlight];
  }else{
    cell.messageLabel.text = notification.message;
  }
  cell.timeLabel.text = [notification.createdAt dx_timeAgoWithDateFormatter:self.dateFormatter];
  [cell.thumbImageView sd_setImageWithURL:notification.thumbURL placeholderImage:[UIImage imageNamed:@"placeholder"] options:0];
  return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row % 2 == 1) return kSpacing;
  DXNotification *notification = [self notificationForIndexPath:indexPath];
  
  if (self.heightsCache[notification]){
    return [self.heightsCache[notification] floatValue];
  }
  
  if (!self.offscreenCell) {
    // Load UITableViewCell from Nib file
    // http://stackoverflow.com/questions/540345/how-do-you-load-custom-uitableviewcells-from-xib-files
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DXNotificationCardCell" owner:self options:nil];
    self.offscreenCell = [topLevelObjects objectAtIndex:0];
  }
  
  self.offscreenCell.messageLabel.text = notification.message;
  
  [self.offscreenCell setNeedsUpdateConstraints];
  [self.offscreenCell updateConstraintsIfNeeded];
  self.offscreenCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(self.offscreenCell.bounds));
  [self.offscreenCell setNeedsLayout];
  [self.offscreenCell layoutIfNeeded];
  
  CGFloat height = [self.offscreenCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  self.heightsCache[notification] = @(height + 1);
  
  return [self.heightsCache[notification] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row % 2 == 1) return kSpacing;
  DXNotification *notification = [self notificationForIndexPath:indexPath];
  if (self.heightsCache[notification]){
    return [self.heightsCache[notification] floatValue];
  }
  return 90;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
  CGPoint p = [gestureRecognizer locationInView:self.tableView];
  
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
  
  if (!indexPath || indexPath.row % 2 == 1) { return; }
  
  if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@"复制提醒内容", nil];
    [self.actionSheet showInView:self.tableView];
    @weakify(self);
    [[self.actionSheet rac_buttonClickedSignal] subscribeNext:^(NSNumber* x) {
      @strongify(self);
      NSInteger index = [x integerValue];
      switch (index) {
        case 0: //delete
          [self deleteNotificationAtIndexPath:indexPath];
          break;
        case 1: //copy
          [self saveNotificationMessageToClipboardAtIndexPath:indexPath];
          break;
        default:
          break;
      }
    }];
  }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row % 2 == 1) { return nil; }
  return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [self performSegueWithIdentifier:@"ShowNotification" sender:[self notificationForIndexPath:indexPath]];
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

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
  return @"删除";
}

#pragma mark - 
#pragma mark Helpers
- (DXNotification *)notificationForIndexPath:(NSIndexPath *)indexPath
{
   return self.notifications[(NSUInteger)indexPath.row/2];
}

- (void)deleteNotificationAtIndexPath:(NSIndexPath *)indexPath
{
  DXNotification *notification = [self notificationForIndexPath:indexPath];
  BOOL isFirst = (self.notifications.firstObject == notification);
  [self.heightsCache removeObjectForKey:notification];
  [self.notifications removeObject:notification];
  [self.tableView beginUpdates];
  
  //Delete notification along with the associated spacing cell unless there is ONLY ONE cell.
  NSArray *toBeDeleted;
  if (self.notifications.count == 0) {
    toBeDeleted = @[indexPath];
  }else{
    NSIndexPath *spacingIndexPath = [NSIndexPath indexPathForRow:indexPath.row + (isFirst?1:-1) inSection:indexPath.section];
    toBeDeleted = @[indexPath, spacingIndexPath];
  }
  
  [self.tableView deleteRowsAtIndexPaths:toBeDeleted withRowAnimation:UITableViewRowAnimationLeft];
  
  [self.tableView endUpdates];
  
  self.loadingView.hidden = self.notifications.count !=0;
  self.clearButton.enabled = self.notifications.count !=0;
  self.notFoundMessageLabel.hidden = self.loadingView.hidden;
  
  [[[DXAPIClient sharedClient] deleteNotificationWithId:notification.notificationId] subscribeNext:^(id x) {}];
}

- (void)saveNotificationMessageToClipboardAtIndexPath:(NSIndexPath *)indexPath
{
  DXNotification *notification = [self notificationForIndexPath:indexPath];
  UIPasteboard *pb = [UIPasteboard generalPasteboard];
  [pb setString:notification.message];
  
  [DXProgressHUD showSuccessMessage:@"已复制" forView:self.view image:[UIImage imageNamed:@"clipboard"]];
  
}

#pragma mark -
#pragma mark Actions
- (IBAction)clearNotifications:(id)sender
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"是否确认清空消息列表" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
  [alert show];
  [[[[alert rac_buttonClickedSignal] filter:^BOOL(NSNumber *index) {
    return [index integerValue] == 1;
  }] flattenMap:^RACStream *(id value) {
    DXNotification *notification = [self.notifications firstObject];
    return [[DXAPIClient sharedClient] clearNotificationsUntil:notification.notificationId];
  }] subscribeNext:^(id x) {
    [self.notifications removeAllObjects];
    [self.tableView reloadData];
    [self refresh];
  }];
}

#pragma mark -
#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"ShowNotification"]) {
    DXNotification *notification = sender;
    DXNotificationViewController *vc = segue.destinationViewController;
    vc.notification = notification;
  }
}

#pragma mark -
#pragma mark Rotation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  self.heightsCache = [[NSMutableDictionary alloc] init];
}

@end
