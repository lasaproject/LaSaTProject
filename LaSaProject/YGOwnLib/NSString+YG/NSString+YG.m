//
//  NSString+YG.m
//  FrienDo
//
//  Created by zhangkaifeng on 2017/10/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import "NSString+YG.h"

@implementation NSString (YG)

- (NSString *)pinyinValue
{
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef) mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *) [mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];

    return mutableString;
}

- (BOOL)isInt
{
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isFloat
{
    NSScanner *scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isIllegalPhone
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString *MOBILE = @"^13[0-9]{9}$|14[0-9]{9}|15[0-9]{9}$|18[0-9]{9}|17[0-9]{9}$";

    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];

    if (![regextestmobile evaluateWithObject:self])
    {
        [YGAppTool showToastWithText:@"手机号填写有误"];
        return YES;
    }
    return NO;
}

- (BOOL)isIllegalChineseName
{
    for (int i = 0; i < self.length; i++)
    {
        int a = [self characterAtIndex:i];
        //有英文
        if (a <= 0x4e00 || a >= 0x9fff)
        {
            [YGAppTool showToastWithText:@"请输入正确的姓名"];
            return YES;
        }
    }
    if (self.length < 2 || self.length > 8)
    {
        [YGAppTool showToastWithText:@"请输入正确的姓名"];
        return YES;
    }
    return NO;
}

- (BOOL)isIllegalIDCardNumber
{
    if (self.length <= 0)
    {
        [YGAppTool showToastWithText:@"请输入正确的身份证号码"];
        return YES;
    }

    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    if ([identityCardPredicate evaluateWithObject:self])
    {
        return NO;
    }

    [YGAppTool showToastWithText:@"请输入正确的身份证号码"];
    return YES;
}

- (BOOL)isIllegalEmail
{
    if (self.length <= 0)
    {
        [YGAppTool showToastWithText:@"请输入正确的邮箱"];
        return YES;
    }

    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if ([emailTest evaluateWithObject:self])
    {
        return NO;
    }

    [YGAppTool showToastWithText:@"请输入正确的邮箱"];
    return YES;
}

- (BOOL)isEmpty
{
    return [[self stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""];
}

- (BOOL)isIllegalWithName:(NSString *)name maxLength:(NSInteger)maxLength minLength:(NSInteger)minLength
{
    if (self.length > maxLength)
    {
        [YGAppTool showToastWithText:[NSString stringWithFormat:@"%@最多%ld个字", name, (long) maxLength]];
        return YES;
    }
    if (self.length < minLength)
    {
        [YGAppTool showToastWithText:[NSString stringWithFormat:@"%@最少%ld个字", name, (long) minLength]];
        return YES;
    }
    return NO;
}

@end
