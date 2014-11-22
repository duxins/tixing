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

@interface DXNotificationViewController ()
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbImageView;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *openURLBarButton;
@end

@implementation DXNotificationViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  if (self.notification) {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    
    self.titleLabel.text = self.notification.title;
    self.dateLabel.text = [dateFormatter stringFromDate:self.notification.createdAt];
    self.messageLabel.text = self.notification.message;
    self.thumbImageView.layer.cornerRadius = 4;
    self.thumbImageView.layer.masksToBounds = YES;
    [self.thumbImageView sd_setImageWithURL:self.notification.thumbURL placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    UIApplication *applicatoin = [UIApplication sharedApplication];
    if (![applicatoin canOpenURL:self.notification.URL] && ![applicatoin canOpenURL:self.notification.webURL]) {
      self.openURLBarButton.enabled = NO;
    }
    
    if (self.notification.autoOpen) { [self openURL]; }
  }
}

#pragma mark -
#pragma mark Actions

- (IBAction)copyButtonPressed:(id)sender
{
  UIPasteboard *pb = [UIPasteboard generalPasteboard];
  [pb setString:self.notification.message];
  [DXProgressHUD showSuccessMessage:@"已复制" forView:self.view image:[UIImage imageNamed:@"clipboard"]];
}

- (IBAction)openURLButtonPressed:(id)sender
{
  [self openURL];
}

- (void)openURL
{
  DXNotification *notification = self.notification;
  UIApplication *application = [UIApplication sharedApplication];
  
  NSURL *URL;
  
  if ([application canOpenURL:notification.URL]) {
    URL = notification.URL;
  }else if([application canOpenURL:notification.webURL]){
    URL = notification.webURL;
  }
  
  if (!URL) return;
  
  if ([URL.scheme isEqualToString:@"http"] || [URL.scheme isEqualToString:@"https"]) {
    [self performSegueWithIdentifier:@"OpenURL" sender:URL];
  }else if ([application canOpenURL:URL]) {
    [application openURL:URL];
  }
}

#pragma mark - 
#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"OpenURL"]) {
    DXWebViewController *vc = segue.destinationViewController;
    vc.URL = sender;
  }
}

@end
