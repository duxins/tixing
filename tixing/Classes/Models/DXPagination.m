//
//  DXPagination.m
//  tixing
//
//  Created by Du Xin on 10/28/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXPagination.h"

@implementation DXPagination

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
  return @{
           @"nextPage": @"next_page",
           @"prevPage": @"prev_page",
           @"totalPages": @"total_pages"
           };
}

@end
