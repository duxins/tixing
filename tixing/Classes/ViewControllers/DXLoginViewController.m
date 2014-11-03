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
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <EXTScope.h>

@interface DXLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *submitButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicatorView;
@end

@implementation DXLoginViewController

#pragma mark -
#pragma mark Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"登录";
  self.nameField.text = [DXCredentialStore sharedStore].lastUserName;
  
  RAC(self.submitButton, enabled) = [RACSignal combineLatest:@[[self.nameField rac_textSignal], [self.passwordField rac_textSignal]]
                    reduce:^id(NSString *name, NSString *password){
                      return @(name.length > 3 && password.length > 1);
                    }];
  
  @weakify(self);
  [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)]
    subscribeNext:^(RACTuple *arguments) {
      @strongify(self);
      UITextField *textField = arguments.first;
      if (textField == self.nameField) {
        [self.passwordField becomeFirstResponder];
      }
      if (textField == self.passwordField) {
        [self loginButtonPressed:nil];
      }
    }];
  
  self.nameField.delegate = self;
  self.passwordField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  if (self.nameField.text.length > 0) {
    [self.passwordField becomeFirstResponder];
  }else{
    [self.nameField becomeFirstResponder];
  }
}

- (IBAction)loginButtonPressed:(id)sender {
  [self.view endEditing:YES];
  self.submitButton.enabled = NO;
  [self.loadingIndicatorView startAnimating];
  NSString *name = self.nameField.text;
  NSString *password = self.passwordField.text;
  
  [[[DXAPIClient sharedClient] loginWithName:name password:password] subscribeNext:^(id x) {
    self.submitButton.enabled = YES;
    [self.loadingIndicatorView stopAnimating];
    if (self.successBlock) self.successBlock();
  } error:^(NSError *error) {
    self.submitButton.enabled = YES;
    [self.loadingIndicatorView stopAnimating];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
  }];
}

@end
