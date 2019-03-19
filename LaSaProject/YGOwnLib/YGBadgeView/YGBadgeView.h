//
//  YGBadgeView.h
//  原点
//
//  Created by 管宏刚 on 16/12/9.
//  Copyright © 2016年 管宏刚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGBadgeView : UIView

/**
 * 角标数可直接修改（为0将自动隐藏）
 */
@property (nonatomic, assign) int badge;

/**
 * 初始化方法
 * @param frame
 * @param badge 角标数量
 * @return
 */
- (instancetype)initWithFrame:(CGRect)frame badge:(int)badge;

@end
