//
//  DXUser.h
//  tixing
//
//  Created by Du Xin on 10/25/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface DXUser : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *userId;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *authToken;
@property (nonatomic, copy, readonly) NSString *sound;
@property (nonatomic, strong) NSArray *services;

@end
