
#import <UIKit/UIKit.h>

@interface UIView (YG)

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat centerx;
@property (assign, nonatomic) CGFloat centery;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;

//q弹效果
-(void)showQAnimate;

//渐变效果
-(void)showFadeAnimate;

@end
