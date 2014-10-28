//
//  DXNotification.h
//  tixing
//
//  Created by Du Xin on 10/28/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@class DXService;

@interface DXNotification : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *notificationId;
@property (nonatomic, copy, readonly) NSString *message;
@property (nonatomic, strong) DXService *service;

@end
