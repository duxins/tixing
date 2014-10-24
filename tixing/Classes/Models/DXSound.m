//
//  DXSound.m
//  tixing
//
//  Created by Du Xin on 10/24/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXSound.h"

@implementation DXSound

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"name": @"name",
           @"label": @"label"
           };
}

- (BOOL)isEqual:(id)object
{
  if (![object isKindOfClass:[DXSound class]]) {
    return NO;
  }
  
  if ([self.name isEqualToString:((DXSound *)object).name]) {
    return YES;
  }
  return NO;
}

@end
