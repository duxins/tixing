//
//  DXSettingsViewController.m
//  tixing
//
//  Created by Du Xin on 10/21/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXSettingsViewController.h"
#import "DXCredentialStore.h"

@interface DXSettingsViewController ()
@property (nonatomic, strong) NSDictionary *indexPathsByKey;
@end

@implementation DXSettingsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (NSDictionary *)indexPathsByKey
{
  if (!_indexPathsByKey) {
    _indexPathsByKey = @{
                         
                         @"service": [NSIndexPath indexPathForRow:0 inSection:0], //服务
                         @"logout":  [NSIndexPath indexPathForRow:0 inSection:3], //退出登录
                         
                         };
  }
  return _indexPathsByKey;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([indexPath isEqual: self.indexPathsByKey[@"logout"]]) {
    [DXCredentialStore sharedStore].authToken = nil;
  }
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
