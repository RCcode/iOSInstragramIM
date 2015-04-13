//
//  UserModel.m
//  InstragramIM
//
//  Created by lisongrc on 15-4-11.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        _uid = value;
    }
}

@end
