//
//  ConnectionService.m
//  My-Test-AFNetworking
//
//  Created by 韩伟 on 15/5/21.
//  Copyright (c) 2015年 韩伟. All rights reserved.
//

#import "YGConnectionService.h"
#import "AESCrypt.h"
#import "RootViewController.h"
#import "YYCache.h"
#import "YGCircleLoadingView.h"


static YGConnectionService *sConnectionService;

@implementation YGConnectionService
{
    YYCache *_myCache;
}
#pragma mark 单例模式获取 ConnectionService 对象

+ (instancetype)sharedConnectionService
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {

        sConnectionService = [[self alloc] init];

    });
    sConnectionService.netWorkStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];

    return sConnectionService;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // 1.首先实例化一个请求管理器
        self.requestManager = [AFHTTPSessionManager manager];
        self.requestManager.requestSerializer = [AFJSONRequestSerializer serializer];

        // 2.设置请求的数据格式.（不是可以改）
        // *AFHTTPRequestSerializer(二进制)
        // *AFJSONRequestSerializer(JSON)
        // *AFPropertyListRequestSerializer(Plist)
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
        self.requestManager.securityPolicy = securityPolicy;

        // 3.设置响应的数据格式：默认是JSON.（不是可以改）
        // *AFHTTPResponseSerializer(二进制)
        // *AFJSONResponseSerializer(JSON)
        // *AFPropertyListResponseSerializer(Plist)
        // *AFXMLParserResponseSerializer(XML)
        // *AFImageResponseSerializer(Image)
        // *AFCompoundResponseSerializer(组合的)
        self.requestManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestManager.requestSerializer.timeoutInterval = 20;
        _myCache = [YYCache cacheWithName:@"YGCache"];
        //加类型
        NSMutableSet *tempSet = [[NSMutableSet alloc] initWithSet:self.requestManager.responseSerializer.acceptableContentTypes];
        [tempSet addObject:@"text/plain"];
        [tempSet addObject:@"text/html"];
        self.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithSet:tempSet];

    }
    return self;
}

// 显示加载视图
- (void)showLoadingViewWithSuperView:(UIView *)superView
{
    [YGCircleLoadingView showLoadingView];
}
- (void)cancelButtonClick
{
    [self.requestManager.operationQueue cancelAllOperations];
    [self dissmissLoadingView];
}

// 隐藏加载视图
- (void)dissmissLoadingView
{
    [YGCircleLoadingView dismissLoadingView];
    [self.requestManager.operationQueue cancelAllOperations];
}

- (id)loadCacheWithURLString:(NSString *)URLString parameter:(NSDictionary *)parameters
{
    NSString *jsonString = ((NSDictionary *) parameters).mj_JSONString;
    if (!jsonString)
    {
        jsonString = @"";
    }
    return [_myCache objectForKey:[URLString stringByAppendingString:jsonString]];
}

/**
 *  优格post封装方法(不用写state为error的toast，不用写failure的toast，不用写result为0的toast，回调的responseObject是接收到的responseObject[@"data"]，不用再取data，不用写结束刷新)
 */
- (void) YGPOST:(NSString *)URLString
     parameters:(id)parameters
showLoadingView:(BOOL)flag
     scrollView:(UIScrollView *)scrollView
        success:(void (^)(id responseObject))success
        failure:(void (^)(NSError *error))failure
{

    if (_netWorkStatus == NotReachable)
    {
        [scrollView.mj_header endRefreshing];
        [scrollView.mj_footer endRefreshing];
        [YGAppTool showToastWithText:@"当前暂无网络，请检查网络设置"];
        [self dissmissLoadingView];
        if (failure)
        {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"当前暂无网络，请检查网络设置"};
            NSError *error = [NSError errorWithDomain:@"" code:404 userInfo:userInfo];
            failure(error);
            [self printErrorLogWithURLString:URLString parameters:parameters reason:error.localizedDescription];
        }
        return;
    }
    if (flag)
    {
        [self showLoadingViewWithSuperView:SYS_APPDELEGATE.window];
    }
    //    NSString *requestKey;
    //    if (parameters == nil)
    //    {
    //        requestKey = nil;
    //    }
    //    else
    //    {
    //        requestKey = [NSData getEncryptValueWithDic:parameters];
    //    }
    [self.requestManager POST:[NSString stringWithFormat:@"%@%@", SERVER_URL, URLString] parameters:parameters progress:^(NSProgress *_Nonnull uploadProgress)
    {

    }                 success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject)
    {
        [self printSuccessLogWithURLString:[NSString stringWithFormat:@"%@%@", SERVER_URL, URLString] parameters:parameters responseObject:responseObject];
        [scrollView.mj_header endRefreshing];
        [scrollView.mj_footer endRefreshing];
        if (flag)
        {
            [self dissmissLoadingView];
        }
        //如果失败就toast
        if ([responseObject[@"code"] intValue] == 1 || [responseObject[@"code"] intValue] == 99)
        {
            [YGAppTool showToastWithText:responseObject[@"msg"]];
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: responseObject[@"msg"]};
            NSError *error = [NSError errorWithDomain:@"" code:99999 userInfo:userInfo];
            if (failure)
            {
                failure(error);
            }
            return;
        }

