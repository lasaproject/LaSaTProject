//
//  YGSegmentView.h
//  FindingSomething
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YGSegmentView;

typedef NS_ENUM(NSInteger, YGSegmentStyle)
{
    SegmentStyleNormal = 0,    // 普通模式
    SegmentStyleSlide = 1,    // 滑动模式
};

@protocol YGSegmentViewDelegate <NSObject>

/***
 * segment被选中方法（手动赋值selectIndex也会调用）
 * @param segmentView 本控件
 * @param button 选中的button，方便处理
 * @param buttonIndex 选中的index
 * @param lastIndex 上一次选中的index，方便处理
 */
- (void)YGSegmentView:(YGSegmentView *)segmentView didClickedButton:(UIButton *)button withIndex:(NSInteger)buttonIndex fromIndex:(NSInteger)lastIndex;

@end

@interface YGSegmentView : UIView

/***
 * 初始化方法
 * @param frame segment的frame
 * @param startWidth segment第一个tab距左距离
 * @param margin segment的tab与tab的间距（SegmentStyleSlide专用，SegmentStyleNormal无效）
 * @param titlesArray 标题数组
 * @param style 风格，SegmentStyleNormal普通模式，SegmentStyleSlide滑动模式（参考网易新闻）
 * @return
 */
- (instancetype)initWithFrame:(CGRect)frame startWidth:(CGFloat)startWidth margin:(CGFloat)margin titlesArray:(NSArray *)titlesArray style:(YGSegmentStyle)style;

// 获取当前选中的index，或手动设置要选中的index
@property (nonatomic, assign) NSInteger selectIndex;
// 选中文字颜色
@property (nonatomic, strong) UIColor *selectColor;
// 未选中文字颜色
@property (nonatomic, strong) UIColor *normalColor;
// 选中背景颜色
@property (nonatomic, strong) UIColor *selectBackgroundColor;
// 未选中背景颜色
@property (nonatomic, strong) UIColor *normalBackgroundColor;
// 字体
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) id <YGSegmentViewDelegate> delegate;
// 自定义选中按钮下方滑块
@property (nonatomic, strong) UIView *bottomView;



//================================自用属性别碰==================================
@property (nonatomic, assign, readonly) YGSegmentStyle style;
@property (nonatomic, assign, readonly) CGFloat startWidth;
@property (nonatomic, assign, readonly) CGFloat margin;
@property (nonatomic, strong, readonly) NSArray *titlesArray;

@end
