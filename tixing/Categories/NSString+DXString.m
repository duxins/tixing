//
//  NSString+DXString.m
//  tixing
//
//  Created by Du Xin on 12/4/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "NSString+DXString.h"

@implementation NSString (DXString)

- (NSAttributedString *)dx_highlightWithString:(NSString *)string
{
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
  if (!string) return attributedString;
  
  NSArray *ranges = [self dx_rangesOfString:string];
  
  for (NSValue *value in ranges) {
    NSRange range = [value rangeValue];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
  }
  
  return attributedString;
}

// Taken from http://stackoverflow.com/a/9667382/575163
- (NSArray *)dx_rangesOfString:(NSString *)searchString
{
  NSMutableArray *results = [NSMutableArray array];
  NSRange searchRange = NSMakeRange(0, [self length]);
  NSRange range;
  while ((range = [self rangeOfString:searchString options:0 range:searchRange]).location != NSNotFound) {
    [results addObject:[NSValue valueWithRange:range]];
    searchRange = NSMakeRange(NSMaxRange(range), [self length] - NSMaxRange(range));
  }
  return results;
}
@end
