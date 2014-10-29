//
//  NSDate+DXDate.h
//  tixing
//
//  Created by Du Xin on 10/29/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DXDate)

- (NSString *)dx_timeAgoWithDateFormatter:(NSDateFormatter *)dateFormatter;

@end
