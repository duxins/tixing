//
//  DXStartupViewController.m
//  tixing
//
//  Created by Du Xin on 10/30/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXStartupViewController.h"

@interface DXStartupViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation DXStartupViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"欢迎使用";
}

- (void)viewWillAppear:(BOOL)animated {
  [self.navigationController setNavigationBarHidden:YES animated:animated];
  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [self.navigationController setNavigationBarHidden:NO animated:animated];
  [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell;
  if (indexPath.row == 0) {
    cell = [tableView dequeueReusableCellWithIdentifier:@"LoginCell"];
  }else if(indexPath.row == 1){
    cell = [tableView dequeueReusableCellWithIdentifier:@"RegisterCell"];
  }
  return cell;
}

#pragma mark - 
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
