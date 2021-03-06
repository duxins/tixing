//
//  DXAPIClient+Service.m
//  tixing
//
//  Created by Du Xin on 10/20/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXAPIClient+Service.h"
#import "DXService.h"

@implementation DXAPIClient (Service)

- (RACSignal *)retrieveServices
{
  return [[self GET:@"services" parameters:nil]
    tryMap:^id(NSDictionary *result, NSError *__autoreleasing *errorPtr) {
      NSArray *installed = [MTLJSONAdapter modelsOfClass:[DXService class]
                                           fromJSONArray:result[@"installed"]
                                                   error:errorPtr];
      if (!installed) return nil;
      
      NSArray *uninstalled = [MTLJSONAdapter modelsOfClass:[DXService class]
                                             fromJSONArray:result[@"uninstalled"]
                                                     error:errorPtr];
      if (!uninstalled) return nil;
      
      return @{
             @"installed": installed,
             @"uninstalled": uninstalled
             };
    }];
}

- (RACSignal *)retrieveServiceWithId:(NSString *)serviceId
{
  NSString *urlString = [NSString stringWithFormat:@"services/%@", serviceId];
  return [self GET:urlString parameters:nil];
}

- (RACSignal *)installServiceWithId:(NSString *)serviceId
{
  NSString *urlString = [NSString stringWithFormat:@"services/%@/installation", serviceId];
  return [self PUT:urlString parameters:nil];
}

- (RACSignal *)uninstallServiceWithId:(NSString *)serviceId
{
  NSString *urlString = [NSString stringWithFormat:@"services/%@/installation", serviceId];
  return [self DELETE:urlString parameters:nil];
}

- (RACSignal *)updateServicePreferences:(NSDictionary *)preferences withServiceId:(NSString *)serviceId
{
  NSString *urlString = [NSString stringWithFormat:@"services/%@/installation", serviceId];
  return [self PATCH:urlString parameters:preferences];
}

@end
