//
// Created by zhangkaifeng on 2017/10/19.
// Copyright (c) 2017 ccyouge. All rights reserved.
//

#import "YGActionSheetView.h"

#define ROW_HEIGHT 40

@implementation YGActionSheetView
{
    UITableView *_tableView;

    void(^_handler)(NSInteger selectedIndex, NSString *selectedString);
}

- (instancetype)initWithTitlesArray:(NSArray *)titlesArray handler:(void (^)(NSInteger selectedIndex, NSString *selectedString))handler
{
    self = [super init];
    if (self)
    {
        _titlesArray = titlesArray;
        _handler = handler;
        [self configUI];

    }
    return self;
}

+ (instancetype)showWithTitlesArray:(NSArray *)titlesArray handler:(void (^)(NSInteger selectedIndex, NSString *selectedString))handler
{
    YGActionSheetView *actionSheetView = [[YGActionSheetView alloc] initWithTitlesArray:titlesArray handler:handler];
    [actionSheetView show];
    return actionSheetView;
}

- (void)setSelectedIndex:(int)selectedIndex
{
    _selectedIndex = selectedIndex;
    [_tableView reloadData];
}

- (void)configUI
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

    double height = _titlesArray.count * ROW_HEIGHT > DEVICE_SCREEN_HEIGHT / 3.0 ? DEVICE_SCREEN_HEIGHT / 3.0 : _titlesArray.count * ROW_HEIGHT;
    //tableview
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (CGFloat) (DEVICE_SCREEN_HEIGHT - height), self.width, (CGFloat) height) style:UITableViewStylePlain];
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, 0.001)];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SCREEN_WIDTH, 0.001)];
    _tableView.rowHeight = ROW_HEIGHT;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = COLOR_WHITE;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xx"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"xx"];
        cell.textLabel.textColor = COLOR_BLACK;
        cell.textLabel.font = [UIFont systemFontOfSize:FONT_NORMAL];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == _selectedIndex)
    {
        cell.textLabel.textColor = COLOR_MAIN;
    }
    else
    {
        cell.textLabel.textColor = COLOR_BLACK;
    }

    cell.textLabel.text = _titlesArray[(NSUInteger) indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_handler)
    {
        _handler(indexPath.row, _titlesArray[(NSUInteger) indexPath.row]);
        _handler = nil;
    }
    [self dismiss];
}

- (void)show
{
    [SYS_APPDELEGATE.window addSubview:self];

    self.alpha = 0;
    _tableView.y = DEVICE_SCREEN_HEIGHT;

    [UIView animateWithDuration:0.3 animations:^
    {
        self.alpha = 1;
        _tableView.y = DEVICE_SCREEN_HEIGHT - _tableView.height;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^
    {
        self.alpha = 0;
        _tableView.y = DEVICE_SCREEN_HEIGHT;
    }                completion:^(BOOL finished)
    {
        [self removeFromSuperview];
    }];


}

@end
