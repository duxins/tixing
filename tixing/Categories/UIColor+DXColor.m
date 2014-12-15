//
//  UIColor+DXColor.m
//  tixing
//
//  Created by Du Xin on 12/15/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "UIColor+DXColor.h"

@implementation UIColor (DXColor)

+ (UIColor *)dx_tintColor {
  return [UIColor colorWithRed:0.17f green:0.48f blue:0.93f alpha:1];
}

+ (UIColor *)dx_clearButtonColor {
  return [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.6f];
}

+ (UIColor *)dx_borderColor {
  return [UIColor colorWithRed:0.85f green:0.88f blue:0.9f alpha:1];
}

@end
