//
//  DXNotification.h
//  tixing
//
//  Created by Du Xin on 10/28/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "MTLModel.h"
#import "DXService.h"
#import <Mantle/Mantle.h>


@interface DXNotification : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *notificationId;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *message;
@property (nonatomic, copy) NSString *highlight;
@property (nonatomic, strong) DXService *service;
@property (nonatomic, copy, readonly) NSDate *createdAt;
@property (nonatomic, copy, readonly) NSURL *thumbURL;
@property (nonatomic, copy, readonly) NSURL *URL;
@property (nonatomic, copy, readonly) NSURL *webURL;
@property (nonatomic, assign) BOOL autoOpen;
@end
