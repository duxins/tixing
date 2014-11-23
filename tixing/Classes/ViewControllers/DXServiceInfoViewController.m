//
//  DXServiceInfoViewController.m
//  tixing
//
//  Created by Du Xin on 11/23/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXServiceInfoViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DXSoundStore.h"
#import "DXSoundViewController.h"
#import "DXAPIClient.h"

@interface DXServiceInfoViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel *serviceTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel *serviceDescriptionLabel;
@property (nonatomic, weak) IBOutlet UISwitch *notificationSwitch;
@property (nonatomic, weak) IBOutlet UILabel *soundLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *soundLoadingIndicator;
@property (nonatomic, strong) DXSound *sound;

@end

@implementation DXServiceInfoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  if (self.service) {
    self.title = self.service.name;
    self.serviceTitleLabel.text = self.service.name;
    self.serviceDescriptionLabel.text = self.service.desc;
    [self.iconImageView sd_setImageWithURL:self.service.iconURL];
    [self.notificationSwitch setOn:self.service.enabled animated:YES];
    [self updateSoundLabel];
  }
}

- (void)updateSoundLabel
{
  self.soundLabel.hidden = NO;
  self.sound = [[DXSoundStore sharedStore] soundByName:self.service.sound];
  self.soundLabel.text = self.sound.label;
}

- (void)updateInstallationSound:(NSString *)soundName
{
  self.soundLoadingIndicator.hidden = NO;
  self.soundLabel.hidden = YES;
  NSString *serviceId = self.service.serviceId;
  [[[DXAPIClient sharedClient] updateServicePreferences:@{@"sound": soundName} withServiceId:serviceId] subscribeNext:^(id x) {
    self.soundLoadingIndicator.hidden = YES;
    self.service.sound = soundName;
    [self updateSoundLabel];
  }error:^(NSError *error) {
    self.soundLoadingIndicator.hidden = YES;
    [self updateSoundLabel];
    DDLogError(@"error:%@", error);
  }];
}

#pragma mark -
#pragma mark Actions
- (IBAction)notificationSwitchChanged:(UISwitch *)sender
{
  sender.enabled = NO;
  NSString *serviceId = self.service.serviceId;
  [[[DXAPIClient sharedClient] updateServicePreferences:@{@"enabled": @(sender.isOn)} withServiceId:serviceId]
   subscribeNext:^(id x) {
     self.service.enabled = sender.isOn;
     sender.enabled = YES;
   } error:^(NSError *error) {
     sender.enabled = YES;
     [sender setOn:!sender.isOn animated:YES];
     DDLogError(@"error: %@", error);
   }];
}

- (IBAction)uninstallButtonPressed:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
  self.uninstallBlock();
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([segue.identifier isEqualToString:@"ShowSound"]) {
    DXSoundViewController *vc = segue.destinationViewController;
    vc.selectedSound = self.sound;
    vc.didSelectedBlock = ^(DXSound *sound){
      if (!sound || [sound isEqual:self.sound]) { return; }
      [self updateInstallationSound:sound.name];
    };
  }
}


@end
