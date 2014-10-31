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
#import "DXUser.h"
#import "DXSoundStore.h"
#import "DXSoundViewController.h"
#import "DXConfig.h"
#import "DXMacros.h"

static NSString *const kServiceIndexPathKey = @"service";
static NSString *const kSilentIndexPathKey  = @"silent";
static NSString *const kLogoutIndexPathKey  = @"logout";
static NSString *const kAccountIndexPathKey = @"account";
static NSString *const kAppStoreIndexPathKey = @"appstore";
static NSString *const kCheckUpdatesIndexPathKey = @"update";

@interface DXSettingsViewController ()
@property (nonatomic, strong) NSDictionary *indexPathsByKey;
@property (nonatomic, strong) DXUser *user;
@property (nonatomic, strong) DXSound *sound;

@property (nonatomic, weak) IBOutlet UISwitch *soundSwitch;
@property (nonatomic, weak) IBOutlet UILabel *soundLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *soundIndicator;
@property (nonatomic, weak) IBOutlet UITableViewCell *accountCell;

@end

@implementation DXSettingsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.user = [DXCredentialStore sharedStore].user;
  self.accountCell.detailTextLabel.text = self.user.name;
  [self.soundSwitch setOn:self.user.silentAtNight animated:NO];
  [self displaySoundName];
}


#pragma mark -
#pragma mark Sounds

- (void)displaySoundName
{
  self.soundIndicator.hidden = YES;
  self.sound = [[DXSoundStore sharedStore] soundByName:self.user.sound];
  self.soundLabel.text = self.sound.label;
}

- (void)updateSoundName:(NSString *)soundName
{
  self.soundIndicator.hidden = NO;
  self.soundLabel.text = @"";
  
  [[[DXAPIClient sharedClient] updateCustomSound:soundName] subscribeNext:^(id x) {
    self.user.sound = soundName;
    [DXCredentialStore sharedStore].user = self.user;
    [self displaySoundName];
  }error:^(NSError *error) {
    [self displaySoundName];
    DDLogError(@"error:%@", error);
  }];
}

- (NSDictionary *)indexPathsByKey
{
  if (!_indexPathsByKey) {
    _indexPathsByKey = @{
                         kServiceIndexPathKey: [NSIndexPath indexPathForRow:0 inSection:0], //服务
                         kSilentIndexPathKey:  [NSIndexPath indexPathForRow:1 inSection:1], //夜间静音
                         kAccountIndexPathKey: [NSIndexPath indexPathForRow:0 inSection:2], //用户名
                         kAppStoreIndexPathKey: [NSIndexPath indexPathForRow:0 inSection:3], //去评分
                         kCheckUpdatesIndexPathKey: [NSIndexPath indexPathForRow:1 inSection:3], //检查新版本
                         kLogoutIndexPathKey:  [NSIndexPath indexPathForRow:0 inSection:4], //退出登录
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
    [DXCredentialStore sharedStore].user.silentAtNight = sender.isOn;
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
  if ([indexPath isEqual:self.indexPathsByKey[kAppStoreIndexPathKey]]) {
    NSURL *URL = [NSURL URLWithString:TixingAppStoreURLString];
    [[UIApplication sharedApplication] openURL:URL];
  }
  
  if ([indexPath isEqual: self.indexPathsByKey[kLogoutIndexPathKey]]) {
    UIAlertView *alert = DXConfirm(@"是否确认退出？");
    [alert show];
    
    [[[alert rac_buttonClickedSignal] filter:^BOOL(NSNumber *index) {
      return [index integerValue] == 1;
    }] subscribeNext:^(id x) {
      [[DXCredentialStore sharedStore] userDidLogout];
    }];
  }
  
  if ([indexPath isEqual:self.indexPathsByKey[kCheckUpdatesIndexPathKey]]) {
    [[[DXAPIClient sharedClient] checkForUpdates] subscribeNext:^(id x) {
      if (x[@"version"]) { //
        NSString *message = [NSString stringWithFormat:@"发现新版本%@", x[@"version"]];
        NSString *updateURLString = x[@"update_url"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"忽略" otherButtonTitles:@"立即升级", nil];
        [alert show];
        
        [[alert rac_buttonClickedSignal] subscribeNext:^(NSNumber *button) {
          if ([button integerValue] == 1) {
            NSURL *URL = [NSURL URLWithString:updateURLString];
            [[UIApplication sharedApplication] openURL:URL];
          }
        }];
        
      }else{
        [DXAlert(@"当前版本已是最新版") show];
      }
    } error:^(NSError *error) {
      DDLogError(@"%@", error);
    }];
  }
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  __block NSIndexPath *newIndexPath = indexPath;
  
  [@[kSilentIndexPathKey, kAccountIndexPathKey]
  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if ([indexPath isEqual:self.indexPathsByKey[obj]]) {
      newIndexPath = nil;
      *stop = YES;
    }
  }];
  
  return newIndexPath;
}

#pragma mark -
#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"ShowSound"]) {
    DXSoundViewController *vc =  segue.destinationViewController;
    vc.selectedSound = self.sound;
    vc.didSelecteBlock = ^(DXSound *sound){
      if (!sound || [sound isEqual:self.sound]) { return; }
      [self updateSoundName:sound.name];
    };
  }
}



@end
