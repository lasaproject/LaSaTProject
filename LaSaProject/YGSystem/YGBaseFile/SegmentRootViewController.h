//
//  SegmentRootViewController.h
//  Bitoken
//
//  Created by zhangkaifeng on 2018/5/28.
//  Copyright © 2018 ccyouge. All rights reserved.
//

#import "RootViewController.h"

@interface SegmentRootViewController : RootViewController

@property (nonatomic, assign) CGRect controlFrame;
@property (nonatomic, strong) NSDate *leftDate;
- (void)viewWillLeft;
- (void)viewWillCome;
- (void)viewLeftSecond:(NSTimeInterval)second;

@end
