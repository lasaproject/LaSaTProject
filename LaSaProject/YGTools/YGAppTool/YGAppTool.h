//
//  YGAppTool.h
//  FindingSomething
//
//  Created by 韩伟 on 15/10/7.
//  Copyright © 2015年 韩伟. All rights reserved.
//  万能工具类
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>

@interface YGAppTool : NSObject

/**
 *  得到app名称
 *
 *  @return app名称
 */
+ (NSString *)getAppName;

/**
 *  得到app版本
 *
 *  @return app版本
 */
+ (NSString *)getAppVersion;

/**
 * 得到APP图片
 *
 * @return UIImage的appicon
 */
+ (UIImage *)getAppIconImage;

/**
 *  得到UUID（唯一）
 *
 *  @return 获得的UUID
 */
+ (NSString *)getUUID;

/**
 *  得到ios系统版本
 *
 *  @return ios系统版本
 */
+ (float)getIOSVersion;

/**
 *  快速创建友盟分享（无界面）
 *
 *  @param shareUrl        分享链接
 *  @param shareDetail     分享详情
 *  @param shareImage      分享图片url（如果是纯图片则是uiimage）
 *  @param shareController 调用的vc
 *  @param platform        平台
 *  @param isPureImage     是否纯图片分享
 */
+ (void)shareWithShareUrl:(NSString *)shareUrl shareTitle:(NSString *)shareTitle shareDetail:(NSString *)shareDetail shareImage:(id)shareImage shareController:(UIViewController *)shareController sharePlatform:(UMSocialPlatformType)platform isPureImage:(BOOL)isPureImage;

/**
 *  快速创建友盟分享
 *
 *  @param shareUrl        分享链接
 *  @param shareTitle      分享标题
 *  @param shareDetail     分享详情
 *  @param shareImage      分享图片url（如果是纯图片则是uiimage）
 *  @param shareController 调用的VC
 *  @param isPureImage     是否纯图片分享
 */
+ (void)shareWithShareUrl:(NSString *)shareUrl shareTitle:(NSString *)shareTitle shareDetail:(NSString *)shareDetail shareImage:(id)shareImage shareController:(UIViewController *)shareController isPureImage:(BOOL)isPureImage;

/**
 *  创建statusBar上的toast
 *
 *  @param text 要显示的文字
 */
+ (void)showToastWithText:(NSString *)text;

/**
 *  将int快速转为string
 *
 *  @param value 要转换的int
 *
 *  @return 返回的string
 */
+ (NSString *)stringValueWithInt:(int)value;

/**
 * 注册推送
 */
+ (void)registerRemoteNotification;
/*****
 MD5 加密
 *****/
+ (NSString *)md5:(NSString *)inPutText;


/**
 网络GET方法

 @param url 请求地址
 @param param 参数
 @param success 成功回调
 @param fail 失败的回调
 */
+(void)requestWithApi:(NSString *)url param:(NSMutableDictionary *)param thenSuccess:(void (^)(NSDictionary *responseObject))success fail:(void (^)(void))fail;



/**
 截屏功能

 @param view 需要截屏的视图
 @return 返回的截屏图片
 */
+ (UIImage *)captureImageFromView:(UIView *)view;

@end
