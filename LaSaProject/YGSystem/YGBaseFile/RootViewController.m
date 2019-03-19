//
//  RootViewController.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/7/27.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "RootViewController.h"
#import "YGNavigationController.h"

@interface RootViewController ()
{
    SEL _superCmd;
    MJRefreshGifHeader *_refreshGifHeader;
}
@end

@implementation RootViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //友盟统计
//    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //友盟统计
//    [MobClick endLogPageView:NSStringFromClass([self class])];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.view.backgroundColor = COLOR_TABLE;
    self.statusBarStyle = UIStatusBarStyleLightContent;
    [self configAttribute];
}

- (void)startPostWithURLString:(NSString *)URLString
                    parameters:(id)parameters
               showLoadingView:(BOOL)flag
                    scrollView:(UIScrollView *)scrollView
{
    [SYS_NETSERVICE YGPOST:URLString parameters:parameters showLoadingView:flag scrollView:scrollView success:^(id responseObject)
    {
        [self didReceiveSuccessResponseWithURLString:URLString parameters:parameters responeseObject:responseObject];
    }            failure:^(NSError *error)
    {
        [self didReceiveFailureResponseWithURLString:URLString parameters:parameters error:error];
    }];
}

- (void)didReceiveSuccessResponseWithURLString:(NSString *)URLString parameters:(id)parameters responeseObject:(id)responseObject
{

}

- (void)didReceiveFailureResponseWithURLString:(NSString *)URLString parameters:(id)parameters error:(NSError *)error
{

}

//设置属性
- (void)configAttribute
{

}

//状态栏颜色
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle
{
    _statusBarStyle = statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle animated:YES];
}

//一键创建普通navigation
- (void)setNaviTitle:(NSString *)naviTitle
{
    _naviTitle = naviTitle;
    if (!_naviTitleLabel)
    {
        _naviTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH - 100, 20)];
        _naviTitleLabel.textColor = COLOR_WHITE;
        _naviTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = _naviTitleLabel;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICE_NAVIGATION_BAR_HEIGHT+DEVICE_STATUS_BAR_HEIGHT-1, DEVICE_SCREEN_WIDTH, 1)];
        line.backgroundColor = COLOR_LINE;
        [self.navigationController.view addSubview:line];
    }
    _naviTitleLabel.text = _naviTitle;
}

- (UIBarButtonItem *)createBarbuttonWithNormalImageName:(NSString *)imageName selectedImageName:(NSString *)selectImageName selector:(SEL)selector
{

    UIButton *barButton = [[UIButton alloc] init];
    [barButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [barButton setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    [barButton sizeToFit];
    [barButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    return barButtonItem;
}

- (UIBarButtonItem *)createBarbuttonWithNormalTitleString:(NSString *)titleString selectedTitleString:(NSString *)selectedTitleString font:(UIFont *)font color:(UIColor *)color selector:(SEL)selector
{
    UIButton *barButton = [[UIButton alloc] init];
    [barButton setTitle:titleString forState:UIControlStateNormal];
    [barButton setTitle:selectedTitleString forState:UIControlStateSelected];
    barButton.titleLabel.font = font;
    [barButton setTitleColor:color forState:UIControlStateNormal];
    [barButton sizeToFit];
    [barButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barButton];
    return barButtonItem;
}

//一键刷新加载
- (void)createRefreshWithScrollView:(UITableView *)tableView containFooter:(BOOL)containFooter
{
    _refreshGifHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeaderAction)];
    NSMutableArray *gifArray = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 10; ++i)
    {
        
        [gifArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"frame_%d",i]]];
    }
    [_refreshGifHeader setImages:gifArray duration:1 forState:MJRefreshStateIdle];
    [_refreshGifHeader setImages:gifArray duration:1 forState:MJRefreshStatePulling];
    [_refreshGifHeader setImages:gifArray duration:1 forState:MJRefreshStateRefreshing];
    [_refreshGifHeader setImages:gifArray duration:1 forState:MJRefreshStateWillRefresh];
    [_refreshGifHeader setTitle:@"下拉刷新数据" forState:MJRefreshStateIdle];
    [_refreshGifHeader setTitle:@"下拉刷新数据" forState:MJRefreshStatePulling];
    [_refreshGifHeader setTitle:@"下拉刷新数据" forState:MJRefreshStateRefreshing];
    [_refreshGifHeader setTitle:@"下拉刷新数据" forState:MJRefreshStateWillRefresh];
    [_refreshGifHeader setTitle:@"没有更多数据了哦" forState:MJRefreshStateNoMoreData];
    _refreshGifHeader.lastUpdatedTimeLabel.hidden = YES;
    tableView.mj_header = _refreshGifHeader;
    _refreshGifHeader.stateLabel.hidden = YES;
    if (containFooter)
    {
        
        MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooterAction)];
        [footer setImages:gifArray forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [footer setImages:gifArray forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [footer setImages:gifArray forState:MJRefreshStateRefreshing];
        footer.stateLabel.hidden = YES;
        [footer setTitle:@"-END-" forState:MJRefreshStateNoMoreData];

        // 设置header
        tableView.mj_footer = footer;
        tableView.mj_footer.automaticallyHidden = YES;
    }
    
//    _refreshGifHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshHeaderAction)];
//    _refreshGifHeader.lastUpdatedTimeLabel.hidden = YES;
//    tableView.mj_header = _refreshGifHeader;
//
//    if (containFooter)
//    {
//        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshFooterAction)];
//        tableView.mj_footer.automaticallyHidden = YES;
//    }

    //一次请求条数（默认10）
    _countString = [YGAppTool stringValueWithInt:DEFAULT_TABLEVIEW_COUNT];
    //记录条数
    _totalString = @"1";
}

