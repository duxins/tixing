//
//  DXSignupViewController.m
//  tixing
//
//  Created by Du Xin on 10/31/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXSignupViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "DXAPIClient.h"
#import "DXMacros.h"
#import <EXTScope.h>

@interface DXSignupViewController ()<UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *submitButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicatorView;
@end

@implementation DXSignupViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  RAC(self.submitButton, enabled) = [RACSignal combineLatest:@[[self.nameField rac_textSignal], [self.passwordField rac_textSignal]]
                                                      reduce:^id(NSString *name, NSString *password){
                                                        return @(name.length > 3 && password.length > 3);
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
       [self signup];
     }
   }];
  
  self.nameField.delegate = self;
  self.passwordField.delegate = self;
  [self.nameField becomeFirstResponder];
}

#pragma mark - 
#pragma mark Actions
- (IBAction)submitButtonPressed:(id)sender
{
  [self signup];
}

#pragma mark -
#pragma mark Private methods
- (void)signup {
  self.submitButton.enabled = NO;
  NSString *name = self.nameField.text;
  NSString *password = self.passwordField.text;
  [self.loadingIndicatorView startAnimating];
  
  [[[DXAPIClient sharedClient] signupWithName:name password:password]
    subscribeNext:^(id x) {
      [self.loadingIndicatorView stopAnimating];
      self.submitButton.enabled = YES;
      if (self.successBlock) self.successBlock();
    }error:^(NSError *error) {
      [self.loadingIndicatorView stopAnimating];
      self.submitButton.enabled = YES;
      DXAlert(error.localizedDescription).show;
    }];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  if (textField == self.nameField) {
    if([string rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound){
      return NO;
    }
  }
  return YES;
}

@end
