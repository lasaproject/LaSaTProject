//
//  JMColumnMenuCell.m
//  JMCollectionView
//
//  Created by 刘俊敏 on 2017/12/7.
//  Copyright © 2017年 ljm. All rights reserved.
//

#import "JMColumnMenuCell.h"

@implementation JMColumnMenuCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //空View
        self.emptyView = [[UIView alloc] initWithFrame:CGRectZero];
        self.emptyView.backgroundColor = COLOR_MAIN;
        self.emptyView.layer.masksToBounds = YES;
        self.emptyView.layer.cornerRadius = 3.f;
        [self.contentView addSubview:self.emptyView];
        
        //标题
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.title.font = [UIFont systemFontOfSize:15];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.textColor = [UIColor whiteColor];
        [self.emptyView addSubview:self.title];
    
    }
    return self;
}

- (void)updateAllFrame:(JMColumnMenuModel *)model {
    self.emptyView.frame = CGRectMake(5, 6.5, self.contentView.width - 10, self.contentView.height - 13);
    
    self.title.size = [self returnTitleSize];

    self.title.center = CGPointMake(self.emptyView.width / 2, self.emptyView.height / 2);
    
}

- (void)setModel:(JMColumnMenuModel *)model {
    _model = model;
    
    //标题文字处理
    if (model.name.length == 2) {
        self.title.font = [UIFont systemFontOfSize:15];
    } else if (model.name.length == 3) {
        self.title.font = [UIFont systemFontOfSize:14];
    } else if (model.name.length == 4) {
        self.title.font = [UIFont systemFontOfSize:13];
    } else if (model.name.length > 4) {
        self.title.font = [UIFont systemFontOfSize:12];
    }
    
    self.title.text = model.name;
    if ([model.state isEqualToString:@"1"]) { //按钮样式区别 （0-可编辑，1-不可编辑）
        self.title.textColor = [UIColor redColor];
    }else{
        self.title.textColor = [UIColor whiteColor];
    }
    
    [self updateAllFrame:model];
}

- (CGSize)returnTitleSize {
    CGFloat maxWidth = self.emptyView.width - 12;
    CGSize size = [self.title.text boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                                options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:self.title.font}
                                                context:nil].size;
    return size;
}


@end
