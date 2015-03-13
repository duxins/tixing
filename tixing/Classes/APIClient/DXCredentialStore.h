//
//  DXCredentialStore.h
//  tixing
//
//  Created by Du Xin on 10/20/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DXUser;

extern NSString *const TixingNotificationTokenChanged;
extern NSString *const TixingNotificationLogout;
extern NSString *const TixingNotificationLogin;

@interface DXCredentialStore : NSObject

@property (nonatomic, strong) NSString *authToken;
@property (nonatomic, strong) DXUser *user;
@property (nonatomic, strong, readonly) NSString *lastUserName;

+ (instancetype)sharedStore;
- (BOOL)isLoggedIn;

- (void)userDidLogin:(DXUser *)user;
- (void)userDidLogout;

- (void)moveUserCacheToUserdefaults;

@end
