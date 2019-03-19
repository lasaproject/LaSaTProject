

#import "UIView+YG.h"
@implementation UIView (YG)

-(void)setCenterx:(CGFloat)centerx
{
    CGPoint center = self.center;
    center.x = centerx;
    self.center = center;
}
-(CGFloat)centerx
{
    return self.center.x;
}
-(void)setCentery:(CGFloat)centery
{
    CGPoint center = self.center;
    center.y = centery;
    self.center = center;
}
-(CGFloat)centery
{
    return self.center.y;
}

-(void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
    
}
-(CGFloat)x{
    return self.frame.origin.x;
}
-(void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y=y;
    self.frame = frame;
}
-(CGFloat)y{

    return self.origin.y;
}
-(void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
-(CGSize)size
{
    return self.frame.size;
}
-(void)setOrigin:(CGPoint)origin

{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
-(CGPoint)origin
{
    return  self.frame.origin;
}
-(void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
-(CGFloat)width
{
    return self.frame.size.width;
}
-(void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
-(CGFloat)height
{
    return  self.frame.size.height;
}

-(void)showQAnimate
{
    //需要实现的帧动画,这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 0.5;
    animation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:animation forKey:nil];
}

-(void)showFadeAnimate
{
    self.alpha = 0;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.alpha = 1;
    } completion:nil];
}

@end
