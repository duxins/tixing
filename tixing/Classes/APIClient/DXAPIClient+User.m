//
//  DXAPIClient+User.m
//  tixing
//
//  Created by Du Xin on 10/20/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXAPIClient+User.h"
#import "DXCredentialStore.h"

@implementation DXAPIClient (User)

- (RACSignal *)loginWithEmail:(NSString *)email password:(NSString *)password
{
  return [[self POST:@"login"
         parameters:@{
                      @"email": email,
                      @"password": password
                      }] doNext:^(NSDictionary *result) {
            DDLogDebug(@"Login successfully.");
            NSString *authToken = result[@"auth_token"];
            if(authToken){
              [DXCredentialStore sharedStore].authToken = authToken;
            }
         }];
}

- (RACSignal *)retrieveMyInfo
{
  return [self GET:@"user" parameters:nil];
}

@end