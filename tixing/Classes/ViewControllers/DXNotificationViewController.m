//
//  DXNotificationViewController.m
//  tixing
//
//  Created by Du Xin on 10/21/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXNotificationViewController.h"
#import "DXNotification.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DXProgressHUD.h"
#import "DXWebViewController.h"
#import "DXNavigationViewController.h"

@import MessageUI;

@interface DXNotificationViewController () <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbImageView;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *openURLBarButton;
@property (nonatomic, weak) IBOutlet UIButton *openURLButton;
@property (nonatomic, weak) IBOutlet UIButton *saveURLButton;
@property (nonatomic, weak) IBOutlet UIButton *sendEmailButton;
@property (nonatomic, assign) BOOL hasOpened;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation DXNotificationViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.hasOpened = NO;
  
  if (self.notification) {
    self.dateFormatter = [NSDateFormatter new];
    self.dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    
    self.titleLabel.text = self.notification.title;
    self.dateLabel.text = [self.dateFormatter stringFromDate:self.notification.createdAt];
    self.messageLabel.text = self.notification.message;
    self.thumbImageView.layer.cornerRadius = 4;
    self.thumbImageView.layer.masksToBounds = YES;
    [self.thumbImageView sd_setImageWithURL:self.notification.thumbURL placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    UIApplication *applicatoin = [UIApplication sharedApplication];
    if (![applicatoin canOpenURL:self.notification.URL] && ![applicatoin canOpenURL:self.notification.webURL]) {
      self.openURLBarButton.enabled = NO;
      self.openURLButton.enabled = NO;
      self.saveURLButton.enabled = NO;
    }
    
    if (!self.notification.service && [self.notification.title isEqualToString:@"消息提醒"]) {
      self.openURLButton.enabled = NO;
      self.saveURLButton.enabled = NO;
      self.sendEmailButton.enabled = NO;
    }
    
    if (![MFMailComposeViewController canSendMail]) {
      self.sendEmailButton.enabled = NO;
    }
  }
}

#pragma mark -
#pragma mark Actions

- (IBAction)saveButtonPressed:(id)sender
{
  UIPasteboard *pb = [UIPasteboard generalPasteboard];
  [pb setString:[self.notification.webURL absoluteString]];
  [DXProgressHUD showSuccessMessage:@"已复制" forView:self.view image:[UIImage imageNamed:@"clipboard"]];
}

- (IBAction)openURLButtonPressed:(id)sender
{
  [(DXNavigationViewController *)self.navigationController openURLforNotification:self.notification];
}

- (IBAction)sendEmailButtonPressed:(id)sender
{
  self.sendEmailButton.enabled = NO;
  NSString *subject = [NSString stringWithFormat:@"来自 %@ 的提醒", self.notification.title];
  NSString *body = [self emailBody];
  MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
  mc.mailComposeDelegate = self;
  [mc setSubject:subject];
  [mc setMessageBody:body isHTML:YES];
  [self presentViewController:mc animated:YES completion:NULL];
}

#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
  self.sendEmailButton.enabled = YES;
  [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
#pragma mark Helpers
- (NSString *)emailBody
{
  NSURL *emailTemplateURL = [[NSBundle mainBundle] URLForResource:@"share_email" withExtension:@"html"];
  NSString *body = [NSString stringWithContentsOfURL:emailTemplateURL encoding:NSUTF8StringEncoding error:nil];
  body = [body stringByReplacingOccurrencesOfString:@"#{TITLE}" withString:self.notification.title];
  body = [body stringByReplacingOccurrencesOfString:@"#{MESSAGE}" withString:self.notification.message];
  body = [body stringByReplacingOccurrencesOfString:@"#{DATETIME}" withString:[self.dateFormatter stringFromDate:self.notification.createdAt]];
  body = [body stringByReplacingOccurrencesOfString:@"#{THUMB}" withString:[self.notification.thumbURL absoluteString]];
  body = [body stringByReplacingOccurrencesOfString:@"#{URL}" withString:[self.notification.webURL absoluteString]];
  return body;
}
@end
