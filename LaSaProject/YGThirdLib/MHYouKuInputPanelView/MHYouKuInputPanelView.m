//
//  MHYouKuInputPanelView.m
//  MHDevelopExample
//
//  Created by CoderMikeHe on 17/2/16.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//
#import <YYText.h>

#import "MHYouKuInputPanelView.h"

#define MHCommentMaxWords 300

@interface MHYouKuInputPanelView ()<YYTextViewDelegate>

/** 底部工具条 */
@property (nonatomic , weak) UIView *bottomToolBar;

/** 头像 */
//@property (nonatomic , weak) MHImageView *avatarView;

/** commentLabel */
@property (nonatomic , weak) YYLabel *commentLabel;

/** topView */
@property (nonatomic , weak) UIView *topView;

/** textView */
@property (nonatomic , weak) YYTextView *textView;

/** bottomView */
@property (nonatomic , weak) UIView *bottomView;

/** 当前字数 */
@property (nonatomic , weak) YYLabel *words;

/** 表情  */
@property (nonatomic , weak) UIButton *emotionButton;

/** 记录之前编辑框的高度 */
@property (nonatomic , assign) CGFloat previousTextViewContentHeight;

/** 记录键盘的高度 */
@property (nonatomic , assign) CGFloat keyboardHeight;

/** cacheText */
@property (nonatomic , copy) NSString *cacheText;

/** 发送 */
@property (nonatomic , strong) UIButton *publishButton;

/** 发送前面竖线 */
@property (nonatomic , strong) UIView *lineHorizontalView;

@end

@implementation MHYouKuInputPanelView

- (void)dealloc
{
    [self _unregisterKeyboardNotification];
    
    
}

+ (instancetype)inputPanelView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化
        [self _setup];
        
        // 创建自控制器
        [self _setupSubViews];
        
        // 布局子控件
        [self _makeSubViewsConstraints];
        
        // 添加通知中心
        [self _addNotificationCenter];
        
    }
    return self;
}

- (void)setPlaceholderString:(NSString *)placeholderString
{
    _placeholderString = placeholderString;
    self.textView.placeholderText = placeholderString;
}

#pragma mark - 公共方法
- (void) show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self setNeedsUpdateConstraints];
    [self updateFocusIfNeeded];
    [self layoutIfNeeded];
    
    // 延迟一会儿
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
    });
}

- (void)dismissByUser:(BOOL)state
{
    if (!state) {
        // 自动消失
        if ([self.cacheText isEqualToString:self.textView.text]) {
          //   未做处理
        }else{
           //  如果不一样则需要保存
            if (self.textView.text.length==0)
            {
             //   输入框没做任何处理
                if ((self.cacheText.length == 0) || self.cacheText == nil|| [self.cacheText isKindOfClass: [NSNull class]]) {
                 //    存@""值
                    
                }
            }else{
                
            }
        }
    }else{
        // 解析数据
        
    }
    
    [self _dismiss];
}

//- (void)setCommentReply:(MHCommentReply *)commentReply
//{
//    _commentReply = commentReply;
    // 设置数据
//    [MHWebImageTool setImageWithURL:commentReply.user.avatarUrl placeholderImage:MHGlobalUserDefaultAvatar imageView:self.avatarView];
//    self.commentLabel.text = commentReply.text;
    // 设置placeholder
//    self.textView.placeholderText = [NSString stringWithFormat:@"回复%@",commentReply.user.nickname];
    // 设置text
    // 获取缓存text
//    self.cacheText = [[MHTopicManager sharedManager].replyDictionary objectForKey:commentReply.commentReplyId];
    // 缓存字体
//    self.textView.text = self.cacheText;
//}

#pragma mark - 私有方法
#pragma mark - 初始化
- (void)_setup
{
    self.backgroundColor = [UIColor clearColor];
    
}

#pragma mark - 创建自控制器
- (void)_setupSubViews
{
    // 设置控制层
    [self _setupControlView];
    
    // 设置底部工具条
    [self _setupBottomToolBar];
}


