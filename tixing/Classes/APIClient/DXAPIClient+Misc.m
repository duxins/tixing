//
//  DXAPIClient+Misc.m
//  tixing
//
//  Created by Du Xin on 10/28/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXAPIClient+Misc.h"
#import "DXMacros.h"

@implementation DXAPIClient (Misc)

- (RACSignal *)checkForUpdates
{
  return [self GET:@"updates" parameters:@{@"version": DXVersionNumber}];
}

@end
