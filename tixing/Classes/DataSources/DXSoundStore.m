//
//  DXSoundData.m
//  tixing
//
//  Created by Du Xin on 10/24/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "DXSoundStore.h"
#import "DXSound.h"

@interface DXSoundStore()
@property(nonatomic, readwrite) NSArray *sounds;
@end

@implementation DXSoundStore

+ (instancetype)sharedStore
{
  static id __instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __instance = [self new];
  });
  return __instance;
}

#pragma mark - 
#pragma mark Accessors

- (NSArray *)sounds
{
  if (!_sounds) {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sounds" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *JSONArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    _sounds = [MTLJSONAdapter modelsOfClass:[DXSound class] fromJSONArray:JSONArray error:nil];
  }
  return _sounds;
}

#pragma mark -
#pragma mark Helper methods
- (DXSound *)soundByName:(NSString *)name;
{
  __block DXSound *found;
  [self.sounds enumerateObjectsUsingBlock:^(DXSound *obj, NSUInteger idx, BOOL *stop) {
    if ([obj.name isEqualToString:name]) {
      found = obj;
      *stop = YES;
    }
  }];
  return found;
}
@end
