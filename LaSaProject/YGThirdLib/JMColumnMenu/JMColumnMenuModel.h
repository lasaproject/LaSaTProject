//
//  JMColumnMenuModel.h
//  JMCollectionView
//
//  Created by 刘俊敏 on 2017/12/8.
//  Copyright © 2017年 ljm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMColumnMenu.h"

@interface JMColumnMenuModel : NSObject

@property (nonatomic, copy) NSString *ID;
/** title */
@property (nonatomic, copy) NSString *name;
/** 是否选中 */
//@property (nonatomic, assign) BOOL selected;
/** 是否允许删除 */
@property (nonatomic, copy) NSString *state;//（0-可编辑，1-不可编辑）

@end
