//
//  DXSoundData.h
//  tixing
//
//  Created by Du Xin on 10/24/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXSound.h"

@interface DXSoundStore : NSObject

+ (instancetype)sharedStore;
@property (nonatomic, readonly) NSArray *sounds;


/**
 *  播放自定义提示音
 *
 *  @param fileName 提示音文件名(不包括扩展名)
 */
- (void)playSound:(NSString *)fileName;

/**
 *  Get sound object by sound name
 *
 *  @param name sound name
 *
 *  @return sound object
 */
- (DXSound *)soundByName:(NSString *)name;


@end
