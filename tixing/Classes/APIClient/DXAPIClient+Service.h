//
//  DXAPIClient+Service.h
//  tixing
//
//  Created by Du Xin on 10/20/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXAPIClient.h"

@interface DXAPIClient (Service)

- (RACSignal *)retrieveServices;
- (RACSignal *)retrieveServiceWithId:(NSString *)serviceId;
- (RACSignal *)installServiceWithId:(NSString *)serviceId;
- (RACSignal *)removeServiceWithId:(NSString *)serviceId;

@end
