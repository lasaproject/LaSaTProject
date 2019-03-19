//
//  YGCircleLoadingView.m
//  Bitoken
//
//  Created by zhangkaifeng on 2018/5/30.
//  Copyright © 2018 ccyouge. All rights reserved.
//

#import "YGCircleLoadingView.h"

#define KLoadingViewWidth  70
#define KShapeLayerWidth  45
#define KShapeLayerRadius  KShapeLayerWidth / 2
#define KShapeLayerLineWidth  3.5
#define KAnimationDurationTime  1.5
#define KShapeLayerMargin  (KLoadingViewWidth - KShapeLayerWidth) / 2

@implementation YGCircleLoadingView
{
    UIVisualEffectView *_blurView;
    BOOL _isShowing;
}
- (void)awakeFromNib
{
    [self setUI];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self setUI];
    }
    return self;
}

+ (instancetype)shareLoadView
{
    static YGCircleLoadingView *loadView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        loadView = [[YGCircleLoadingView alloc] init];
    });
    return loadView;
}

+ (void)showLoadingView
{
    [[YGCircleLoadingView shareLoadView] show];
}

+ (void)dismissLoadingView
{
    [[YGCircleLoadingView shareLoadView] dismiss];
}

- (void)setUI
{
    self.frame = CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, DEVICE_SCREEN_HEIGHT);

    _blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    _blurView.layer.cornerRadius = 10;
    _blurView.layer.masksToBounds = YES;
    _blurView.frame = CGRectMake(0, 0, 100, 100);
    _blurView.center = CGPointMake(DEVICE_SCREEN_WIDTH/2, DEVICE_SCREEN_HEIGHT/2);
    [self addSubview:_blurView];

    /// 底部的灰色layer
    CAShapeLayer *bottomShapeLayer = [CAShapeLayer layer];
    bottomShapeLayer.strokeColor = [UIColor colorWithRed:229 / 255.0 green:229 / 255.0 blue:229 / 255.0 alpha:1].CGColor;
    bottomShapeLayer.fillColor = [UIColor clearColor].CGColor;
    bottomShapeLayer.lineWidth = KShapeLayerLineWidth;
    bottomShapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(DEVICE_SCREEN_WIDTH/2 - KShapeLayerWidth/2, DEVICE_SCREEN_HEIGHT/2 - KShapeLayerWidth/2 - 10, KShapeLayerWidth, KShapeLayerWidth) cornerRadius:
            KShapeLayerRadius].CGPath;
    [self.layer addSublayer:bottomShapeLayer];

    /// 橘黄色的layer
    CAShapeLayer *ovalShapeLayer = [CAShapeLayer layer];
    ovalShapeLayer.strokeColor = COLOR_MAIN.CGColor;
    ovalShapeLayer.fillColor = [UIColor clearColor].CGColor;
    ovalShapeLayer.lineWidth = KShapeLayerLineWidth;
    ovalShapeLayer.path = bottomShapeLayer.path;
    [self.layer addSublayer:ovalShapeLayer];

    /// 起点动画
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(-1);
    strokeStartAnimation.toValue = @(1.0);

    /// 终点动画
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(0.0);
    strokeEndAnimation.toValue = @(1.0);

    /// 组合动画
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[
            strokeStartAnimation,
            strokeEndAnimation
    ];
    animationGroup.duration = KAnimationDurationTime;
    animationGroup.repeatCount = CGFLOAT_MAX;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    [ovalShapeLayer addAnimation:animationGroup forKey:nil];

    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"正在加载";
    titleLabel.textColor = COLOR_WHITE;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [titleLabel sizeToFit];
    titleLabel.centerx = DEVICE_SCREEN_WIDTH/2;
    titleLabel.centery = DEVICE_SCREEN_HEIGHT/2 + 30;
    [self addSubview:titleLabel];
}

- (void)dismiss
{
    if (_isShowing == NO)
    {
        return;
    }
    _isShowing = NO;
    [self removeFromSuperview];
}

- (void)show
{
    if (_isShowing)
    { // 如果没有退出动画，就不能继续添加
        return;
    }
    _isShowing = YES;
    /// 添加到主窗口中
    [SYS_APPDELEGATE.window addSubview:self];

}
@end
