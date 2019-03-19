//
//  SecondMenuView.h
//  LoveBB
//
//  Created by AngelLL on 15/10/22.
//  Copyright © 2015年 Daniel_Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGCustomMenu : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong, readonly) NSArray *titlesArray;
@property (nonatomic, strong, readonly) NSArray *imageArray;
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, assign, readonly) CGFloat rowHeight;
@property (nonatomic, assign, readonly) CGPoint trangleOrigin;
@property (nonatomic, assign, readonly) CGFloat tableViewX;
@property (nonatomic, assign, readonly) CGFloat tableViewWidth;


/**
 *  一句话初始化
 *
 *  @param titleString       显示的文字
 *  @param buttonTitlesArray 按钮文字数组
 *  @param buttonColorsArray 按钮颜色数组
 *  @param handler           点击事件回调block
 */
+ (void)showMenuWithTitlesArray:(NSArray *)titlesArray imageArray:(NSArray *)imageArray rowHeight:(CGFloat)rowHeight trangleOrigin:(CGPoint)trangleOrigin tableViewX:(CGFloat)tableViewX tableViewWidth:(CGFloat)tableViewWidth handler:(void (^)(NSInteger index))handler;


@end
