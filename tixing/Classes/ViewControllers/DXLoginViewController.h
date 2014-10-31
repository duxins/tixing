//
//  DXLoginViewController.h
//  tixing
//
//  Created by Du Xin on 10/21/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXLoginViewController : UITableViewController
@property (nonatomic, copy) void(^successBlock)();
@end
