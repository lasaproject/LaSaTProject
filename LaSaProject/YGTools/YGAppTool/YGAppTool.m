
//
//  YGAppTool.m
//  FindingSomething
//0
//  Created by 韩伟 on 15/10/7.
//  Copyright © 2015年 韩伟. All rights reserved.
//

#import "FCUUID.h"
#import "MBProgressHUD.h"
#import "YGShareView.h"
#import "CommonCrypto/CommonDigest.h"

@implementation YGAppTool

/**
 *  得到app名称
 *
 *  @return app名称
 */
+ (NSString *)getAppName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return infoDictionary[@"CFBundleDisplayName"];
}

/**
 *  得到app版本
 *
 *  @return app版本
 */
+ (NSString *)getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return infoDictionary[@"CFBundleShortVersionString"];
}

/**
 * 得到APP图片
 *
 * @return UIImage的appicon
 */
+ (UIImage *)getAppIconImage
{
    return [UIImage imageNamed:[[[NSBundle mainBundle] infoDictionary][@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"] lastObject]];
}

/**
 *  得到UUID（唯一）
 *
 *  @return 获得的UUID
 */
+ (NSString *)getUUID
{
    NSLog(@"-------%@--------", [FCUUID uuidForDevice]);
    return [FCUUID uuidForDevice];
}

/**
 *  得到ios系统版本
 *
 *  @return ios系统版本
 */
+ (float)getIOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

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
+ (void)shareWithShareUrl:(NSString *)shareUrl shareTitle:(NSString *)shareTitle shareDetail:(NSString *)shareDetail shareImage:(id)shareImage shareController:(UIViewController *)shareController sharePlatform:(UMSocialPlatformType)platform isPureImage:(BOOL)isPureImage
{

    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];

    if(isPureImage)
    {
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        shareObject.shareImage = shareImage;
        messageObject.shareObject = shareObject;
    }
    else
    {
        UIImage *cachedImage;
        if([shareImage isKindOfClass:[NSString class]])
        {
            cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:shareImage];
            if (cachedImage == nil)
            {
                cachedImage = [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:shareImage]]];
            }
        }
        else
        {
            cachedImage = shareImage;
        }

        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:shareTitle descr:shareDetail thumImage:cachedImage];
        //设置网页地址
        shareObject.webpageUrl = shareUrl;
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
    }

    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:shareController completion:^(id data, NSError *error)
    {
        if (error)
        {
            NSLog(@"************Share fail with error %@*********", error);
        }
        else
        {
            NSLog(@"response data is %@", data);
        }
    }];
}

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
+ (void)shareWithShareUrl:(NSString *)shareUrl shareTitle:(NSString *)shareTitle shareDetail:(NSString *)shareDetail shareImage:(id)shareImage shareController:(UIViewController *)shareController isPureImage:(BOOL)isPureImage
{
    __weak typeof(self) weakSelf = self;
    //显示分享面板
    YGShareView *shareView = [[YGShareView alloc] init];
    [shareView show];
    [shareView buttonClickBlock:^(NSInteger buttonIndex)
    {
        UMSocialPlatformType platform = 0;
        switch (buttonIndex)
        {
            case 0:
            {
                platform = UMSocialPlatformType_WechatSession;
            }
                break;
            case 1:
            {
                platform = UMSocialPlatformType_WechatTimeLine;
            }
                break;
            case 2:
            {
                platform = UMSocialPlatformType_QQ;
            }
                break;
            case 3:
            {
                platform = UMSocialPlatformType_Sina;
            }
                break;
        }
        [weakSelf shareWithShareUrl:shareUrl shareTitle:shareTitle shareDetail:shareDetail shareImage:shareImage shareController:shareController sharePlatform:platform isPureImage:isPureImage];
    }];
}

/**
 *  创建statusBar上的toast
 *
 *  @param text 要显示的文字
 */
+ (void)showToastWithText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:SYS_APPDELEGATE.window animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = text;
    hud.detailsLabel.font = [UIFont systemFontOfSize:17];
    hud.animationType = MBProgressHUDAnimationZoomIn;
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    [hud hideAnimated:YES afterDelay:2];
}

/**
 *  将int快速转为string
 *
 *  @param value 要转换的int
 *
 *  @return 返回的string
 */
+ (NSString *)stringValueWithInt:(int)value
{
    return [NSString stringWithFormat:@"%d", value];
}

/**
 * 注册推送
 */
+ (void)registerRemoteNotification
{
    // 判读系统版本是否是“iOS 8.0”以上
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ||
            [UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        // 定义用户通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        // 定义用户通知设置
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        // 注册用户通知 - 根据用户通知设置
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    { // iOS8.0 以前远程推送设置方式
        // 定义远程通知类型(Remote.远程 - Badge.标记 Alert.提示 Sound.声音)
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        // 注册远程通知 -根据远程通知类型
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}
+ (NSString *)md5:(NSString *)inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (uint32_t)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
    
}

+(void)requestWithApi:(NSString *)url param:(NSMutableDictionary *)param thenSuccess:(void (^)(NSDictionary *responseObject))success fail:(void (^)(void))fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !success ? : success(responseObject);
        });
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            !fail ? : fail();
        });
    }];
}

//截图功能
+ (UIImage *)captureImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
