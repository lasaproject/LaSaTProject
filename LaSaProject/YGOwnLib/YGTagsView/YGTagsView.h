//
//  YGTagsView.h
//  GoldSalePartner
//
//  Created by 管宏刚 on 2017/10/19.
//  Copyright © 2017年 曹来东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGTagsModel.h"

@class YGTagsView;

@protocol YGTagsViewDelegate <NSObject>

@optional
/**
 * 将要选中
 * @param tagView 本view
 * @param tagModel 选中的model
 * @return 返回yes则选中，no则不选中
 */
- (BOOL)YGTagsView:(YGTagsView *)tagView shouldClickTagWithModel:(YGTagsModel *)tagModel;

/**
 * 已经选中
 * @param tagView 本view
 * @param tagModel 选中的model
 */
- (void)YGTagsView:(YGTagsView *)tagView didClickTagWithModel:(YGTagsModel *)tagModel;

@end

@interface YGTagsView : UIView

@property (nonatomic, strong) NSArray *titlesArray;//标题数组
@property (nonatomic, strong) UIColor *selectedTitleColor;//选中标题
@property (nonatomic, strong) UIColor *normalTitleColor;//未选中标题
@property (nonatomic, strong) UIColor *selectedBorderColor;//选中边框
@property (nonatomic, strong) UIColor *normalBorderColor;//未选中边框
@property (nonatomic, strong) UIFont *titleFont;//标题字体大小
@property (nonatomic, assign) CGFloat cornerRadius;//圆角大小
@property (nonatomic, strong) UIColor *selectedBackgroundColor;//选中背景色
@property (nonatomic, strong) UIColor *normalBackgroundColor;//未选中背景色
@property (nonatomic, assign) CGFloat horizontalPadding;//横向内边距
@property (nonatomic, assign) CGFloat verticalPadding;//垂直内边距
@property (nonatomic, assign) CGFloat horizontalMargin;//横向外边距
@property (nonatomic, assign) CGFloat verticalMargin;//垂直外边距
@property (nonatomic, assign) id <YGTagsViewDelegate> delegate;

/**
 * 反选（按钮选中状态取反）
 * @param titlesArray 标题数组
 */
- (void)reverseTagsWithTitlesArray:(NSArray *)titlesArray;

/**
 * 反选（按钮选中状态取反）
 * @param indexArray 序号数组
 */
- (void)reverseTagsWithIndexArray:(NSArray *)indexArray;

/**
 * 刷新方法（每次数据源改变、间距字体等改变、或者初始化之后需调用）
 */
- (void)reloadTagsView;

@end
