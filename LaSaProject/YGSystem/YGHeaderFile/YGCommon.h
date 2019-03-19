
#ifndef YGToolProject_YGCommon_h
#define YGToolProject_YGCommon_h

/**
 *                          常用属性
 */
#define YGAPPDELEGATE                       ((AppDelegate *)[[UIApplication sharedApplication] delegate])           // 系统的AppleDelegate
#define DEVICE_SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)                             // 屏幕宽度
#define DEVICE_SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)                            // 屏幕高度
#define DEVICE_STATUS_BAR_HEIGHT            [UIApplication sharedApplication].statusBarFrame.size.height            // 状态栏的高度
#define DEVICE_NAVIGATION_BAR_HEIGHT        44                                                                      // 工具栏的高度
#define DEVICE_TAB_BAR_HEIGHT               [YGSingleton sharedManager].tabBarHeight                                // 底部工具栏高度
#define DEVICE_BOTTOM_MARGIN                (([YGSingleton sharedManager].tabBarHeight - 49)/2)                     // iPhone X 底部间距

/**
 *                          懒人宏
 */
#define SYS_APPDELEGATE                     ((AppDelegate *)[[UIApplication sharedApplication] delegate])           // AppDelegate
#define SYS_SINGLETON                       [YGSingleton sharedManager]                                             // YGSingleton
#define SYS_NETSERVICE                      [YGConnectionService sharedConnectionService]                           // YGConnectionService
#define SYS_USERDEFAULTS                    [NSUserDefaults standardUserDefaults]                                   // NSUserDefaults

/**
 *                          字体
 */
#define FONT_BIG_3                          (14 + 3)                                                                // 大大
#define FONT_BIG_2                          (14 + 2)                                                                // 大
#define FONT_BIG_1                          (14 + 1)                                                                // 中大
#define FONT_NORMAL                         (14)                                                                    // 普通
#define FONT_SMALL_1                        (14 - 1)                                                                // 中小
#define FONT_SMALL_2                        (14 - 2)                                                                // 小
#define FONT_SMALL_3                        (14 - 3)                                                                // 小小

/**
 *                          Default Value
 */
#define DEFAULT_TABLEVIEW_COUNT             8                                                                      // Table每页数据的条数
#define DEFAULT_IMAGE_PLACEHOLDER           [UIImage imageNamed:@"pure_gray"]                                       // SDWebImage的默认图
#define DEFAULT_USER_FILE_PATH              [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"user.data"]

/**
 *                          服务器
 */
//#define SERVER_URL                          @"http://192.168.51.212:8080/"                                            // 张建
//#define SERVER_WEB_URL                      @"http://192.168.51.29:8020/web/"                                         // web地址
//#define SERVER_URL                          @"http://192.168.51.98:8088/"                                             // 陈则成
#define SERVER_URL                          @"http://192.168.1.178:8088/lasamobile"                                            // 接口地址
#define SERVER_WEB_URL                      @"http://paipai.qhziguan.com/web/"                                        // web地址

#define SERVER_SOCKET_URL                   @"192.168.51.12"                                                          // socket地址
#define SERVER_SOCKET_PORT                  6488                                                                      // socket端口
#define SERVER_QINIU_URL                    @"http://pic.huobanchina.com/"                                            // 七牛CDN加速域名

/**
 *                          颜色
 */
