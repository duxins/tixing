//
//  DXAPIClient+User.h
//  tixing
//
//  Created by Du Xin on 10/20/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXAPIClient.h"

@interface DXAPIClient (User)

- (RACSignal *)loginWithEmail:(NSString *)email password:(NSString *)password;
- (RACSignal *)retrieveMyInfo;
@end
