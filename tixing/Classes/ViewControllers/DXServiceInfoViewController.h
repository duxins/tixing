//
//  DXServiceInfoViewController.h
//  tixing
//
//  Created by Du Xin on 11/23/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXService.h"

@interface DXServiceInfoViewController : UITableViewController
@property (nonatomic, copy) void (^uninstallBlock)();
@property (nonatomic, strong) DXService *service;
@end
