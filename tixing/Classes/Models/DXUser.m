//
//  DXUser.m
//  tixing
//
//  Created by Du Xin on 10/25/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXUser.h"
#import "DXSoundStore.h"
#import "DXService.h"

@implementation DXUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"userId":     @"id",
           @"name":       @"name",
           @"services":   @"services",
           @"sound":      @"sound",
           @"silentAtNight": @"silent_at_night",
           @"authToken":  @"auth_token"
           };
}

+ (NSValueTransformer *)servicesJSONTransformer {
  return [MTLValueTransformer transformerWithBlock:^id(NSArray *services) {
    return [MTLJSONAdapter modelsOfClass:[DXService class] fromJSONArray:services error:nil];
  }];
}

@end
