//
//  Service.m
//  tixing
//
//  Created by Du Xin on 10/24/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXService.h"

@implementation DXService

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"serviceId" :  @"id",
           @"name"      :  @"name",
           @"iconURL"   :  @"icon",
           @"URL"       :  @"url",
           @"desc"      :  @"description"
          };
}

+ (NSValueTransformer *)URLJSONTransformer {
  return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)iconURLJSONTransformer {
  return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
