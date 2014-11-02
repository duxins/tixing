//
//  DXServicesViewController.m
//  tixing
//
//  Created by Du Xin on 10/21/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXServicesViewController.h"
#import "DXAPIClient.h"
#import "DXService.h"
#import "DXServiceDetailViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "DXMacros.h"
#import "DXServiceCell.h"
#import <SSPullToRefresh/SSPullToRefresh.h>
#import "DXPullToRefreshSimpleContentView.h"
#import "DXProgressHUD.h"

static NSInteger const kNumberOfSections = 2;
static NSInteger const kInstalledServicesSectionIndex = 0;
static NSInteger const kUninstalledServicesSectionIndex = 1;

typedef NS_ENUM(NSUInteger, DXServiceCellType){
  DXServiceCellTypeInstalledService = 0,
  DXServiceCellTypeUninstalledService,
  DXServiceCellTypeComingSoon,
  DXServiceCellTypeLoading
};

@interface DXServicesViewController ()<SSPullToRefreshViewDelegate>
@property (nonatomic, copy) NSArray *installedServices;
@property (nonatomic, copy) NSArray *uninstalledServices;
@property (nonatomic, assign) BOOL hasLoaded;
@property (nonatomic, strong) SSPullToRefreshView *pullToRefreshView;
@property (nonatomic, assign) BOOL isLoading;
@end

@implementation DXServicesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.hasLoaded = NO;
  self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:self.tableView delegate:self];
  self.pullToRefreshView.contentView = [DXPullToRefreshSimpleContentView new];
  [self reloadServices];
}

- (void)reloadServices
{
  self.isLoading = YES;
  [[[DXAPIClient sharedClient] retrieveServices] subscribeNext:^(NSDictionary *result) {
    self.isLoading = NO;
    self.hasLoaded = YES;
    self.installedServices = result[@"installed"];
    self.uninstalledServices = result[@"uninstalled"];
    [self.pullToRefreshView finishLoading];
    [self.tableView reloadData];
  } error:^(NSError *error) {
    self.isLoading = NO;
    [self.pullToRefreshView finishLoading];
    DDLogError(@"%@", error);
  }];
}

#pragma mark -
#pragma mark - SSPullToRefreshViewDelegate
- (BOOL)pullToRefreshViewShouldStartLoading:(SSPullToRefreshView *)view
{
  if (self.isLoading) {
    return NO;
  }
  
  [self reloadServices];
  return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == kInstalledServicesSectionIndex) {
    NSInteger ajustment = self.hasLoaded ? 0 : 1;
    return (NSInteger)self.installedServices.count + ajustment;
  }else if(section == kUninstalledServicesSectionIndex){
    return (NSInteger)self.uninstalledServices.count + 1; //coming soon cell
  }
  return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  if (section == kInstalledServicesSectionIndex) {
    if (self.hasLoaded && self.installedServices.count == 0) {
      return nil;
    }
    return @"已添加";
  }else if(section == kUninstalledServicesSectionIndex){
    return @"未添加";
  }
  return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  if (section == kInstalledServicesSectionIndex && self.hasLoaded && self.installedServices.count == 0) {
    return 1.0f;
  }
  return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch ([self cellTypeAtIndexPath:indexPath]) {
    case DXServiceCellTypeInstalledService:
    case DXServiceCellTypeUninstalledService:
      return [self configureServiceCellAtIndexPath:indexPath];
    case DXServiceCellTypeLoading:
      return [self.tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
    case DXServiceCellTypeComingSoon:
      return [self.tableView dequeueReusableCellWithIdentifier:@"ComingSoonCell"];
    default:
      return [UITableViewCell new];
  }
}

- (UITableViewCell *)configureServiceCellAtIndexPath:(NSIndexPath *)indexPath
{
  DXServiceCell *cell;
  DXService *service;
  
  cell = [self.tableView dequeueReusableCellWithIdentifier:@"ServiceCell"];
  
  if ([self cellTypeAtIndexPath:indexPath] == DXServiceCellTypeInstalledService) {
    service = self.installedServices[(NSUInteger)indexPath.row];
  }else{
    service = self.uninstalledServices[(NSUInteger)indexPath.row];
  }
  
  cell.titleLabel.text = service.name;
  cell.descLabel.text = service.desc;
  cell.iconImageView.image = nil;
  [cell.iconImageView sd_setImageWithURL:service.iconURL placeholderImage:[UIImage imageNamed:@"service-placeholder"]];
  
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  DXServiceCellType type = [self cellTypeAtIndexPath:indexPath];
  
  if (type == DXServiceCellTypeInstalledService) {
    [self performSegueWithIdentifier:@"ShowService" sender:indexPath];
  } else if(type == DXServiceCellTypeUninstalledService){
    NSUInteger row = (NSUInteger)indexPath.row;
    DXService *service = self.uninstalledServices[row];
    [self installService:service];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch ([self cellTypeAtIndexPath:indexPath]) {
    case DXServiceCellTypeInstalledService:
    case DXServiceCellTypeUninstalledService:
      return 55;
      break;
    default:
      break;
  }
  
  return 44;
}


#pragma mark - 
#pragma mark Helpers

- (void)installService:(DXService *)service
{
  NSString *message = [NSString stringWithFormat:@"是否确认添加\"%@\"", service.name];
  UIAlertView *alert = DXConfirm(message);
  [alert show];
  [[[[alert rac_buttonClickedSignal]
    filter:^BOOL(NSNumber *index) {
      return [index integerValue] == 1;
    }] flattenMap:^RACStream *(id value) {
      return [[DXAPIClient sharedClient] installServiceWithId:service.serviceId];
    }] subscribeNext:^(id x) {
      [DXProgressHUD showSuccessMessage:@"添加成功" forView:self.view image:nil];
      [self reloadServices];
    } error:^(NSError *error) {
      DDLogError(@"%@", error);
    }];
}

- (DXServiceCellType)cellTypeAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0) {
    return self.hasLoaded ? DXServiceCellTypeInstalledService : DXServiceCellTypeLoading;
  }
  
  return indexPath.row < (NSInteger)self.uninstalledServices.count ? DXServiceCellTypeUninstalledService : DXServiceCellTypeComingSoon;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSInteger section = indexPath.section;
  NSUInteger row = (NSUInteger)indexPath.row;
  if (section == kUninstalledServicesSectionIndex && row >= self.uninstalledServices.count) {
    return nil;
  }
  return indexPath;
}

#pragma mark -
#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"ShowService"]) {
    NSIndexPath *indexPath = sender;
    DXService *service = self.installedServices[(NSUInteger)indexPath.row];
    DXServiceDetailViewController *vc= segue.destinationViewController;
    vc.service = service;
    vc.uninstallBlock = ^(){
      [self.navigationController popViewControllerAnimated:YES];
      [self reloadServices];
    };
  }
}

@end
