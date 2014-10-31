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

@interface DXStartupViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
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
      [self didLoginAnimated:YES];
    };
  }
  
}

- (void)didLoginAnimated:(BOOL)animated
{
  [self.navigationController popViewControllerAnimated:NO];
  UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
  [self.navigationController presentViewController:vc animated:animated completion:nil];
}

- (void)didLogout
{
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
