//
//  UILabel+SizeToFit.m
//  YogeeLiveShop
//
//  Created by zhangkaifeng on 16/7/28.
//  Copyright © 2016年 ccyouge. All rights reserved.
//

#import "UILabel+YG.h"

@implementation UILabel (YG)

-(void)sizeToFitVerticalWithMaxWidth:(float)width
{
    self.frame = CGRectMake(self.x, self.y, width, self.height);
    self.numberOfLines = 0;
    [self sizeToFit];
}

-(void)sizeToFitHorizontal
{
    self.numberOfLines = 1;
    [self sizeToFit];
}

-(void)addAttributedWithString:(NSString *)string range:(NSRange)range color:(UIColor *)color
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:color
                          range:range];
    self.attributedText = attributedStr;
}

- (void)addAttributedWithString:(NSString *)string lineSpace:(CGFloat)lineSpace
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    self.attributedText = attributedString;
    self.lineBreakMode = NSLineBreakByTruncatingTail;
}

+ (CGSize)calculateWidthWithString:(NSString *)string textFont:(UIFont *)font numerOfLines:(NSInteger)numberOfLines maxWidth:(float)maxWidth
{

    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.font = font;
    textLabel.text = string;
    textLabel.numberOfLines = numberOfLines;
    textLabel.width = maxWidth;
    [textLabel sizeToFit];

    return textLabel.size;
}


@end
