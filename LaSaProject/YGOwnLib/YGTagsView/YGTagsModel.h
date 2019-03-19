//
//  YGTagsModel.h
//  GoldSalePartner
//
//  Created by 管宏刚 on 2017/10/19.
//  Copyright © 2017年 曹来东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YGTagsModel : NSObject
@property (nonatomic,strong) NSString *title;//标题
@property (nonatomic,assign) int index;//位置
@property (nonatomic,assign) BOOL selected;//选中状态
@end
