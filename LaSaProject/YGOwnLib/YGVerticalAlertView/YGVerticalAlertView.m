//
//  YGVerticalAlertView.m
//  FindingSomething
//
//  Created by zhangkaifeng on 16/7/6.
//  Copyright © 2016年 韩伟. All rights reserved.
//

#import "YGVerticalAlertView.h"

@implementation YGVerticalAlertView
{
    UIView *_baseView;
    void(^_handler)(NSInteger buttonIndex);
}

- (instancetype)initWithTitle:(NSString *)titleString buttonTitlesArray:(NSArray *)buttonTitlesArray buttonColorsArray:(NSArray *)buttonColorsArray handler:(void (^)(NSInteger buttonIndex))handler
{
    self = [super init];
    if (self) {
        _titleString = titleString;
        _titlesArray = buttonTitlesArray;
        _colorsArray = buttonColorsArray;
        _handler = handler;
        [self configUI];
    }
    return self;
}

+ (void)showAlertWithTitle:(NSString *)titleString buttonTitlesArray:(NSArray *)buttonTitlesArray buttonColorsArray:(NSArray *)buttonColorsArray handler:(void (^)(NSInteger buttonIndex))handler
{
    YGVerticalAlertView * verticalAlertView;
    verticalAlertView = [[self alloc]initWithTitle:titleString buttonTitlesArray:buttonTitlesArray buttonColorsArray:buttonColorsArray handler:handler];
}

-(void)configUI
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    
    //白色
    _baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH - 120, 0)];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_baseView];
    
    //提示文字
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, _baseView.width - 40, 0)];
    titleLabel.textColor = COLOR_BLACK;
    titleLabel.font = [UIFont systemFontOfSize:FONT_NORMAL];
    titleLabel.text = _titleString;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectMake(titleLabel.x, titleLabel.y, _baseView.width - 40, titleLabel.height);
    [_baseView addSubview:titleLabel];
    
    //按钮
    for (int i = 0; i<_titlesArray.count; i++)
    {
        //按钮
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, titleLabel.y+titleLabel.height + 20 + 40 *i, _baseView.width, 40)];
        [button setTitle:_titlesArray[i] forState:UIControlStateNormal];
        [button setTitleColor:_colorsArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = titleLabel.font;
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_baseView addSubview:button];
        
        //线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, button.width, 0.5)];
        lineView.backgroundColor = COLOR_GRAY_LIGHT;
        [button addSubview:lineView];
        
        //如果是最后一个
        if (i == _titlesArray.count - 1)
        {
            _baseView.frame = CGRectMake(0, 0, _baseView.width, button.y+button.height);
            _baseView.center = self.center;
            _baseView.layer.cornerRadius = 5;
        }
    }
    
    [self show];
}

-(void)show
{
    
    [SYS_APPDELEGATE.window addSubview:self];
    
    self.alpha = 0;
    _baseView.frame = CGRectMake(_baseView.x, _baseView.y, _baseView.width, _baseView.height/10);
    
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 1;
    }];
    
    
    [UIView animateWithDuration:1 // 动画时长
                          delay:0.0 // 动画延迟
         usingSpringWithDamping:0.2 // 类似弹簧振动效果 0~1
          initialSpringVelocity:0 // 初始速度
                        options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
                     animations:^{
                         _baseView.frame = CGRectMake(_baseView.x, _baseView.y, _baseView.width, _baseView.height*10);
                     } completion:nil];
}

-(void)dismiss
{
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
        _baseView.frame = CGRectMake(_baseView.x, _baseView.y, _baseView.width, 0);
    }];
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.4];
    
}

-(void)buttonClick:(UIButton *)button
{
    if (_handler)
    {
        _handler(button.tag - 100);
    }
    [self dismiss];
}

@end
