//
//  DXDefaultsStore.h
//  tixing
//
//  Created by Du Xin on 12/15/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXDefaultsStore : NSObject

+ (void)setObject:(id)object forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;
+ (void)removeCurrentUser;
+ (BOOL)autoOpenNotificationLinkEnabled;
+ (void)setAutoOpenNotificationLinkEnabled:(BOOL)enabled;

@end
