//
// Created by zhangkaifeng on 2017/10/19.
// Copyright (c) 2017 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YGActionSheetView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *titlesArray;

//选中index
@property (nonatomic, assign) int selectedIndex;

/**
 * 展示方法
 * @param titlesArray 文字数组
 * @param handler 点击block
 */
+ (instancetype)showWithTitlesArray:(NSArray *)titlesArray handler:(void (^)(NSInteger selectedIndex, NSString *selectedString))handler;

@end