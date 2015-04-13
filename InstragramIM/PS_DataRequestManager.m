//
//  DataRequestManager.m
//  iPhotoSocial
//
//  Created by MAXToooNG on 15/3/26.
//  Copyright (c) 2015年 Chen.Liu. All rights reserved.
//

#import "PS_DataRequestManager.h"

@interface PS_DataRequestManager()
{
    NSMutableDictionary *_requestDict;
}

@end
@implementation PS_DataRequestManager

static PS_DataRequestManager * manager = nil;
+ (PS_DataRequestManager *)shareDataRequestManager{
    if (manager == nil) {
        manager = [[PS_DataRequestManager alloc] init];
    }
    return manager;
}

- (id)init{
    self = [super init];
    if (self) {
        _requestDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (void)addRequest:(id)request forKey:(NSString *)urlString{
    if (request != nil) {
        [_requestDict setObject:request forKey:urlString];
    }
}

- (void)removeRequestForKey:(NSString *)urlString{
    [_requestDict removeObjectForKey:urlString];
}


@end
