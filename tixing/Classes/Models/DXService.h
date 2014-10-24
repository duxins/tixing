//
//  Service.h
//  tixing
//
//  Created by Du Xin on 10/24/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface DXService : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *serviceId;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSURL *iconURL;
@property (nonatomic, readonly) NSURL *URL;

@end
