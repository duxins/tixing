//
//  DXQRScannerViewController.h
//  tixing
//
//  Created by Du Xin on 11/15/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXQRScannerViewController : UIViewController
@property (nonatomic, copy) void (^successBlock)(NSString *code);
@end

