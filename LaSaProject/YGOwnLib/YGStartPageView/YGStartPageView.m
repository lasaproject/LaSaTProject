//
//  YGStartPageView.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/7/27.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "YGStartPageView.h"

@implementation YGStartPageView
{
    UIPageControl *_pageControl;
}
- (instancetype)initWithLocalPhotoNamesArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        _localPhotoNamesArray = array;
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    self.frame = [UIScreen mainScreen].bounds;
    
    //scrollview
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT)];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(DEVICE_SCREEN_WIDTH *(_localPhotoNamesArray.count + 1), scrollView.height);
    scrollView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    
    //page
    UIPageControl *page = [[UIPageControl alloc]initWithFrame:CGRectMake(0, DEVICE_SCREEN_HEIGHT -  40, DEVICE_SCREEN_WIDTH, 10)];
    page.currentPage = 0;
    page.numberOfPages = _localPhotoNamesArray.count;
    [self addSubview:page];
    _pageControl = page;
    
    
    for (int i = 0; i<_localPhotoNamesArray.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        imageView.x = i * DEVICE_SCREEN_WIDTH;
        imageView.image = [UIImage imageNamed:_localPhotoNamesArray[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [scrollView addSubview:imageView];
    }
}

+(void)showWithLocalPhotoNamesArray:(NSArray *)array
{
    [[[self alloc]initWithLocalPhotoNamesArray:array] showView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x/DEVICE_SCREEN_WIDTH;
    //如果不是最后一页，正常变page
    if (index != _localPhotoNamesArray.count)
    {
        _pageControl.currentPage = index;
    }
    //如果是最后一页,把自己干掉
    else
    {
        [self removeFromSuperview];
    }
}

-(void)showView
{
    [SYS_APPDELEGATE.window addSubview:self];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float index = scrollView.contentOffset.x/DEVICE_SCREEN_WIDTH;
    
    if (index>_localPhotoNamesArray.count - 1)
    {
        float offsetX = scrollView.contentOffset.x - DEVICE_SCREEN_WIDTH *(_localPhotoNamesArray.count - 1);
        float alpha = 1.0/DEVICE_SCREEN_WIDTH * offsetX;
        scrollView.alpha = 1 - alpha;
    }
    else
    {
        scrollView.alpha = 1;
    }
    
}

@end
