//
//  DXLoginViewController.m
//  tixing
//
//  Created by Du Xin on 10/21/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXLoginViewController.h"
#import "DXCredentialStore.h"
#import "DXAPIClient.h"

@interface DXLoginViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DXLoginViewController{
  BOOL justLaunched;
}

#pragma mark -
#pragma mark Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"登录";
  justLaunched = YES;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogOut) name:TixingNotificationLogout object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  if (justLaunched) {
    if ([DXCredentialStore sharedStore].isLoggedIn) {
      [self didLogInAnimated:NO];
    }
    justLaunched = NO;
  }
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)loginButtonPressed:(id)sender {
  NSString *name = self.emailField.text;
  NSString *password = self.passwordField.text;
  
  [[[DXAPIClient sharedClient] loginWithName:name password:password] subscribeNext:^(id x) {
    [self didLogInAnimated:YES];
  } error:^(NSError *error) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
  }];
}

- (void)didLogInAnimated:(BOOL)animated
{
  [self.view endEditing:YES];
  UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
  [self presentViewController:vc animated:animated completion:nil];
}

- (void)didLogOut
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)hidesBottomBarWhenPushed
{
  return YES;
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 2;
}

#pragma mark -
#pragma mark UITableViewDelegate


@end