// 设置控制层
- (void)_setupControlView
{
    UIControl *backgroundControl = [[UIControl alloc] init];
    backgroundControl.backgroundColor = [COLOR_BLACK colorWithAlphaComponent:0.3];
    [backgroundControl addTarget:self action:@selector(_backgroundDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backgroundControl];
    
    [backgroundControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

// 设置底部工具条
- (void)_setupBottomToolBar
{
    // 底部工具条
    UIView *bottomToolBar = [[UIView alloc] init];
    bottomToolBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomToolBar];
    self.bottomToolBar = bottomToolBar;
    

    // textView
    YYTextView *textView = [[YYTextView alloc] init];
    textView.font = [UIFont systemFontOfSize:FONT_NORMAL];
    textView.textAlignment = NSTextAlignmentLeft;
    textView.textColor = COLOR_BLACK;
    UIEdgeInsets insets = textView.textContainerInset;
    insets.left = 10;
    insets.right = 10;
    textView.textContainerInset = insets;
    textView.returnKeyType = UIReturnKeySend;
    textView.enablesReturnKeyAutomatically = YES;
    textView.showsVerticalScrollIndicator = NO;
    textView.showsHorizontalScrollIndicator = NO;
    textView.backgroundColor = [UIColor whiteColor];
    textView.placeholderFont = textView.font;
    textView.delegate = self;
    textView.placeholderText = self.placeholderString;
    self.textView = textView;
    [self.bottomToolBar addSubview:textView];

    //发送
    _publishButton = [[UIButton alloc] init];
    [_publishButton setTitle:@"发送" forState:UIControlStateNormal];
    [_publishButton setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
    _publishButton.titleLabel.font = [UIFont systemFontOfSize:FONT_NORMAL];
    [bottomToolBar addSubview:_publishButton];
    [_publishButton addTarget:self action:@selector(_send) forControlEvents:UIControlEventTouchUpInside];
    
    _lineHorizontalView = [[UIView alloc] init];
    _lineHorizontalView.backgroundColor = COLOR_TABLE;
    [bottomToolBar addSubview:_lineHorizontalView];
    
}
#pragma mark - 布局子控件
- (void)_makeSubViewsConstraints
{
    // 布局bottomToolBar
    [self.bottomToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(self);
        make.bottom.equalTo(self).with.offset(33+14);
        make.height.mas_equalTo(33+14);
        
    }];

    
    // 布局textView
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.bottomToolBar.mas_left).offset(10);
        make.right.equalTo(self.bottomToolBar.mas_right).offset(-60);
        make.top.equalTo(self.bottomToolBar.mas_top).offset(7);
        make.bottom.equalTo(self.bottomToolBar.mas_bottom).offset(-7);
    }];
    
    
    [_publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.bottomToolBar);
        make.right.equalTo(self.bottomToolBar.mas_right).offset(-10);
        make.width.mas_offset(40);
    }];
    
    [_lineHorizontalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomToolBar.mas_right).offset(-56);
        make.centerY.equalTo(self.bottomToolBar.mas_centerY);
        make.height.mas_offset(20);
        make.width.mas_offset(1);
    }];
  
}


#pragma mark - 事件处理
/** 监听键盘的弹出和隐藏
 */
- (void)_keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    // 最终尺寸
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 开始尺寸
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    // 动画时间
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions options = ([userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] << 16 ) | UIViewAnimationOptionBeginFromCurrentState;
    
    __weak typeof(self) weakSelf = self;
    
    void(^animations)(void) = ^{
        // 回调
        [weakSelf _willShowKeyboardWithFromFrame:beginFrame toFrame:endFrame];
    };
    
    // 执行动画
    [UIView animateWithDuration:duration delay:0.0f options:options animations:animations completion:^(BOOL finished) {
        
        
        
    }];
    
}

/**
 背景被点击
 */
- (void)_backgroundDidClicked:(UIControl *)sender
{
    [self dismissByUser:NO];
}



#pragma mark - 添加通知中心
- (void)_addNotificationCenter
{
    // 添加键盘监听
    [self _registerKeyboardNotification];
}

// 添加监听
- (void)_registerKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

// 取消监听
- (void)_unregisterKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - 代理
- (void)textViewDidChange:(YYTextView *)textView
{
    // 改变高度
    [self _bottomToolBarWillChangeHeight:[self _getTextViewHeight:textView]];
    
    // 设置提醒文字
    [self _textViewWordsDidChange:textView];
    
}


- (BOOL) textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        
        // 发送回复
        [self _send];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        
    }
    
    return YES;
}

