//
//  DXSettingsViewController.m
//  tixing
//
//  Created by Du Xin on 10/21/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXSettingsViewController.h"
#import "DXCredentialStore.h"
#import "DXAPIClient.h"

static NSString *const kServiceIndexPathKey = @"service";
static NSString *const kSilentIndexPathKey  = @"silent";
static NSString *const kLogoutIndexPathKey  = @"logout";

@interface DXSettingsViewController ()
@property (nonatomic, strong) NSDictionary *indexPathsByKey;
@property (nonatomic, weak) IBOutlet UISwitch *soundSwitch;
@end

@implementation DXSettingsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (NSDictionary *)indexPathsByKey
{
  if (!_indexPathsByKey) {
    _indexPathsByKey = @{
                         
                         kServiceIndexPathKey: [NSIndexPath indexPathForRow:0 inSection:0], //服务
                         kSilentIndexPathKey:  [NSIndexPath indexPathForRow:1 inSection:1], //夜间静音
                         kLogoutIndexPathKey:  [NSIndexPath indexPathForRow:0 inSection:3], //退出登录
                         
                         };
  }
  return _indexPathsByKey;
}

#pragma mark -
#pragma mark Actions
- (IBAction)soundSwitchChanged:(UISwitch *)sender
{
  sender.enabled = NO;
  [[[DXAPIClient sharedClient] keepSilentAtNight:sender.isOn] subscribeNext:^(id x) {
    sender.enabled = YES;
  } error:^(NSError *error) {
    sender.enabled = YES;
    [sender setOn:!sender.isOn animated:YES];
  }];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([indexPath isEqual: self.indexPathsByKey[kLogoutIndexPathKey]]) {
    [DXCredentialStore sharedStore].authToken = nil;
  }
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([indexPath isEqual:self.indexPathsByKey[kSilentIndexPathKey]]) {
    return nil;
  }
  return indexPath;
}

@end
