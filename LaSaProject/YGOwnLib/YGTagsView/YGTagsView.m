//
//  YGTagsView.m
//  GoldSalePartner
//
//  Created by 管宏刚 on 2017/10/19.
//  Copyright © 2017年 曹来东. All rights reserved.
//

#import "YGTagsView.h"

@implementation YGTagsView
{
    NSMutableArray *_listArray;//数据源数组
}

- (void)reloadTagsView
{
    if (!_listArray)
    {
        _listArray = [[NSMutableArray alloc] init];
    }
    else
    {
        [_listArray removeAllObjects];
        for (UIView *subView in self.subviews)
        {
            [subView removeFromSuperview];
        }
    }

    
    for (int i = 0; i < _titlesArray.count; i ++)
    {
        //数组转化数据源
        YGTagsModel * tagModel = [[YGTagsModel alloc] init];
        tagModel.title = _titlesArray[i];//标题
        tagModel.index = i;//位置
        [_listArray addObject:tagModel];
        
        YGButton * tagButton = [[YGButton alloc] init];
        tagButton.clipsToBounds = YES;
        tagButton.layer.borderWidth = 1;
        tagButton.layer.cornerRadius = _cornerRadius;
        [tagButton setTitle:tagModel.title forState:UIControlStateNormal];
        [tagButton setTitle:tagModel.title forState:UIControlStateSelected];
        [tagButton setTitleColor:_normalTitleColor forState:UIControlStateNormal];
        [tagButton setTitleColor:_selectedTitleColor forState:UIControlStateSelected];
        [tagButton setBackgroundColor:_normalBackgroundColor forState:UIControlStateNormal];
        [tagButton setBackgroundColor:_selectedBackgroundColor forState:UIControlStateSelected];
        [tagButton setBorderColor:_normalBorderColor forState:UIControlStateNormal];
        [tagButton setBorderColor:_selectedBorderColor forState:UIControlStateSelected];
        tagButton.titleLabel.font = _titleFont;
        CGSize tagSize = [UILabel calculateWidthWithString:tagModel.title textFont:_titleFont numerOfLines:1 maxWidth:DEVICE_SCREEN_WIDTH];
        tagSize = CGSizeMake(tagSize.width + 2 * _horizontalPadding, tagSize.height + 2 * _verticalPadding);
        tagButton.tag = 100 + i;
        [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tagButton];
        
        CGFloat lastTagMaxX;
        CGFloat lastTagMaxY = 0;
        if (i == 0)
        {
            lastTagMaxX = 0;
        }
        else
        {
            //在这就换行了
            if ((CGRectGetMaxX([self viewWithTag:100 + i - 1].frame) + _horizontalMargin + tagSize.width) > self.width)
            {
                lastTagMaxX = 0;
                lastTagMaxY = CGRectGetMaxY([self viewWithTag:100 + i - 1].frame) + _verticalMargin;
            }
            else
            {
                lastTagMaxX = CGRectGetMaxX([self viewWithTag:100 + i - 1].frame) + _horizontalMargin;
                lastTagMaxY = CGRectGetMinY([self viewWithTag:100 + i - 1].frame);
            }
        }
        tagButton.frame = CGRectMake(lastTagMaxX, lastTagMaxY, tagSize.width, tagSize.height);
        
        if (i == _titlesArray.count - 1)
        {
            self.height = CGRectGetMaxY(tagButton.frame);
        }
    }
}

- (void)tagButtonClick:(UIButton *)tagButton
{
     YGTagsModel * tagModel = _listArray[tagButton.tag - 100];
    if ([_delegate respondsToSelector:@selector(YGTagsView:shouldClickTagWithModel:)])
    {
        
        if (![_delegate YGTagsView:self shouldClickTagWithModel:tagModel])//判断特殊情况
        {
            return;
        }
        
    }
    tagModel.selected = !tagModel.selected;
    tagButton.selected = tagModel.selected;
    if ([_delegate respondsToSelector:@selector(YGTagsView:didClickTagWithModel:)])
    {
        [_delegate YGTagsView:self didClickTagWithModel:tagModel];
    }
}

- (void)reverseTagsWithIndexArray:(NSArray *)indexArray
{
    for (NSNumber * index in indexArray)
    {
        YGTagsModel * tagModel = _listArray[index.integerValue];
         tagModel.selected = !tagModel.selected;
         UIButton * tagButton = [self viewWithTag:index.integerValue + 100];
        tagButton.selected = tagModel.selected;
    }
}

- (void)reverseTagsWithTitlesArray:(NSArray *)titlesArray
{
//    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    for (NSString * tagString in titlesArray)
    {
        for (YGTagsModel * model in _listArray)
        {
            if ([tagString isEqualToString:model.title])
            {
                model.selected = !model.selected;
                UIButton * tagButton = [self viewWithTag:model.index + 100];
                tagButton.selected = model.selected;
            }
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpDefaultValue];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setUpDefaultValue];
    }
    return self;
}

- (void)setUpDefaultValue
{
    _selectedTitleColor = COLOR_BLACK;
    _normalTitleColor = COLOR_BLACK;
    _selectedBorderColor = COLOR_LINE;
    _normalBorderColor = COLOR_LINE;
    _selectedBackgroundColor = COLOR_WHITE;
    _normalBackgroundColor = COLOR_WHITE;
    _horizontalMargin = 20;
    _verticalMargin = 20;
    _verticalPadding = 10;
    _horizontalPadding = 10;
    _cornerRadius = 5;
    _titleFont = [UIFont systemFontOfSize:FONT_NORMAL];
}

@end
