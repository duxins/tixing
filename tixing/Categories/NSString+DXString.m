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
  
  NSRange range = [self rangeOfString:string];
  if (range.location != NSNotFound) {
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
  }
  return attributedString;
}
@end
