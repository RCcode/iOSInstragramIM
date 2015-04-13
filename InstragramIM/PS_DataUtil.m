//
//  DataUtil.m
//  BeautyCameraDemo
//
//  Created by MAXToooNG on 14-5-16.
//  Copyright (c) 2014年 MAXToooNG. All rights reserved.
//

#import "PS_DataUtil.h"

@implementation PS_DataUtil
static PS_DataUtil *dataUtil = nil;


+ (PS_DataUtil *)defaultDateUtil{
    if (dataUtil == nil) {
        dataUtil = [[PS_DataUtil alloc] init];
        dataUtil.c_teamArray = [[NSMutableArray alloc] init];
    }
    return dataUtil;
}

@end
