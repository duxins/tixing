//
//  DXNotification.m
//  tixing
//
//  Created by Du Xin on 10/28/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXNotification.h"
#import "DXService.h"

@implementation DXNotification

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"notificationId": @"id",
           @"message": @"message",
           @"service": @"service"
           };
}

+ (NSValueTransformer *)servicesJSONTransformer {
  return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *services) {
    return [MTLJSONAdapter modelOfClass:[DXService class] fromJSONDictionary:services error:nil];
  }];
}

@end
