//
//  DXWebViewController+DXBridge.m
//  tixing
//
//  Created by Du Xin on 11/3/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXWebViewController+DXBridge.h"
#import "DXMacros.h"
#import "DXSoundStore.h"

@implementation DXWebViewController (DXBridge)

#pragma mark -
#pragma mark Basic
- (void)js_actionAlert:(id)parameters
{
  NSString *message = parameters[@"message"];
  DXAlert(message).show;
}

- (void)js_actionGoBack:(id)parameters
{
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 
#pragma makr Sound
- (void)js_actionPlaySound:(id)parameters
{
  NSString *fileName = parameters[@"name"];
  [[DXSoundStore sharedStore] playSound:fileName];
}

@end
