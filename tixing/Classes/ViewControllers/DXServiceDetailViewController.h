//
//  DXServiceDetailViewController.h
//  tixing
//
//  Created by Du Xin on 10/24/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DXWebViewController.h"

@class DXService;

@interface DXServiceDetailViewController : DXWebViewController;
@property (nonatomic, strong) DXService *service;
@property (nonatomic, copy) void (^uninstallBlock)();
@end