#define COLOR_BLACK                         COLOR_HEX(0x1f1f1f, 1)                                                  // 黑色字体颜色
#define COLOR_GRAY_DEEP                     COLOR_HEX(0x6e6e82, 1)                                                  // 深灰字体颜色
#define COLOR_GRAY_LIGHT                    COLOR_HEX(0xaaaaaa, 1)                                                  // 浅灰字体颜色
#define COLOR_MAIN                          COLOR_HEX(0xe9bc65, 1)                                                   // 主色调
#define COLOR_PLACEHOLDER                   COLOR_HEX(0xaaaaaa, 1)                                                  // placeholder
#define COLOR_TABLE                         COLOR_HEX(0xefeff4, 1)                                                  // table背景色
#define COLOR_WHITE                         [UIColor whiteColor]                                                    // 白色
#define COLOR_RED                           COLOR_HEX(0xf25858, 1)                                                  // 红色
#define COLOR_TABLE_LIGHT                   [UIColor colorWithRed:0.97 green:0.98 blue:0.99 alpha:1.00]             // 亮色table
#define COLOR_LINE                          COLOR_HEX(0xe0e0e0, 1)                                                  // 浅色线
#define COLOR_LINE_LIGHT                    COLOR_HEX(0xeeeeee, 1)                                                  // 浅色线
#define COLOR_BLUE                          COLOR_HEX(0x4cacf6, 1)                                                  // 蓝色
#define COLOR_GREEN                         COLOR_HEX(0x29AF2A, 1)                                                  // 绿色
#define COLOR_BACKBLACK                     COLOR_HEX(0x262626, 1)                                                  // 背景黑
#define COLOR_YELLOW                        COLOR_HEX(0xE9BC65, 1)                                                  // 黄色

#define COLOR_HEX(rgbValue, rgbAlpha) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:rgbAlpha]                                                               // 生成RGB颜色值

/**
 *                          APPKey
 */
#define APPKEY_UMENG                        @"5ba05321b465f57f3c000199"                                             // 友盟APPKey
#define APPKEY_WX_APPID                     @"wxd2114527a7decbcf"                                                   // 微信Appid
#define APPKEY_WX_APPSECRET                 @"b5cee05568f0373e76b1fd4044f7ca2d"                                     // 微信APPSecret
#define APPKEY_WX_URL                       @"http://publish.bmap.io/"                                              // 微信URL
#define APPKEY_QQ_APPID                     @"101501383"                                                            // QQAppid
#define APPKEY_QQ_APPKEY                    @"42bf7896817d3d02c8c73821ec05cd40"                                     // QQAppKey（貌似没用）
#define APPKEY_QQ_URL                       @"http://publish.bmap.io/"                                              // QQ URL
#define APPKEY_SINA_APPSECRET               @"1bf0328968639e391659e9d67bae6eff"                                     // 微博
#define APPKEY_SINA_APPKEY                  @"3902650162"                                                           // 微博
#define APPKEY_SINA_URL                     @"http://publish.bmap.io"                                               // 微博URL
#define APPKEY_BAIDUMAP                     @"3on3q0U6E9FQ1j7maqyTbSi1Eu8q0WnF"                                     // 百度APPKey
#define APPKEY_SMSSDK_APPKEY                @"22296e8597cea"                                                        // mob短信
#define APPKEY_SMSSDK_APPSECRET             @"631f4c737bb2464bbd7e08a5bb8a0f2f"                                     // mob短信

/**
 *                          UserDefaults Key
 */
#define USERDEF_FIRSTOPENAPPORUPDATE        @"firstOpenOrUpdate"                                                    // 首次打开APP
#define USERDEF_SEARCHHISTORY               @"searchHistory"                                                        // 搜索历史
#define USERDEF_NOWCITY                     @"nowCity"                                                              // 城市
#define USERDEF_NOWCITYINDEX                @"nowCityIndex"                                                         // 城市序号
#define USERDEF_LOGINPHONE                  @"phone"                                                                // 电话号
#define USERDEF_CAN4GPLAYVIDEO              @"can4GPlayVideo"                                                       // 4G下播放视频
// 归档用户数据路径
/**
 *                          NotificationCenter Key
 */
#define NC_TIMER_FINISH                     @"NC_TIMER_FINISH"                                                      // 倒计时完成
#define NC_TIMER_COUNT_DOWN                 @"NC_TIMER_COUNT_DOWN"                                                  // 正在倒计时

/**
 *                          接口
 */