#pragma mark - 辅助方法
/** 键盘改变  后期于鏊考虑表情键盘 */
- (void)_willShowKeyboardWithFromFrame:(CGRect)fromFrame toFrame:(CGRect)toFrame
{

    if (fromFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        // 键盘弹起
        // bottomToolBar距离底部的高度
        [self _bottomToolBarWillChangeBottomHeight:toFrame.size.height];
        
    }else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height)
    {
        // 键盘落下
        // bottomToolBar距离底部的高度
        [self _bottomToolBarWillChangeBottomHeight:0];
        
    }else
    {
        // bottomToolBar距离底部的高度
        [self _bottomToolBarWillChangeBottomHeight:toFrame.size.height];
    }
}

/** 距离控制器底部的高度 */
- (void)_bottomToolBarWillChangeBottomHeight:(CGFloat)bottomHeight
{
    // 记录键盘的高度
    self.keyboardHeight = bottomHeight;
    
    // fix 掉键盘落下 输入框还没落下的bug 键盘掉下的bug
    if (bottomHeight<=0) {
        bottomHeight = -1 * DEVICE_SCREEN_HEIGHT;
    }
    // 之前bottomToolBar的尺寸
    [self.bottomToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        
        // 设置高度
        make.bottom.equalTo(self).with.offset(-1 * bottomHeight);
    }];
    
    
    // 键盘高度改变了也要去查看一下bottomToolBar的布局
    [self _bottomToolBarWillChangeHeight:[self _getTextViewHeight:self.textView]];
    
    
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    
    // 适当时候更新布局
    [self layoutIfNeeded];
    
}

/** 获取编辑框的高度 */
- (CGFloat)_getTextViewHeight:(YYTextView *)textView
{
    return textView.textLayout.textBoundingSize.height;
}

#pragma mark - 编辑框将要到那个高度
- (void)_bottomToolBarWillChangeHeight:(CGFloat)toHeight
{
    // 需要加上 MHTopicCommentToolBarWithNoTextViewHeight才是bottomToolBarHeight
    toHeight = toHeight + 14;
    
    if (toHeight < 14+33 || self.textView.attributedText.length == 0)
    {
        toHeight = 14+33;
    }
    
    // 不允许遮盖住 视频播放
    CGFloat maxHeight = DEVICE_SCREEN_HEIGHT - (DEVICE_SCREEN_WIDTH * 9.0f/16.0f + 20) - self.keyboardHeight;
    
    if (toHeight > maxHeight)
    {
        toHeight = maxHeight ;
    }
    
    // 高度是之前的高度  跳过
    if (toHeight == self.previousTextViewContentHeight) return;
    
    // 布局
    [self.bottomToolBar mas_updateConstraints:^(MASConstraintMaker *make) {
        //
        make.height.mas_equalTo(toHeight);
        //
    }];
    
    self.previousTextViewContentHeight = toHeight;
    
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:.25f animations:^{
        // 适当时候更新布局
        [self layoutIfNeeded];
    }];
    
}

/** textView文字发生改变 */
- (void)_textViewWordsDidChange:(YYTextView *)textView
{
    if ([[textView.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        return;
    }
    NSString *text = [NSString stringWithFormat:@"%zd/%d",textView.attributedText.length, MHCommentMaxWords];
    UIFont *font = [UIFont systemFontOfSize:FONT_NORMAL];
    UIColor *color = textView.attributedText.length<=MHCommentMaxWords ? COLOR_GRAY_DEEP : COLOR_MAIN;
    NSRange range = [text rangeOfString:[NSString stringWithFormat:@"%zd/",textView.attributedText.length]];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    attributedText.yy_font = font;
    attributedText.yy_color = COLOR_GRAY_DEEP;
    [attributedText yy_setColor:color range:range];
    self.words.attributedText = attributedText;
}

/** 发送 */
- (void) _send
{
    if ([[self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        [YGAppTool showToastWithText:@"回复内容不能为空"];
        return;
    }
    
    if (self.textView.attributedText.length==0) {
        [YGAppTool showToastWithText:@"回复内容不能为空"];
        return;
    }
    
    if (self.textView.attributedText.length > MHCommentMaxWords) {
        [YGAppTool showToastWithText:@"回复内容超过上限"];
        return;
    }
    
    // 代理回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputPanelView:andReplyContent:)]) {
        // 把内容调回去
        [self.delegate inputPanelView:self andReplyContent:_textView.text];
    }

    // 隐藏
    [self dismissByUser:YES];
}

/** 隐藏 */
- (void)_dismiss
{
    [self.textView resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.35f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 从父控件移除
        [self removeFromSuperview];
        
    });
    
}


@end
