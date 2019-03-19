//
//  AppDelegate.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/7/27.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "UMMobClick/MobClick.h"
#import "IQKeyboardManager.h"
#import "EBForeNotification.h"
#import "SMS_SDK/SMSSDK.h"
#import "HomePageViewController.h"
#import "YGNavigationController.h"

@interface AppDelegate ()
{
    NSMutableDictionary *_localUserInfo;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    /**
     *  IQKeyBoardManager
     */
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = NO;
    manager.enableAutoToolbar = YES;
    manager.toolbarManageBehaviour = IQAutoToolbarByPosition;
    manager.toolbarTintColor = COLOR_MAIN;
    
    /**
     *  推送
     */
    [YGAppTool registerRemoteNotification];
    _localUserInfo = [[NSMutableDictionary alloc] init];
    _pushState = ReceivePushStateNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickPushAction) name:EBBannerViewDidClick object:nil];
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey])
    {
        _pushState = ReceivePushStateDeadClickPush;
    }
    
    /**
     *  配置mj
     */
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *
     {
         return @{
                  @"ID": @"id",
                  @"newsType":@"newType"
                  };
     }];
    
    sleep(1);
    
    /**
     *  初始化进入
     */
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = COLOR_WHITE;
    [_window makeKeyAndVisible];
    
    
    /**
     *  如果之前登陆过
     */
    
    HomePageViewController *homeController = [[HomePageViewController alloc] init];
    YGNavigationController *navc = [[YGNavigationController alloc] initWithRootViewController:homeController];
    _window.rootViewController = navc;
    
    sleep(1);
    application.applicationIconBadgeNumber = 0;
    
    return YES;
    
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result)
    {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(self.isEable) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        NSLog(@"didRegisterUser");
        [application registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    SYS_SINGLETON.deviceToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"-------------------- %@", SYS_SINGLETON.deviceToken);
    //    NSString *userId
    //给服务器发token
    if(SYS_SINGLETON.user.userId.length > 0)
    {
        [SYS_NETSERVICE YGPOST:REQUEST_UPDATETOKENID parameters:@{
                                                @"userId":SYS_SINGLETON.user.userId,
                                                @"tokenId":SYS_SINGLETON.deviceToken,
                                                @"phoneType":@"2"
                                                }
               showLoadingView:NO scrollView:nil success:^(id responseObject) {
                   NSLog(@"%@",responseObject);
        } failure:nil];
    }
}


//前台收到推送，后台收到推送点击，死了收到推送点击
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [_localUserInfo removeAllObjects];
    //    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:[userInfo[@"datas"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    [_localUserInfo addEntriesFromDictionary:userInfo];
    
    //死了进来点推送
    if (_pushState != ReceivePushStateDeadClickPush)
        
    {
        //前台收到未点击
        if (application.applicationState == UIApplicationStateActive)
        {
            _pushState = ReceivePushStateForeground;
            BOOL isiOS10 = NO;
            NSString *version = [UIDevice currentDevice].systemVersion;
            NSArray *versionArray = [version componentsSeparatedByString:@"."];
            if ([versionArray[0] intValue] > 9)
            {
                isiOS10 = YES;
            }
            [EBForeNotification handleRemoteNotification:userInfo soundID:1312 isIos10:isiOS10];
            completionHandler(UIBackgroundFetchResultNewData);
            _pushState = ReceivePushStateNone;
        }
        //后台和锁屏收到点击
        else
        {
            _pushState = ReceivePushStateBackgroundClickPush;
            [self clickPushAction];
            
        }
    }
    NSLog(@"receive push : %@", _localUserInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo
{
    [_localUserInfo addEntriesFromDictionary:userInfo[@"customDic"]];
    [self clickPushAction];
}
 
- (void)clickPushAction
{
//    UITabBarController *tabBarController = (UITabBarController *) _window.rootViewController;
//    UINavigationController *nowNavigationController = tabBarController.viewControllers[tabBarController.selectedIndex];
//    UIViewController *topViewController = nowNavigationController.viewControllers[nowNavigationController.viewControllers.count - 1];
//    if (topViewController.presentedViewController)
//    {
//        [topViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//    }     
//    switch ([_localUserInfo[@"type"] integerValue])
//    {
//        case 1://评论消息
//        {
//            PLMineController * controller = [[PLMineController alloc] init];
//            [nowNavigationController pushViewController:controller animated:YES];
//        }
//            break;
//        case 2://粉丝消息通知
//        {
//            FansNewsController * controller = [[FansNewsController alloc] init];
//            [nowNavigationController pushViewController:controller animated:YES];
//        }
//            break;
//        case 3://自选消息通知
//        {
//            PriceChangeController * controller = [[PriceChangeController alloc] init];
//            [nowNavigationController pushViewController:controller animated:YES];
//        }
//            break;
//        case 5://今日话题消息通知
//        {
//            NewsDetailViewController * controller = [[NewsDetailViewController alloc] init];
//            controller.urlString = [NSString stringWithFormat:@"%@today-info.html?newsId=%@", SERVER_WEB_URL,_localUserInfo[@"id"]];
//            controller.shareTempTitle = @"";
//            controller.isHiddenToolBar = YES;
//            controller.navigationString = @"今日话题";
//            [nowNavigationController pushViewController:controller animated:YES];
//        }
//            break;
//        default:
//            break;
//    }
//    _pushState = ReceivePushStateNone;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //    [YGPushSDK badageChangeWithBadgeNum:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

