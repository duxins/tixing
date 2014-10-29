//
//  DXNotificationCell.m
//  tixing
//
//  Created by Du Xin on 10/28/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXNotificationCell.h"

@implementation DXNotificationCell

- (void)awakeFromNib {
  CALayer *layer = self.thumbImageView.layer;
  layer.cornerRadius = 4;
  layer.masksToBounds = YES;
}


- (void)layoutSubviews
{
  [super layoutSubviews];
  [self.contentView setNeedsLayout];
  [self.contentView layoutIfNeeded];
  self.messageLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.messageLabel.frame);
}

@end