//下拉方法（无需重写）
- (void)refreshHeaderAction
{
    [_noNetBaseView removeFromSuperview];
    //记录条数
    _totalString = @"1";
    [self refreshActionWithIsRefreshHeaderAction:YES];
}

//上拉方法（无需重写）
- (void)refreshFooterAction
{
    //记录条数
    _totalString = [NSString stringWithFormat:@"%d", [_totalString intValue] + 1];
    [self refreshActionWithIsRefreshHeaderAction:NO];
}

//上拉下拉都走的方法，headerAction为YES时为下拉，否则为上拉。上拉加载时total和count直接传self.total和self.count
- (void)refreshActionWithIsRefreshHeaderAction:(BOOL)headerAction
{
    if (headerAction)
    {
        _totalString = @"1";
    }
}

//停止刷新
- (void)endRefreshWithScrollView:(UIScrollView *)scrollView
{
    [scrollView.mj_header endRefreshing];
    [scrollView.mj_footer endRefreshing];
}

//如果刷新数据为空搞一下事情
- (void)noMoreDataFormatWithScrollView:(UITableView *)scrollView
{
   
        _totalString = [NSString stringWithFormat:@"%d", _totalString.intValue - 1];
     if ([_totalString intValue]<=1) {
         _totalString =@"1";

     }
        [scrollView.mj_footer endRefreshingWithNoMoreData];
    
}

//自动加未加载图片
- (void)addNoDataImageViewWithArray:(NSArray *)array shouldAddToView:(UIView *)view headerAction:(BOOL)headerAction
{
    if (headerAction)
    {
        if (array.count == 0)
        {
            [_noDataImageView removeFromSuperview];
            _noDataImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lose_data_text"]];
            [_noDataImageView sizeToFit];
            [view addSubview:_noDataImageView];

            _noDataImageView.centerx = view.width / 2;
            _noDataImageView.centery = view.width / 2;
            if([view isKindOfClass:[UITableView class]])
            {
                UITableView *tableView = view;
                float pureHeight = tableView.height - tableView.tableHeaderView.height;
                _noDataImageView.centery = pureHeight/2 + tableView.tableHeaderView.height;
            }
        }
        else
        {
            [_noDataImageView removeFromSuperview];
        }
    }
}

- (void)addNoNetRetryButtonWithFrame:(CGRect)frame listArray:(NSArray *)listArray
{
    [_noNetBaseView removeFromSuperview];
    if (listArray.count != 0)
    {
        return;
    }
    _noNetBaseView = [[UIView alloc] init];
    _noNetBaseView.backgroundColor = COLOR_TABLE;
    UIButton *noNetButton = [[UIButton alloc] init];
    [noNetButton setImage:[UIImage imageNamed:@"lose_network_text"] forState:UIControlStateNormal];
    [noNetButton sizeToFit];
    [_noNetBaseView addSubview:noNetButton];

    _noNetBaseView.frame = frame;
    [self.view addSubview:_noNetBaseView];

    if (listArray)
    {
        [noNetButton addTarget:_refreshGifHeader action:@selector(beginRefreshing) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        NSString *sourceString = [NSThread callStackSymbols][1];
        NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString componentsSeparatedByCharactersInSet:separatorSet]];
        [array removeObject:@""];
        _superCmd = NSSelectorFromString(array[5]);
        [noNetButton addTarget:self action:@selector(noNetAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    noNetButton.center = CGPointMake(_noNetBaseView.width / 2, _noNetBaseView.height / 2);
}

- (void)noNetAction:(UIButton *)button
{
    [_noNetBaseView removeFromSuperview];
    [self performSelector:_superCmd];
}

- (BOOL)loginOrNot
{
//    //未登录
//    if ([SYS_SINGLETON.user.id isEqualToString:@""] || SYS_SINGLETON.user.id == NULL)
//    {
//        RegisterViewController *controller = [[RegisterViewController alloc] init];
//        controller.hidesBottomBarWhenPushed = YES;
////        controller.delegate = self;
//        controller.navigationItem.hidesBackButton = YES;
//        [self.navigationController pushViewController:controller animated:YES];
//
//        return NO;
//    }
    return YES;
}

- (void)loginViewController:(LoginViewController *)controller didSuccessLoginWithUserModel:(YGUser *)model
{

}

//没dealloc就有内存泄露了需注意
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

//返回
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerTimerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerCountingDown:) name:NC_TIMER_COUNT_DOWN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commonTimerDidFinishCountDown) name:NC_TIMER_FINISH object:nil];
}

- (void)timerCountingDown:(NSNotification *)notification
{
    NSString *key = NC_TIMER_COUNT_DOWN;
    [self commonTimerCountingDownWithLeftSeconds:[notification.userInfo[key] integerValue]];
}

- (void)commonTimerCountingDownWithLeftSeconds:(NSInteger)seconds
{

}

- (void)commonTimerDidFinishCountDown
{

}

@end
