//
//  NSString_DXString.m
//  tixing
//
//  Created by Du Xin on 12/16/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXTestHelper.h"
#import "NSString+DXString.h"

SpecBegin(NSStringDXString)

describe(@"-dx_highlightWithString:", ^{
  
  it(@"works correctly", ^{
    NSString *string = @"duxins@gmail.com";
    NSMutableAttributedString *expectedString = [[NSMutableAttributedString alloc] initWithString:string];
    [expectedString addAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} range:NSMakeRange(0, 6)];
    NSAttributedString *attributedString = [string dx_highlightWithString:@"duxins"];
    expect(attributedString).to.equal(expectedString);
  });
  
  it(@"can highlight multiple occurrences", ^{
    NSString *string = @"习包子进包子铺排队买包子";
    NSMutableAttributedString *expectedString = [[NSMutableAttributedString alloc] initWithString:string];
    [expectedString addAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} range:NSMakeRange(1, 2)];
    [expectedString addAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} range:NSMakeRange(4, 2)];
    [expectedString addAttributes:@{NSForegroundColorAttributeName: [UIColor redColor]} range:NSMakeRange(10, 2)];
    
    NSAttributedString *attributedString = [string dx_highlightWithString:@"包子"];
    expect(attributedString).to.equal(expectedString);
  });
});

SpecEnd
