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

@interface DXServicesViewController ()
@property (nonatomic, copy) NSArray *services;
@end

@implementation DXServicesViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[[DXAPIClient sharedClient] retrieveServices] subscribeNext:^(id x) {
    self.services = x;
    [self.tableView reloadData];
  } error:^(NSError *error) {
    DDLogError(@"%@", error);
  }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return (NSInteger)self.services.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceCell"];
  NSDictionary *service = self.services[(NSUInteger)indexPath.row];
  cell.textLabel.text = service[@"name"];
  return cell;
}

#pragma mark - Table view delegation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"ShowService"]) {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    NSDictionary *service = self.services[(NSUInteger)indexPath.row];
    NSString *urlString = service[@"url"];
    
    DXWebViewController *vc = segue.destinationViewController;
    vc.urlString = urlString;
    
  }
}

@end
