//
//  DXAPIClient+Device.h
//  tixing
//
//  Created by Du Xin on 10/20/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXAPIClient.h"

@interface DXAPIClient (Device)

- (RACSignal *)updateDeviceToken:(NSString *)deviceToken;
- (RACSignal *)revokeDeviceToken:(NSString *)deviceToken;

@end
