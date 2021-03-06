//
//  DXAPIClient.m
//  tixing
//
//  Created by Du Xin on 10/20/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXAPIClient.h"
#import <AFNetworking/AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "DXCredentialStore.h"
#import "DXConfig.h"
#import "DXMacros.h"
#import <sys/utsname.h>

static NSString *kAuthTokenHeaderKey = @"Auth-Token";

@interface DXAPIClient()
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, strong) NSString *authToken;
@end

@implementation DXAPIClient

#pragma mark - 
#pragma mark Life cycle

+ (instancetype)sharedClient
{
  static id __instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __instance = [[self alloc] init];
  });
  return __instance;
}

- (id)init
{
  self = [super init];
  if(self){
    NSURL *baseURL = [NSURL URLWithString:TixingBaseURLString];
    self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    self.manager.requestSerializer.timeoutInterval = 10;
    [self.manager.requestSerializer setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];
    [self addAuthTokenToHeader];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addAuthTokenToHeader)
                                                 name:TixingNotificationTokenChanged
                                               object:nil];
  }
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addAuthTokenToHeader
{
  NSString *authToken = [DXCredentialStore sharedStore].authToken;
  [self.manager.requestSerializer setValue:authToken forHTTPHeaderField:kAuthTokenHeaderKey];
}

#pragma mark - 
#pragma mark Request Methods

- (RACSignal *)GET:(NSString *)URLString parameters:(NSDictionary *)parameters
{
  return [self requestWithMethod:@"GET" URLString:URLString parameters:parameters];
}

- (RACSignal *)POST:(NSString *)URLString parameters:(NSDictionary *)parameters
{
  return [self requestWithMethod:@"POST" URLString:URLString parameters:parameters];
}

- (RACSignal *)PATCH:(NSString *)URLString parameters:(NSDictionary *)parameters
{
  return [self requestWithMethod:@"PATCH" URLString:URLString parameters:parameters];
}

- (RACSignal *)PUT:(NSString *)URLString parameters:(NSDictionary *)parameters
{
  return [self requestWithMethod:@"PUT" URLString:URLString parameters:parameters];
}

- (RACSignal *)DELETE:(NSString *)URLString parameters:(NSDictionary *)parameters
{
  return [self requestWithMethod:@"DELETE" URLString:URLString parameters:parameters];
}

- (RACSignal *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters
{
  URLString = [[NSURL URLWithString:URLString relativeToURL:self.manager.baseURL] absoluteString];
  
  
  return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    
    
    NSError *err = nil;
    NSURLRequest *request = [self.manager.requestSerializer requestWithMethod:method
                                                                    URLString:URLString
                                                                   parameters:parameters
                                                                        error:&err];
    AFHTTPRequestOperation *operation =
      [self.manager HTTPRequestOperationWithRequest:request
                                            success:^(AFHTTPRequestOperation *op, id responseObject) {
                                              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                              DDLogDebug(@"%@ %@ %@ (%@)", method, URLString, parameters, @(op.response.statusCode));
                                              [subscriber sendNext:responseObject];
                                              [subscriber sendCompleted];
                                            } failure:^(AFHTTPRequestOperation *op, NSError *error) {
                                              DDLogDebug(@"%@ %@ %@ (%@)", method, URLString, parameters, @(op.response.statusCode));
                                              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                              
                                              NSDictionary *JSON = [self parseResponseData:op.responseData];
                                              
                                              if (JSON[@"error"]) {
                                                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: JSON[@"error"]};
                                                error = [[NSError alloc] initWithDomain:TixingAPIErrorDomain code:[JSON[@"code"] integerValue] userInfo:userInfo];
                                              }
                                              
                                              [subscriber sendError:error];
                                            }];
    
    [self.manager.operationQueue addOperation:operation];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    return [RACDisposable disposableWithBlock:^{
      [operation cancel];
    }];
  }] doError:^(NSError *error) {
  }];
}

- (id)parseResponseData:(NSData *)data
{
  if (!data) {
    return nil;
  }
  
  return [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

#pragma mark -
#pragma mark Private methods
- (NSString *)userAgent
{
  NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
  struct utsname systemInfo;
  uname(&systemInfo);
  NSString *machineName = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
  return [NSString stringWithFormat:@"tixing/%@.%@ (%@; iOS %@; Scale/%@)",
          DXVersionNumber, DXBuildNumber, machineName, systemVersion, @([UIScreen mainScreen].scale)];
}


@end
