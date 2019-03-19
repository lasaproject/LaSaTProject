//
//  oss_ios_demo.m
//  oss_ios_demo
//
//  Created by zhouzhuo on 9/16/15.
//  Copyright (c) 2015 zhouzhuo. All rights reserved.
//

#import "AliyunOSSDemo.h"
#import <AliyunOSSiOS/OSSService.h>

NSString * const endPoint = @"http://oss-cn-shenzhen.aliyuncs.com";
NSString * const AccessKeyId = @"tHq06YKnU9HvIYGu";
NSString * const AccessKeySecret = @"MgSL1pAjgd91w4V5JN7Gtlluu92UT7";
NSString * const bucketName = @"bitpaipai";

OSSClient * client;
static dispatch_queue_t queue4demo;

@implementation AliyunOSSDemo

+ (instancetype)sharedInstance {
    static AliyunOSSDemo *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [AliyunOSSDemo new];
    });
    return instance;
}

- (void)initOSSClientWithAccessKeyId:(NSString *)accessKeyId secretKeyId:(NSString *)secretKeyId securityToken:(NSString *)securityToken{
    
    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:accessKeyId secretKeyId:secretKeyId securityToken:securityToken];
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 2;
    conf.timeoutIntervalForRequest = 30;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential clientConfiguration:conf];
    
}

//异步上传视频
- (void)uploadFileWithFileURL:(NSURL *)url fileSuffix:(NSString *)fileSuffixString progressHandler:(void (^)(float percent))progressHandler completeHandler:(void (^)(NSError *error, NSString *urlString))completeHandler
{
    //fileSuffixString   _ios.mp4
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = bucketName;
    put.uploadingFileURL = url;
    NSString *mdStr = [YGAppTool md5:[NSString stringWithFormat:@"%f%@",[[NSDate date] timeIntervalSince1970] * 1000, [YGAppTool getUUID]]];
    put.objectKey = [NSString stringWithFormat:@"%@/coinRowReleaseVideo/%@%@",bucketName,mdStr,fileSuffixString];
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        float percent = (float)totalByteSent/(float)totalBytesExpectedToSend;
        if(progressHandler)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                progressHandler(percent);
            });
        }
        
    };
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str;
            if (!task.error)
            {
                str = [NSString stringWithFormat:@"http://%@.oss-cn-shenzhen.aliyuncs.com/%@",put.bucketName,put.objectKey];
            }
            else
            {
                //上传失败 设置object为 no
                [YGAppTool showToastWithText:@"上传失败"];
            }
            if(completeHandler)
            {
                completeHandler(task.error, str);
            }
        });
        return nil;
    }];
}

//异步上传文件
- (void)uploadFileWithFileData:(NSData *)fileData fileSuffix:(NSString *)fileSuffixString progressHandler:(void (^)(float percent))progressHandler completeHandler:(void (^)(NSError *error, NSString *urlString))completeHandler
{
    
    //fileSuffixString   _ios.png
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = bucketName;
    put.uploadingData = fileData;
    NSString *mdStr = [YGAppTool md5:[NSString stringWithFormat:@"%f%@",[[NSDate date] timeIntervalSince1970] * 1000, [YGAppTool getUUID]]];
    put.objectKey = [NSString stringWithFormat:@"%@/coinRowReleaseImage/%@%@",bucketName,mdStr,fileSuffixString];
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        float percent = (float)totalByteSent/(float)totalBytesExpectedToSend;
        if(progressHandler)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                progressHandler(percent);
            });
        }
    };
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str;
            if (!task.error)
            {
                str = [NSString stringWithFormat:@"http://%@.oss-cn-shenzhen.aliyuncs.com/%@",put.bucketName,put.objectKey];
            }
            else
            {
                //上传失败 设置object为 no
                [YGAppTool showToastWithText:@"上传失败"];
            }
            if(completeHandler)
            {
                completeHandler(task.error, str);
            }
        });
        return nil;
    }];
}
@end
