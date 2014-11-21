//
//  DXProgressHUD.m
//  tixing
//
//  Created by Du Xin on 10/30/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXProgressHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation DXProgressHUD

+ (void)showSuccessMessage:(NSString *)message forView:(UIView *)view image:(UIImage *)image completion:(void (^)())completion;
{
  if (!image) {
    image = [UIImage imageNamed:@"tick"];
  }
  
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
  hud.minSize = CGSizeMake(110.0, 80.0);
  hud.opacity = 0.65f;
  hud.mode = MBProgressHUDModeCustomView;
  hud.customView = [[UIImageView alloc] initWithImage:image];
  hud.labelText = message;
  hud.removeFromSuperViewOnHide = YES;
  hud.transform = CGAffineTransformMakeScale(1.5, 1.5);
  [hud show:YES];
  
  [UIView animateWithDuration:0.15 animations:^{
    hud.transform = CGAffineTransformIdentity;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [UIView animateWithDuration:0.15 animations:^{
        [hud hide:YES];
      }completion:^(BOOL finished) {
        if (completion) { completion(); }
      }];
    });
  }];
}

+ (void)showSuccessMessage:(NSString *)message forView:(UIView *)view image:(UIImage *)image
{
  [self showSuccessMessage:message forView:view image:image completion:nil];
}

@end
