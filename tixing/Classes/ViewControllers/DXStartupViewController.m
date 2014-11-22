//
//  DXStartupViewController.m
//  tixing
//
//  Created by Du Xin on 10/30/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXStartupViewController.h"
#import "DXLoginViewController.h"
#import "DXMainViewController.h"
#import "DXCredentialStore.h"
#import "DXSignupViewController.h"
#import "DXMainViewController.h"
#import "DXAPIClient.h"
#import "DXNotification.h"

@interface DXStartupViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) DXMainViewController *mainViewController;
@end

@implementation DXStartupViewController{
  BOOL justLaunched;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"欢迎使用";
  justLaunched = YES;
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogout) name:TixingNotificationLogout object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [self.navigationController setNavigationBarHidden:YES animated:animated];
  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [self.navigationController setNavigationBarHidden:NO animated:animated];
  [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  if (justLaunched && [DXCredentialStore sharedStore].isLoggedIn) {
    [self didLoginAnimated:NO];
    if (self.notificationId) {
      [self.mainViewController loadNotification:self.notificationId];
    }
  }
  justLaunched = NO;
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

#pragma mark - 
#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"Login"]) {
    DXLoginViewController *vc = segue.destinationViewController;
    vc.successBlock = ^{
      [self didLoginAnimated:YES];
    };
  }
  
  if ([segue.identifier isEqualToString:@"Signup"]) {
    DXSignupViewController *vc = segue.destinationViewController;
    vc.successBlock = ^{
      [self didLoginForTheFirstTime:YES animated:YES];
    };
  }
}

- (void)didLoginForTheFirstTime:(BOOL)firstTime animated:(BOOL)animated
{
  [self.navigationController popViewControllerAnimated:NO];
  UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
  self.mainViewController = [nav.viewControllers firstObject];
  [self.navigationController presentViewController:nav animated:animated completion:nil];
}

- (void)didLoginAnimated:(BOOL)animated
{
  [self didLoginForTheFirstTime:NO animated:animated];
}

- (void)didLogout
{
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Push Notification
- (void)reportPushNotification:(NSDictionary *)userInfo
{
  if (!self.mainViewController) return;
  
  NSString *notificationId = userInfo[@"id"];
  NSString *mesage = [userInfo valueForKeyPath:@"aps.alert"];
  
  if (!notificationId) return;
  
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新提醒"
                                                  message:mesage
                                                 delegate:nil
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"点击查看", nil];
  [alert show];
  [[[alert rac_buttonClickedSignal] filter:^BOOL(NSNumber *index) {
      return [index integerValue] == 1;
    }] subscribeNext:^(id x) {
      [self.mainViewController loadNotification:notificationId];
    }];
}

- (void)openPushNotification:(NSDictionary *)userInfo
{
  NSString *notificationId = userInfo[@"id"];
  if (!notificationId) return;
  
  if (self.mainViewController) { //logged in
    [self.mainViewController loadNotification:notificationId];
  }else{
    self.notificationId = notificationId;
  }
}

@end
