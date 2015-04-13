//
//  PS_DataRequest.h
//  iPhotoSocial
//
//  Created by MAXToooNG on 15/3/26.
//  Copyright (c) 2015年 Chen.Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
@interface PS_DataRequest : NSObject
typedef void(^CompletionLoad)(NSObject *result);
@property (nonatomic,retain) NSMutableData *downloadData;

@property (nonatomic,copy) NSString *requestString;

@property (nonatomic,assign) id target;

@property (nonatomic,assign) SEL action;
@property (nonatomic,assign) NSInteger tag;

/**
 *  网络请求接口
 *
 *  @param url        请求 Url
 *  @param params      请求参数字典
 *  @param httpMethod 请求方法 "GET" or "POST"
 *  @param block       回调
 *
 *  @return 返回 RequestOperation
 */

+(AFHTTPRequestOperation *)requestWithURL:(NSString *)url params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod block:(CompletionLoad)block;

+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)url requestHeader:(NSDictionary *)header params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod block:(CompletionLoad)block;
//
//
//+ (PS_DataRequest *)getRequestWithUrlString:(NSString *)str target:(id)target action:(SEL)action tag:(NSInteger)tag;
//+ (PS_DataRequest *)postRequestWithUrlString:(NSString *)str target:(id)target action:(SEL)action tag:(NSInteger)tag;
@end
