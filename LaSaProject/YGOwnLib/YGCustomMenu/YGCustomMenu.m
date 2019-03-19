//
//  SecondMenuView.m
//  LoveBB
//
//  Created by AngelLL on 15/10/22.
//  Copyright © 2015年 Daniel_Li. All rights reserved.
//

#import "YGCustomMenu.h"

@implementation YGCustomMenu
{
    void(^_handler)(NSInteger index);
}

+ (void)showMenuWithTitlesArray:(NSArray *)titlesArray imageArray:(NSArray *)imageArray rowHeight:(CGFloat)rowHeight trangleOrigin:(CGPoint)trangleOrigin tableViewX:(CGFloat)tableViewX tableViewWidth:(CGFloat)tableViewWidth handler:(void (^)(NSInteger index))handler
{
    [[self alloc] initWithTitlesArray:titlesArray imageArray:imageArray rowHeight:rowHeight trangleOrigin:trangleOrigin tableViewX:tableViewX tableViewWidth:tableViewWidth handler:handler];
}

- (instancetype)initWithTitlesArray:(NSArray *)titlesArray imageArray:(NSArray *)imageArray rowHeight:(CGFloat)rowHeight trangleOrigin:(CGPoint)trangleOrigin tableViewX:(CGFloat)tableViewX tableViewWidth:(CGFloat)tableViewWidth handler:(void (^)(NSInteger index))handler
{
    if (self = [super init])
    {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [COLOR_BLACK colorWithAlphaComponent:0.3];
        _titlesArray = titlesArray;
        _imageArray = imageArray;
        _rowHeight = rowHeight;
        _trangleOrigin = trangleOrigin;
        _tableViewX = tableViewX;
        _tableViewWidth = tableViewWidth;
        _handler = handler;
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    UIButton *button = [[UIButton alloc] initWithFrame:self.frame];
    [button addTarget:self action:@selector(bigButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(_tableViewX, _trangleOrigin.y + 10, _tableViewWidth, _rowHeight * _titlesArray.count) style:UITableViewStylePlain];
    _tableView.backgroundColor = COLOR_WHITE;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, 0.001)];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, 0.001)];
    _tableView.sectionFooterHeight = 0.001;
    _tableView.sectionHeaderHeight = 0.001;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.layer.cornerRadius = 4;
    _tableView.bounces = NO;
    _tableView.separatorColor = COLOR_LINE;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"YGCustomMenu"];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self addSubview:_tableView];

    [self show];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YGCustomMenu" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = COLOR_GRAY_DEEP;
    cell.textLabel.font = [UIFont systemFontOfSize:FONT_SMALL_1];
    cell.textLabel.text = _titlesArray[indexPath.row];
    [cell.textLabel mas_updateConstraints:^(MASConstraintMaker *make)
    {
        make.left.mas_equalTo(cell.imageView.mas_right).offset(5);
        make.centerY.mas_equalTo(cell.contentView);
    }];

    if (_imageArray.count > 0)
    {
        cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _handler(indexPath.row);
    _handler = nil;
    [self dismiss];
}


- (void)show
{
    [SYS_APPDELEGATE.window addSubview:self];

    self.alpha = 0;
    _tableView.height = 0;

    [UIView animateWithDuration:0.25 animations:^
    {
        self.alpha = 1;
        _tableView.height = _rowHeight * _titlesArray.count;
    }];

}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^
    {
        self.alpha = 0;
        _tableView.height = 0;
    }];

    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.25];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    //利用path进行绘制三角形

    CGContextBeginPath(context);//标记
    CGFloat originX = _trangleOrigin.x;
    CGFloat originY = _tableView.y;

    CGContextMoveToPoint(context,
            originX, originY - 5);//设置起点

    CGContextAddLineToPoint(context,
            originX - 2.5, originY);

    CGContextAddLineToPoint(context,
            originX + 2.5, originY);

    CGContextClosePath(context);//路径结束标志，不写默认封闭


    [self.tableView.backgroundColor setFill]; //设置填充色
    [self.tableView.backgroundColor setStroke]; //设置边框颜色

    CGContextDrawPath(context,
            kCGPathFillStroke);//绘制路径path
}

- (void)bigButtonClick
{
    [self dismiss];
}

@end
