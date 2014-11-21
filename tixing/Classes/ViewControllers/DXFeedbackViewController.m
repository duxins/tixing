//
//  DXFeedbackViewController.m
//  tixing
//
//  Created by Du Xin on 11/21/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXFeedbackViewController.h"
#import "DXAPIClient.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "DXMacros.h"
#import "DXProgressHUD.h"

@interface DXFeedbackViewController ()<UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UITextView *feedbackTextView;
@property (nonatomic, weak) IBOutlet UILabel *placeholder;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *submitButton;
@end

@implementation DXFeedbackViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  RAC(self.submitButton, enabled) = [[self.feedbackTextView rac_textSignal] map:^id(NSString *text) {
    return @(text.length != 0);
  }];
}

#pragma mark - Actions
- (IBAction)submit:(id)sender
{
  [self.feedbackTextView resignFirstResponder];
  self.submitButton.enabled = NO;
  [[[DXAPIClient sharedClient] leaveFeedback:self.feedbackTextView.text] subscribeNext:^(id x) {
    [DXProgressHUD showSuccessMessage:@"提交成功" forView:self.tableView image:nil completion:^{
      [self.navigationController popViewControllerAnimated:YES];
    }];
  }error:^(NSError *error) {
    self.submitButton.enabled = YES;
    DXAlert(error.localizedDescription).show;
  }];
}

#pragma mark -
#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
  self.placeholder.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
  if ([textView.text isEqualToString:@""]) {
    self.placeholder.hidden = NO;
  }else{
    self.placeholder.hidden = YES;
  }
}

@end
