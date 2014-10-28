//
//  DXPagination.h
//  tixing
//
//  Created by Du Xin on 10/28/14.
//  Copyright (c) 2014 Xin Du. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface DXPagination : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign) NSInteger nextPage;
@property (nonatomic, assign) NSInteger prevPage;
@property (nonatomic, assign) NSInteger totalPages;

@end
