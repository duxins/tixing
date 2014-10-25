//
//  DXAPIClient+User.h
//  tixing
//
//  Created by Du Xin on 10/20/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXAPIClient.h"

@interface DXAPIClient (User)

- (RACSignal *)loginWithName:(NSString *)name password:(NSString *)password;
- (RACSignal *)retrieveMyInfo;
- (RACSignal *)updateCustomSound:(NSString *)sound;
@end
