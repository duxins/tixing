//
//  DXMacros.h
//  tixing
//
//  Created by Du Xin on 10/27/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#define DXConfirm(msg) ([[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil])
#define DXAlert(msg) ([[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil])

#define DXVersionNumber ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"])
#define DXBuildNumber   ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"])
#define DXPostNotification(name) do{\
  [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:nil];\
  DDLogDebug(@"Post Notification: %@", name);\
}while(0)
