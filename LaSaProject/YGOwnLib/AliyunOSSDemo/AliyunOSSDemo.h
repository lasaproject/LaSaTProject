//
//  oss_ios_demo.h
//  oss_ios_demo
//
//  Created by zhouzhuo on 9/16/15.
//  Copyright (c) 2015 zhouzhuo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AliyunOSSDemo : NSObject

+ (instancetype)sharedInstance;

- (void)initOSSClientWithAccessKeyId:(NSString *)accessKeyId secretKeyId:(NSString *)secretKeyId securityToken:(NSString *)securityToken;

/**
 上传文件到阿里云(文件形式)
 
 @param url 文件路径url
 @param fileSuffixString 上传到阿里云的文件后缀(如.mp4,.png)
 @param progressHandler 上传进度回调
 @param completeHandler 上传完成回调,error错误,urlString网址
 */
- (void)uploadFileWithFileURL:(NSURL *)url fileSuffix:(NSString *)fileSuffixString progressHandler:(void (^)(float percent))progressHandler completeHandler:(void (^)(NSError *error, NSString *urlString))completeHandler;


/**
 上传文件到阿里云(文件流形式)
 
 @param fileData 文件流
 @param fileSuffixString 上传到阿里云的文件后缀(如.mp4,.png)
 @param progressHandler 上传进度回调
 @param completeHandler 上传完成回调,error错误,urlString网址
 */
- (void)uploadFileWithFileData:(NSData *)fileData fileSuffix:(NSString *)fileSuffixString progressHandler:(void (^)(float percent))progressHandler completeHandler:(void (^)(NSError *error, NSString *urlString))completeHandler;


@end
