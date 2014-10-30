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
  
  layer = self.cardView.layer;
  layer.cornerRadius = 4;
  layer.masksToBounds = YES;
  layer.borderWidth = 1.0f;
  layer.borderColor = [UIColor colorWithRed:0.85f green:0.88f blue:0.9f alpha:1].CGColor;
  self.selectionStyle = UITableViewCellSelectionStyleNone;
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
  self.ballonView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.97f alpha:1];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
  [super setHighlighted:highlighted animated:animated];
  if (highlighted) {
    self.cardView.backgroundColor = [UIColor colorWithWhite:0.975f alpha:1];
    [self updateBallonViewBackground];
  }else{
    self.cardView.backgroundColor = [UIColor whiteColor];
  }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
  [super setSelected:selected animated:animated];
  if (selected) {
    self.cardView.backgroundColor = [UIColor colorWithWhite:0.975f alpha:1];
    [self updateBallonViewBackground];
  }else{
    self.cardView.backgroundColor = [UIColor whiteColor];
  }
}

@end
