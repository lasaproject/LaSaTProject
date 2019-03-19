//
//  YGNavigationController.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/8/2.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGNavigationController.h"

@interface YGNavigationController ()

@end

@implementation YGNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = COLOR_MAIN;
    self.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    

    self.navigationBar.shadowImage = [UIImage imageNamed:@"tranimg"];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"tranimg"] forBarMetrics:UIBarMetricsDefault];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    //说明是第二级以上
    if (self.viewControllers.count >= 1)
    {
        if (self.viewControllers.count == 1)
        {
            viewController.hidesBottomBarWhenPushed = YES;
        }
        
        // 左边返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 40, 40);
        backButton.backgroundColor = [UIColor clearColor];
        [backButton setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
        [backButton addTarget:viewController action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        [backButton sizeToFit];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [viewController.navigationItem setLeftBarButtonItem:leftItem];
    }
    
    [super pushViewController:viewController animated:animated];
}

-(BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

@end
