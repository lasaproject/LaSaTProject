//
//  NSString+YG.h
//  FrienDo
//
//  Created by zhangkaifeng on 2017/10/26.
//  Copyright © 2017年 ccyouge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YG)

/**
 * 转成拼音（自动添加空格，方便切割）
 */
@property (nonatomic, strong, readonly) NSString *pinyinValue;

/**
 * 判断是否为int
 */
@property (nonatomic, assign, readonly) BOOL isInt;

/**
 * 判断是否为float
 */
@property (nonatomic, assign, readonly) BOOL isFloat;

/**
 * 判断是否为空（除去空格）
 */
@property (nonatomic, assign, readonly) BOOL isEmpty;






#pragma warning "注意，以下方法均自动弹出toast"

/**
 * 判断是否不是电话号
 */
@property (nonatomic, assign, readonly) BOOL isIllegalPhone;

/**
 * 判断是否不是中国姓名
 */
@property (nonatomic, assign, readonly) BOOL isIllegalChineseName;

/**
 * 判断是否不是身份证
 */
@property (nonatomic, assign, readonly) BOOL isIllegalIDCardNumber;

/**
 * 判断是否不是邮箱
 */
@property (nonatomic, assign, readonly) BOOL isIllegalEmail;

/**
 *  判断给定string是否非法
 *
 *  @param name      判断的名字
 *  @param maxLength 最大长度
 *  @param minLength 最小长度
 *
 *  @return 非法返回真
 */
- (BOOL)isIllegalWithName:(NSString *)name maxLength:(NSInteger)maxLength minLength:(NSInteger)minLength;

@end
