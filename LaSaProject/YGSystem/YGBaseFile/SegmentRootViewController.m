//
//  SegmentRootViewController.m
//  Bitoken
//
//  Created by zhangkaifeng on 2018/5/28.
//  Copyright © 2018 ccyouge. All rights reserved.
//

#import "SegmentRootViewController.h"

@interface SegmentRootViewController ()

@end

@implementation SegmentRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = _controlFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLeft
{
    _leftDate = [NSDate date];

}

- (void)viewWillCome
{
    if(!_leftDate)
    {
        return;
    }
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:_leftDate];
    NSLog(@"%@ left second:%f", NSStringFromClass([self class]), timeInterval);
    [self viewLeftSecond:timeInterval];
}

- (void)viewLeftSecond:(NSTimeInterval)second
{
    NSLog(@"离开本页面的秒数%d", (int)second);
}

@end
