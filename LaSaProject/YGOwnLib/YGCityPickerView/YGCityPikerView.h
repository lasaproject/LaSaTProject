//
//  YGCityPikerView.h
//  FindingSomething
//
//  Created by apple on 15/12/24.
//  Copyright © 2015年 韩伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@interface YGCityPikerView : UIView<UIPickerViewDelegate, UIPickerViewDataSource>

/**
 * 展示方法
 * @param handler 确定block
 * @return 本view
 */
+ (instancetype)showWithHandler:(void (^)(NSString *province, NSString* city, NSString* district))handler;

/**
 * 选择某省市区
 * @param province 省
 * @param city 市
 * @param district 区
 */
- (void)selectProvince:(NSString *)province city:(NSString *)city district:(NSString *)district;

@end
