//
//  DXServicesViewController.m
//  tixing
//
//  Created by Du Xin on 10/21/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXServicesViewController.h"
#import "DXAPIClient.h"
#import "DXWebViewController.h"
#import "DXService.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSInteger const kNumberOfSections = 2;
static NSInteger const kInstalledServicesSectionIndex = 0;
static NSInteger const kUninstalledServicesSectionIndex = 1;

@interface DXServicesViewController ()
@property (nonatomic, copy) NSArray *installedServices;
@property (nonatomic, copy) NSArray *uninstalledServices;
@end

@implementation DXServicesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self reloadServices];
}

- (void)reloadServices
{
  [[[DXAPIClient sharedClient] retrieveServices] subscribeNext:^(NSDictionary *result) {
    self.installedServices = result[@"installed"];
    self.uninstalledServices = result[@"uninstalled"];
    [self.tableView reloadData];
  } error:^(NSError *error) {
    DDLogError(@"%@", error);
  }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == kInstalledServicesSectionIndex) {
    return (NSInteger)self.installedServices.count;
  }else if(section == kUninstalledServicesSectionIndex){
    return (NSInteger)self.uninstalledServices.count + 1;
  }
  return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  if (section == kInstalledServicesSectionIndex) {
    return @"已安装";
  }else if(section == kUninstalledServicesSectionIndex){
    return @"未安装";
  }
  return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == kInstalledServicesSectionIndex) {
    return [self configureInstalledServiceCellAtIndexPath:indexPath];
  }else if(indexPath.section == kUninstalledServicesSectionIndex){
    return [self configureUninstalledServiceCellAtIndexPath:indexPath];
  }
  return [UITableViewCell new];
}

- (UITableViewCell *)configureInstalledServiceCellAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"InstalledServiceCell"];
  DXService *service;
  service = self.installedServices[(NSUInteger)indexPath.row];
  cell.textLabel.text = service.name;
  [cell.imageView setImageWithURL:service.iconURL placeholderImage:[UIImage imageNamed:@"service-placeholder"]];
  return cell;
}

- (UITableViewCell *)configureUninstalledServiceCellAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell;
  if (indexPath.row == (NSInteger)self.uninstalledServices.count) { //coming soon
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"ComingSoonCell"];
  }else{
    cell = [self.tableView dequeueReusableCellWithIdentifier:@"UninstalledServiceCell"];
    DXService *service;
    service = self.uninstalledServices[(NSUInteger)indexPath.row];
    cell.textLabel.text = service.name;
    [cell.imageView setImageWithURL:service.iconURL placeholderImage:[UIImage imageNamed:@"service-placeholder"]];
  }
  return cell;
}

#pragma mark - Table view delegation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  NSInteger section = indexPath.section;
  NSUInteger row = (NSUInteger)indexPath.row;
  if (section == kUninstalledServicesSectionIndex && row < self.uninstalledServices.count) {
    DXService *service = self.uninstalledServices[row];
    
    NSString *message = [NSString stringWithFormat:@"是否确认安装\"%@\"", service.name];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
    [[[[alert rac_buttonClickedSignal] filter:^BOOL(NSNumber *index) {
      return [index integerValue] == 1;
    }] flattenMap:^RACStream *(id value) {
      return [[DXAPIClient sharedClient] installServiceWithId:service.serviceId];
    }] subscribeNext:^(id x) {
      [self reloadServices];
    } error:^(NSError *error) {
      DDLogError(@"%@", error);
    }];
  }
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
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    DXService *service = self.installedServices[(NSUInteger)indexPath.row];
    NSURL *URL = service.URL;
    DXWebViewController *vc = segue.destinationViewController;
    vc.URL = URL;
  }
}

@end
