//
//  DXPullToRefreshSimpleContentView.m
//  tixing
//
//  Created by Du Xin on 10/29/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXPullToRefreshSimpleContentView.h"

@implementation DXPullToRefreshSimpleContentView

- (void)setState:(SSPullToRefreshViewState)state withPullToRefreshView:(SSPullToRefreshView *)view {
  [super setState:state withPullToRefreshView:view];
  
  if (state == SSPullToRefreshViewStateReady) {
     self.statusLabel.text = @"松开更新";
  }else if(state == SSPullToRefreshViewStateNormal){
     self.statusLabel.text = @"下拉更新";
  }
}
@end
