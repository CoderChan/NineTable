//
//  HTTPManager.h
//  FYQ
//
//  Created by Chan_Sir on 2016/11/25.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

/******** 顾名思义--HTTP管理者 ********/


/**
 *  宏定义请求成功的block
 *
 *  @param responseObject 请求成功返回的数据
 */
typedef void (^YLRMResponseSuccess)(NSURLSessionDataTask * task,id responseObject);

/**
 *  宏定义请求失败的block
 *
 *  @param error 报错信息
 */
typedef void (^YLRMResponseFail)(NSURLSessionDataTask * task, NSError * error);

/**
 *  上传或者下载的进度
 *
 *  @param progress 进度
 */

typedef void (^YLRMProgress)(NSProgress *progress);

/** 缓存时的回调 */
typedef void(^SuccessCacheBlock) (id responseObject);
typedef void(^FailCacheBlock) (NSError * error);


@interface HTTPManager : NSObject

/**
 
 *  普通get方法请求网络数据
 *
 *  @param url     请求网址路径
 *  @param params  请求参数
 *  @param success 成功回调
 *  @param fail    失败回调
 */
+ (void)GET:(NSString *)url
    params:(NSDictionary *)params success:(YLRMResponseSuccess)success
      fail:(YLRMResponseFail)fail;


/**
 需要读取缓存的请求方式
 
 @param url 拼接的url
 @param parameter 参数
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)GETCache:(NSString *)url parameter:(id)parameter success:(SuccessCacheBlock)success failure:(FailCacheBlock)fail;

/**
 *  普通post方法请求网络数据
 *
 *  @param url     请求网址路径
 *  @param params  请求参数
 *  @param success 成功回调
 *  @param fail    失败回调
 */
+ (void)POST:(NSString *)url
     params:(NSDictionary *)params
    success:(YLRMResponseSuccess)success
       fail:(YLRMResponseFail)fail;


/**
 *  普通路径上传文件（图片、小视频、文件等）
 *
 *  @param url      请求网址路径
 *  @param params   请求参数
 *  @param filedata 文件
 *  @param name     指定参数名
 *  @param filename 文件名（要有后缀名）
 *  @param mimeType 文件类型
 *  @param progress 上传进度
 *  @param success  成功回调
 *  @param fail     失败回调
 */

+ (void)uploadWithURL:(NSString *)url
              params:(NSDictionary *)params
            fileData:(NSData *)filedata
                name:(NSString *)name
            fileName:(NSString *)filename
            mimeType:(NSString *) mimeType
            progress:(YLRMProgress)progress
             success:(YLRMResponseSuccess)success
                fail:(YLRMResponseFail)fail;

/**
 上传多张图片
 
 @param url 路径
 @param params 参数
 @param fileArray 图片数组
 @param progress 进度回调
 @param success 成功回调
 @param fail 失败回调
 */
+ (void)uploadFilesWithURL:(NSString *)url
                    params:(NSDictionary *)params
                 fileArray:(NSArray *)fileArray
                  progress:(YLRMProgress)progress
                   success:(YLRMResponseSuccess)success
                      fail:(YLRMResponseFail)fail;


@end
