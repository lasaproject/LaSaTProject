//
//  YGSegmentView.m
//  FindingSomething
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YGSegmentView.h"

@implementation YGSegmentView
{
    UIScrollView *_topScrollView;
    NSInteger _lastSelectIndex;
}
- (instancetype)initWithFrame:(CGRect)frame startWidth:(CGFloat)startWidth margin:(CGFloat)margin titlesArray:(NSArray *)titlesArray style:(YGSegmentStyle)style
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _titlesArray = titlesArray;
        _style = style;
        _margin = margin;
        _startWidth = startWidth;
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    _topScrollView.showsVerticalScrollIndicator = NO;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.alwaysBounceHorizontal = YES;

    [self addSubview:_topScrollView];

    CGFloat totalX = 0.0;
    for (int i = 0; i < _titlesArray.count; i++)
    {
        YGButton *segmentButton = [YGButton buttonWithType:UIButtonTypeCustom];
        segmentButton.tag = 100 + i;
        [segmentButton setTitle:_titlesArray[i] forState:UIControlStateNormal];
        [segmentButton setTitleColor:COLOR_GRAY_DEEP forState:UIControlStateNormal];
        [segmentButton setTitleColor:COLOR_MAIN forState:UIControlStateSelected];
        [segmentButton addTarget:self action:@selector(segmentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        segmentButton.titleLabel.font = [UIFont systemFontOfSize:FONT_BIG_2];
        [segmentButton sizeToFit];
        totalX += segmentButton.width;
        segmentButton.centery = _topScrollView.height / 2;
        [_topScrollView addSubview:segmentButton];
    }

    totalX += _startWidth * 2;
    CGFloat margin = (_topScrollView.width - totalX) / (_titlesArray.count - 1);
    totalX = 0.0;
    if(_style == SegmentStyleSlide)
    {
        margin = _margin;
    }

    for (int i = 0; i < _titlesArray.count; i++)
    {
        YGButton *segmentButton = [_topScrollView viewWithTag:100 + i];
        if (i == 0)
        {
            segmentButton.x = _startWidth;
            segmentButton.selected = YES;
            _lastSelectIndex = i;
        }
        else
        {
            segmentButton.x = totalX + margin;
            if (i == _titlesArray.count - 1)
            {
                if (_style == SegmentStyleSlide)
                {
                    _topScrollView.contentSize = CGSizeMake(CGRectGetMaxX(segmentButton.frame) + _startWidth, self.height);
                }

            }
        }
        totalX = CGRectGetMaxX(segmentButton.frame);
    }
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    NSInteger lastIndex = _selectIndex;
    _selectIndex = selectIndex;
    YGButton *lastSelectedButton = [self viewWithTag:100 + _lastSelectIndex];
    lastSelectedButton.selected = NO;
    YGButton *nowSelectedButton = [self viewWithTag:100 + selectIndex];
    nowSelectedButton.selected = YES;
    _lastSelectIndex = selectIndex;
    if (_bottomView)
    {
        [UIView animateWithDuration:0.25 animations:^
        {
            _bottomView.centerx = nowSelectedButton.centerx;
        }];
    }


    CGRect buttonConvertFrame = [_topScrollView convertRect:nowSelectedButton.frame toView:self];
    if (CGRectGetMaxX(buttonConvertFrame) > _topScrollView.width)
    {
        [_topScrollView setContentOffset:CGPointMake(CGRectGetMaxX(nowSelectedButton.frame) - _topScrollView.width, _topScrollView.contentOffset.y) animated:YES];
    }
    else if (buttonConvertFrame.origin.x < 0)
    {
        [_topScrollView setContentOffset:CGPointMake(nowSelectedButton.x, _topScrollView.contentOffset.y) animated:YES];
    }

    if ([_delegate respondsToSelector:@selector(YGSegmentView:didClickedButton:withIndex:fromIndex:)])
    {
        [_delegate YGSegmentView:self didClickedButton:nowSelectedButton withIndex:selectIndex fromIndex:lastIndex];
    }
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    for (int i = 0; i < _titlesArray.count; i++)
    {
        YGButton *segmentButton = [self viewWithTag:100 + i];
        [segmentButton setTitleColor:normalColor forState:UIControlStateNormal];
    }
}

- (void)setSelectColor:(UIColor *)selectColor
{
    _selectColor = selectColor;
    for (int i = 0; i < _titlesArray.count; i++)
    {
        YGButton *segmentButton = [self viewWithTag:100 + i];
        [segmentButton setTitleColor:selectColor forState:UIControlStateSelected];
    }
}

- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor
{
    _normalBackgroundColor = normalBackgroundColor;
    for (int i = 0; i < _titlesArray.count; i++)
    {
        YGButton *segmentButton = [self viewWithTag:100 + i];
        [segmentButton setBackgroundColor:normalBackgroundColor forState:UIControlStateNormal];
    }
}

- (void)setSelectBackgroundColor:(UIColor *)selectBackgroundColor
{
    _selectBackgroundColor = selectBackgroundColor;
    for (int i = 0; i < _titlesArray.count; i++)
    {
        YGButton *segmentButton = [self viewWithTag:100 + i];
        [segmentButton setBackgroundColor:selectBackgroundColor forState:UIControlStateSelected];
    }
}

- (void)setBottomView:(UIView *)bottomView
{
    _bottomView = bottomView;
    [_topScrollView addSubview:bottomView];
    _bottomView.centerx = [self viewWithTag:100 + self.selectIndex].centerx;
    _bottomView.y = _topScrollView.height - _bottomView.height - 2;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    for (int i = 0; i < _titlesArray.count; i++)
    {
        YGButton *segmentButton = [self viewWithTag:100 + i];
        segmentButton.titleLabel.font = font;
    }
}

- (void)segmentButtonClick:(YGButton *)button
{
    self.selectIndex = button.tag - 100;
}

@end
