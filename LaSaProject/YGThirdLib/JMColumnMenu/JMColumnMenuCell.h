//
//  JMColumnMenuCell.h
//  JMCollectionView
//
//  Created by 刘俊敏 on 2017/12/7.
//  Copyright © 2017年 ljm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMColumnMenuModel.h"

@interface JMColumnMenuCell : UICollectionViewCell

/** title */
@property (nonatomic, strong) UILabel *title;
/** 数据模型 */
@property (nonatomic, strong) JMColumnMenuModel *model;
/** 空View */
@property (nonatomic, strong) UIView *emptyView;

@end
