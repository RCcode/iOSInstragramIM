//
//  DataRequestManager.h
//  iPhotoSocial
//
//  Created by MAXToooNG on 15/3/26.
//  Copyright (c) 2015年 Chen.Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PS_DataRequestManager : NSObject

+ (PS_DataRequestManager *)shareDataRequestManager;

- (void)addRequest: (id)request forKey:(NSString *)urlString;

- (void)removeRequestForKey:(NSString *)urlString;

@end
