//
//  DXSoundViewController.h
//  tixing
//
//  Created by Du Xin on 10/23/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DXSound;

@interface DXSoundViewController : UITableViewController

@property (nonatomic, copy) DXSound *selectedSound;
@property (nonatomic, copy) void (^didSelecteBlock)(DXSound *newSound);

@end