#define REQUEST_GETALIYUNTOKEN             @"getAliyunToken"                                                        //获取阿里云token

//登录注册
#define REQUEST_SMS                         @"sendMsgCode"                                                          //验证码
#define REQUEST_REG                         @"userRegister"                                                         //注册
#define REQUEST_FORGETPASSWORD              @"forgetPassWord"                                                       //忘记密码
#define REQUEST_BINDPHONE                   @"bindPhone"                                                            //绑定手机号
#define REQUEST_USERLOGIN                   @"/mobile/appList.do"                                                            //登录
#define REQUEST_OTHERLOGIN                  @"otherLogin"                                                           //三方登录
#define REQUEST_UPDATETOKENID               @"updateTokenId"                                                        //更新tokenId

//资讯
#define REQUEST_HOMEPAGE                    @"homepage"                                                             //导航分类
#define REQUEST_USERLABEL                   @"userLabel"                                                            //导航频道分类
#define REQUEST_USERLABELSAVE               @"userLabelSave"                                                        //导航频道分类保存
#define REQUEST_QUERYNEWSINFO               @"queryNewsInfo"                                                        //新闻，快讯，视频
#define REQUEST_QUERYAD                     @"queryAd"                                                              //轮播图
#define REQUEST_QUERYALLINFO                @"queryAllInfo"                                                         //新闻和作者搜索
#define REQUEST_SEARCHNEWSLIST              @"searchNewsList"                                                       //新闻和作者搜索(用户搜索列表（查看更多))
#define REQUEST_SEARCHUSERLIST              @"searchUserList"                                                       //新闻和作者搜索(用户搜索列表（查看更多))
#define REQUEST_QUERYHOTSEARCH              @"queryHotSearch"                                                       //新闻和作者搜索 热门关键字
#define REQUEST_ATTENTION                   @"attention"                                                            //关注
#define REQUEST_QUERYMYCOLLECTBYNEWSID      @"queryMyCollectByNewsId"                                               //是否被收藏
#define REQUEST_COLLECT                     @"collect"                                                              //收藏
#define REQUEST_GETFLASHLIST                @"getFlashList"                                                         //快讯列表
#define REQUEST_LIKE                        @"like"                                                                 //利好利空
#define REQUEST_ADDNEWS                     @"addNews"                                                              //新闻等发布（新增文章）
#define REQUEST_COMMENT                     @"comment"                                                              //写评论
#define REQUEST_CKECKNEWS                   @"ckeckNews"                                                            //查看资讯/快讯详情(修改)
#define REQUEST_CKECKUPDATENEWS             @"ckeckUpdateNews"                                                      //修改查询文章
#define REQUEST_UPDATENEWS                  @"updateNews"                                                           //修改文章

//比赛
#define REQUEST_QUERYMATCHINFO              @"queryMatchInfo"                                                       //比赛介绍
#define REQUEST_QUERYMATCHRANKINGS          @"queryMatchRankings"                                                   //比赛排行
#define REQUEST_QUERYMATCHNEWS              @"queryMatchNews"                                                       //比赛(1-报告,2-比赛动态)
#define REQUEST_QUERYEXCHANGERANKINGS       @"queryExchangeRankings"                                                //交易所(成交量   市值榜)
#define REQUEST_QUERYTRADERRANKINGS         @"queryTraderRankings"                                                  //操盘手(主观 量化)
#define REQUEST_ADDMATCHSIGNUP              @"addMatchSignup"                                                       //比赛报名(报名参赛)
#define REQUEST_ALLEXCHANGELIST             @"allExchangeList"                                                      //比赛报名(选择交易所)


