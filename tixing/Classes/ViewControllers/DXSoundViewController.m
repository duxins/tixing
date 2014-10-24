//
//  DXSoundViewController.m
//  tixing
//
//  Created by Du Xin on 10/23/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXSoundViewController.h"
#import "DXAPIClient.h"
@import AudioToolbox;

@interface DXSoundViewController ()
@property (nonatomic, copy) NSArray *sounds;
@property (nonatomic, copy) NSString *selectedSound;
@end

@implementation DXSoundViewController{
  SystemSoundID soundID;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.selectedSound = @"default";
  [self loadSounds];
}

- (void)loadSounds
{
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sounds" ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:filePath];
  self.sounds = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

#pragma -
#pragma mark Sound

- (void)playSound:(NSString *)file
{
  NSString *soundPath = [[NSBundle mainBundle] pathForResource:file ofType:@"caf"];
  if (!soundPath)  return;
  
  AudioServicesDisposeSystemSoundID(soundID);
  AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
  AudioServicesPlaySystemSound (soundID);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return (NSInteger)self.sounds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SoundCell" forIndexPath:indexPath];
  NSDictionary *sound = self.sounds[(NSUInteger)indexPath.row];
  cell.textLabel.text = sound[@"name"];
  if ([sound[@"file"] isEqualToString:self.selectedSound]) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  }else{
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  return cell;
}

#pragma mark - 
#pragma mark - Table view delegation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  NSDictionary *sound = self.sounds[(NSUInteger)indexPath.row];
  NSString *file = sound[@"file"];
  
  if (![file isEqualToString:@"default"] && ![file isEqualToString:@""]) {
    [self playSound:file];
  }
  
  [tableView reloadData];
  self.selectedSound = file;
  [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  });
}
@end
