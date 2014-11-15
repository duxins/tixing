//
//  DXMaskView.m
//  tixing
//
//  Created by Du Xin on 11/15/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXMaskView.h"

@implementation DXMaskView

- (void)drawRect:(CGRect)rect
{
  CGRect bounds = self.bounds;
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [[[UIColor blackColor] colorWithAlphaComponent:0.6f] CGColor]);
  CGContextFillRect(context, bounds);
  
  CGFloat width = self.bounds.size.width * 0.75f;
  CGFloat height = width;
  
  CGFloat x = (self.bounds.size.width - width) / 2;
  CGFloat y = 120.0f;
  
  UIBezierPath *holePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, width, height) cornerRadius:5.0];
  
  CGContextSetBlendMode(context, kCGBlendModeClear);
  CGContextAddPath(context, holePath.CGPath);
  CGContextFillPath(context);
}

@end
