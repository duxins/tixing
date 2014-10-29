//
//  DXNotificationCell.m
//  tixing
//
//  Created by Du Xin on 10/28/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXNotificationCell.h"

@interface DXNotificationCell()
@property (nonatomic, weak) IBOutlet UIView *ballonView;
@end

@implementation DXNotificationCell

- (void)awakeFromNib {
  CALayer *layer = self.thumbImageView.layer;
  layer.cornerRadius = 4;
  layer.masksToBounds = YES;
  [self updateBallonViewBackground];
}


- (void)layoutSubviews
{
  [super layoutSubviews];
  [self.contentView setNeedsLayout];
  [self.contentView layoutIfNeeded];
  self.messageLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.messageLabel.frame);
}

- (void)updateBallonViewBackground
{
  self.ballonView.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.95f alpha:1];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
  [super setHighlighted:highlighted animated:animated];
  if (highlighted) {
    [self updateBallonViewBackground];
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
  [super setSelected:selected animated:animated];
  if (selected) {
    [self updateBallonViewBackground];
  }
}

@end
