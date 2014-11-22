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
           @"title": @"title",
           @"message": @"message",
           @"thumbURL": @"thumb",
           @"URL": @"url",
           @"webURL": @"web_url",
           @"service": @"service",
           @"createdAt": @"created_at",
           };
}

+ (NSDateFormatter *)dateFormatter
{
  static NSDateFormatter *dateFormatter;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
  });
  return dateFormatter;
}

+ (NSValueTransformer *)serviceJSONTransformer {
  return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *services) {
    return [MTLJSONAdapter modelOfClass:[DXService class] fromJSONDictionary:services error:nil];
  }];
}

+ (NSValueTransformer *)createdAtJSONTransformer {
  return [MTLValueTransformer transformerWithBlock:^id(NSString *str) {
    return [self.dateFormatter dateFromString:str];
  }];
}

+ (NSValueTransformer *)thumbURLJSONTransformer {
  return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)URLJSONTransformer {
  return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)webURLJSONTransformer {
  return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
