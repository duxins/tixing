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

@interface DXLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation DXLoginViewController

#pragma mark -
#pragma mark Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"登录";
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  [self.nameField becomeFirstResponder];
}

- (IBAction)loginButtonPressed:(id)sender {
  NSString *name = self.nameField.text;
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

@end