/*************************************动态***************************************/
#define REQUEST_DYNAMICNAVIGATION           @"dynamicNavigation"                                                    //动态导航
#define REQUEST_USERDYNAMICLABLE            @"userDynamicLabel"                                                     //用户喜好动态导航列表
#define REQUEST_USERDYNAMICLABLESAVE        @"userDynamicLabelSave"                                                 //用户喜好动态导航列表保存
#define REQUEST_ADDDYNAMIC                  @"addDynamic"                                                           //发布/转发动态
#define REQUEST_DYNAMICLIST                 @"dynamicList"                                                          //动态列表
#define REQUEST_LIKE                        @"like"                                                                 //点赞
#define REQUEST_DYNAMICCOMMENT              @"dynamicComment"                                                       //写评论
#define REQUEST_QUERYMYDYNAMICLIST          @"queryMyDynamicList"                                                   //我的动态
#define REQUEST_DELETEDYNAMIC               @"deleteDynamic"                                                        //删除动态

/*************************************行情***************************************/
#define REQUESR_GETBITLIST                  @"getBitList"                                                           //行情列表
#define REQUESR_USEROPTIONALLIST            @"userOptionalList"                                                     //用户自选列表
#define REQUESR_HOTCURRENCYLIST             @"hotCurrencyList"                                                      //热门币种
#define REQUESR_QUERYALLINFO                @"queryAllInfo"                                                         //查询所有信息
#define REQUESR_SEARCHCURRENCYLIST          @"searchCurrencyList"                                                   //币种搜索列表(查看更多)
#define REQUESR_SEARCHEXCHANGELIST          @"searchExchangeList"                                                   //交易所搜索列表(查看更多)
#define REQUESR_DELETEOPTIONAL              @"deleteOptional"                                                       //删除自选
#define REQUESR_GETTOP                      @"getTop"                                                               //置顶
#define REQUEST_CURRENCYSEARCHLIST          @"currencySearchList"                                                   //币种搜索列表
#define REQUEST_ADDOPTIONAL                 @"addOptional"                                                          //添加自选
#define REQUEST_QUERYKLINE                  @"queryKline"                                                           //K线数据
#define REQUEST_QUERYTRANSACTIONPAIR        @"queryTransactionPair"                                                 //简称OR交易所 查询交易对信息
#define REQUEST_QUERYEXCHANGEDYNAMIC        @"queryExchangeDynamic"                                                 //公告列表
#define REQUEST_QUERYSYNOPSIS               @"querySynopsis"                                                        //币种简介

/*************************************我的***************************************/
#define REQUESR_QUERYMYCOUNT                @"queryMyCount"                                                         //我的主页
#define REQUEST_QUERYMYHINTINFO             @"queryMyHintinfo"                                                      //我的消息(价格变动 | 今日话题 | 系统信息)
#define REQUESR_QUERYMYNEWSCOUNT            @"queryMyNewsCount"                                                     //我的文章
#define REQUESR_QUERYMYFOLLOWANDFANS        @"queryMyFollowAndFans"                                                 //我的粉丝-关注
#define REQUESR_QUERYMYCOLLECT              @"queryMyCollect"                                                       //我的收藏
#define REQUESR_QUERYABOUTS                 @"queryAboutus"                                                         //版本号
#define REQUESR_UPDATEUSERINFO              @"updateUserInfo"                                                       //修改用户信息
#define REQUESR_QUERYCERTIFICATION          @"queryCertification"                                                   //认证状态
#define REQUEST_QUERYMYCOMMENT              @"queryMycommen"                                                        //评论我的
#define REQUESR_IDCERTIFICATION             @"IdCertification"                                                      //身份证认证
#define REQUESR_ACCOUNTNUMBERLIST           @"accountNumberList"                                                    //用户绑定列表
#define REQUESR_BINDOTHERS                  @"bindOthers"                                                           //绑定三方
#define REQUESR_QUERYUSERINFO               @"queryUserInfo"                                                        //查看个人主页
#define REQUESR_BPPSHARE                    @"bppShare"                                                             //币排排推荐分享
#define REQUEST_USERPUSHLIST                @"userPushList"                                                         //用户推送列表
#define REQUEST_UPDATEUSERPUSH              @"updateUserPush"                                                       //用户推送列表
#endif
