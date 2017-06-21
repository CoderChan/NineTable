//
//  HTTPManager.m
//  FYQ
//
//  Created by Chan_Sir on 2016/11/25.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import "HTTPManager.h"
#import "HTTPLimiteCache.h"

@implementation HTTPManager

#pragma mark - 普通GET
+(void)GET:(NSString *)url params:(NSDictionary *)params
   success:(YLRMResponseSuccess)success fail:(YLRMResponseFail)fail{
    
    AFHTTPSessionManager *manager = [HTTPManager managerWithBaseURL:nil sessionConfiguration:NO];
    
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *URL = [url stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    [manager GET:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = [HTTPManager responseConfiguration:responseObject];
        
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}

#pragma mark - GET缓存
+ (void)GETCache:(NSString *)url parameter:(id)parameter success:(SuccessCacheBlock)success failure:(FailCacheBlock)fail
{
    HTTPLimiteCache *cacheManager = [HTTPLimiteCache shareInstance];
    NSData *data = [cacheManager getDataWithNameString:url];
    if (data) {
        KGLog(@"读取缓存成功");
        success(data);
    }else{
        AFHTTPSessionManager *manager = [HTTPManager managerWithBaseURL:nil sessionConfiguration:NO];
        
        NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
        NSString *URL = [url stringByAddingPercentEncodingWithAllowedCharacters:set];
        [manager GET:URL parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 存入缓存
            [cacheManager saveWithData:responseObject andNameString:url];
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            fail(error);
        }];
    }
}

#pragma mark - 普通POST
+(void)POST:(NSString *)url params:(NSDictionary *)params
    success:(YLRMResponseSuccess)success fail:(YLRMResponseFail)fail{
    
    AFHTTPSessionManager *manager = [HTTPManager managerWithBaseURL:nil sessionConfiguration:NO];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *URL = [url stringByAddingPercentEncodingWithAllowedCharacters:set];
    [manager POST:URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = [HTTPManager responseConfiguration:responseObject];
        
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}

#pragma mark - 上传文件
+ (void)uploadWithURL:(NSString *)url params:(NSDictionary *)params fileData:(NSData *)filedata name:(NSString *)name fileName:(NSString *)filename mimeType:(NSString *)mimeType progress:(YLRMProgress)progress success:(YLRMResponseSuccess)success fail:(YLRMResponseFail)fail
{
    AFHTTPSessionManager *manager = [HTTPManager managerWithBaseURL:nil sessionConfiguration:NO];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *URL = [url stringByAddingPercentEncodingWithAllowedCharacters:set];
    [manager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:filedata name:name fileName:filename mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = [HTTPManager responseConfiguration:responseObject];
        success(task,dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}

#pragma mark - 上传多张图片
+ (void)uploadFilesWithURL:(NSString *)url params:(NSDictionary *)params fileArray:(NSArray *)fileArray progress:(YLRMProgress)progress success:(YLRMResponseSuccess)success fail:(YLRMResponseFail)fail
{
    AFHTTPSessionManager *manager = [HTTPManager managerWithBaseURL:nil sessionConfiguration:NO];
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *URL = [url stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    [manager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 上传 多张图片
        for(NSInteger i = 0; i < fileArray.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation([fileArray objectAtIndex: i], 0.5);
//            NSData *imageData = UIImagePNGRepresentation([fileArray objectAtIndex: i]);
            // 上传的参数名
            NSString *name = [NSString stringWithFormat:@"image%d",(int)(i+1)];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpeg",name];
            NSLog(@"fileName = %@",fileName);
            
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [HTTPManager responseConfiguration:responseObject];
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}

#pragma mark - 其他方法
+(AFHTTPSessionManager *)managerWithBaseURL:(NSString *)baseURL  sessionConfiguration:(BOOL)isconfiguration{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager =nil;
    
    NSURL *url = [NSURL URLWithString:baseURL];
    
    if (isconfiguration) {
        
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:configuration];
    }else{
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    
    //申明请求的数据是json类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    [manager.requestSerializer setTimeoutInterval:20.0];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    return manager;
}
+(id)responseConfiguration:(id)responseObject{
    
    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    return dic;
}



@end
