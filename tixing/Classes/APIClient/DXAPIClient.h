//
//  DXAPIClient.h
//  tixing
//
//  Created by Du Xin on 10/20/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NSError+DXError.h"

@interface DXAPIClient : NSObject

+ (instancetype)sharedClient;
- (RACSignal *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters;
- (RACSignal *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters;
- (RACSignal *)PUT:(NSString *)URLString parameters:(NSDictionary *)parameters;
- (RACSignal *)DELETE:(NSString *)URLString parameters:(NSDictionary *)parameters;

@end


#import "DXAPIClient+User.h"
#import "DXAPIClient+Device.h"
#import "DXAPIClient+Notification.h"
#import "DXAPIClient+Service.h"
#import "DXAPIClient+Misc.h"