//        //如果responseObject[@"data"]下含有result键
//        if ([[responseObject[@"data"] allKeys] containsObject:@"result"])
//        {
//            //如果result是0就toast并return
//            if (![responseObject[@"data"][@"result"] isEqualToString:@"0"])
//            {
//                [YGAppTool showToastWithText:responseObject[@"msg"]];
//                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: responseObject[@"msg"]};
//                NSError *error = [NSError errorWithDomain:@"" code:9999 userInfo:userInfo];
//                if (failure)
//                {
//                    failure(error);
//                }
//                return;
//            }
//        }


        //写缓存，先判断有没有total键
        if ([[parameters allKeys] containsObject:@"total"])
        {
            if ([parameters[@"total"] intValue] == 1)
            {
                NSString *jsonString = ((NSDictionary *) parameters).mj_JSONString;
                if (!jsonString)
                {
                    jsonString = @"";
                }
                [_myCache setObject:responseObject[@"data"] forKey:[URLString stringByAppendingString:jsonString]];
            }
        }
        else
        {
            NSString *jsonString = ((NSDictionary *) parameters).mj_JSONString;
            if (!jsonString)
            {
                jsonString = @"";
            }
            [_myCache setObject:responseObject[@"data"] forKey:[URLString stringByAppendingString:jsonString]];
        }

        //成功block
        if (success)
        {
            success(responseObject[@"data"]);
        }
    }                 failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error)
    {

        [scrollView.mj_header endRefreshing];
        [scrollView.mj_footer endRefreshing];
        if (flag)
        {
            [self dissmissLoadingView];
        }
        [YGAppTool showToastWithText:@"服务器开小差了哦"];
        //失败block
        if (failure)
        {
            failure(error);
        }
        [self printErrorLogWithURLString:URLString parameters:parameters reason:error.localizedDescription];

    }];
}

/**
 *  带图片优格post封装方法(不用写state为error的toast，不用写failure的toast，不用写result为0的toast，回调的responseObject是接收到的responseObject[@"data"]，不用再取data，不用写结束刷新)
 */
- (void)           YGPOST:(NSString *)URLString
               parameters:(id)parameters
          showLoadingView:(BOOL)flag
               scrollView:(UIScrollView *)scrollView
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure
{
    if (_netWorkStatus == NotReachable)
    {
        [scrollView.mj_header endRefreshing];
        [scrollView.mj_footer endRefreshing];
        [YGAppTool showToastWithText:@"当前暂无网络，请检查网络设置"];
        [self dissmissLoadingView];
        if (failure)
        {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"当前暂无网络，请检查网络设置"};
            NSError *error = [NSError errorWithDomain:@"" code:404 userInfo:userInfo];
            failure(error);
            [self printErrorLogWithURLString:URLString parameters:parameters reason:error.localizedDescription];
        }
        return;
    }
    if (flag)
    {
        [self showLoadingViewWithSuperView:SYS_APPDELEGATE.window];
    }

    //    NSString *requestKey;
    //    if (parameters == nil)
    //    {
    //        requestKey = nil;
    //    }
    //    else
    //    {
    //        requestKey = [NSData getEncryptValueWithDic:parameters];
    //    }

    [self.requestManager POST:[NSString stringWithFormat:@"%@api/%@", SERVER_URL, URLString] parameters:parameters constructingBodyWithBlock:^(id <AFMultipartFormData> _Nonnull formData)
    {
        block(formData);
    }                progress:^(NSProgress *_Nonnull uploadProgress)
    {

    }                 success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject)
    {
        [self printSuccessLogWithURLString:[NSString stringWithFormat:@"%@api/%@", SERVER_URL, URLString] parameters:parameters responseObject:responseObject];
        [scrollView.mj_header endRefreshing];
        [scrollView.mj_footer endRefreshing];
        if (flag)
        {
            [self dissmissLoadingView];
        }
        //如果失败就toast
        if ([responseObject[@"state"] isEqualToString:@"error"])
        {
            [YGAppTool showToastWithText:responseObject[@"msg"]];
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: responseObject[@"msg"]};
            NSError *error = [NSError errorWithDomain:@"" code:99999 userInfo:userInfo];
            if (failure)
            {
                failure(error);
            }
            return;
        }

        //如果responseObject[@"data"]下含有result键
        if ([[responseObject[@"data"] allKeys] containsObject:@"result"])
        {
            //如果result是0就toast并return
            if (![responseObject[@"data"][@"result"] isEqualToString:@"0"])
            {
                [YGAppTool showToastWithText:responseObject[@"msg"]];
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: responseObject[@"msg"]};
                NSError *error = [NSError errorWithDomain:@"" code:9999 userInfo:userInfo];
                if (failure)
                {
                    failure(error);
                }
                return;
            }
        }


        //成功block
        if (success)
        {
            success(responseObject[@"data"]);
        }
    }                 failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error)
    {

        [scrollView.mj_header endRefreshing];
        [scrollView.mj_footer endRefreshing];
        if (flag)
        {
            [self dissmissLoadingView];
        }
        [YGAppTool showToastWithText:@"服务器开小差了哦"];
        //失败block
        if (failure)
        {
            failure(error);
        }
        [self printErrorLogWithURLString:URLString parameters:parameters reason:error.localizedDescription];
    }];

}

- (void)printErrorLogWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters reason:(NSString *)reason
{
    NSLog(@"*******************\nrequest failure!\npost url:%@\npost parameter:\n%@\nerror reason:%@\n*******************\n", [NSString stringWithFormat:@"%@api/%@", SERVER_URL, URLString], parameters, reason);
}

- (void)printSuccessLogWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters responseObject:(NSDictionary *)responseObject
{
    NSLog(@"*******************\nrequest success!\npost url:%@\npost parameter:\n%@\nresponse:\n%@\n*******************\n", [NSString stringWithFormat:@"%@api/%@", SERVER_URL, URLString], parameters, responseObject);
}


@end
