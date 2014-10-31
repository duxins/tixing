//
//  DXDeviceTokenStore.h
//  tixing
//
//  Created by Du Xin on 10/25/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXDeviceTokenStore : NSObject
@property (nonatomic, copy) NSString *token;
+ (instancetype)sharedStore;
- (void)revokeDeviceToken:(void (^)())completion;
@end
