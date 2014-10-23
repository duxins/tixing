//
//  DXCredentialStore.h
//  tixing
//
//  Created by Du Xin on 10/20/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const TixingNotificationTokenChanged;
extern NSString *const TixingNotificationLogout;

@interface DXCredentialStore : NSObject

@property (nonatomic, strong) NSString *authToken;

+ (instancetype)sharedStore;
- (BOOL)isLoggedIn;

@end
