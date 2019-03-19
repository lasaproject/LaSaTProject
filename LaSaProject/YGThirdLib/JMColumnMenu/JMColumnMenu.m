//
//  JMColumnMenuController.m
//  JMCollectionView
//
//  Created by JM on 2017/12/11.
//  Copyright © 2017年 ljm. All rights reserved.
//

#import "JMColumnMenu.h"
#import "JMColumnMenuCell.h"
#import "JMColumnMenuHeaderView.h"
#import "JMColumnMenuModel.h"

#define CELLID @"CollectionViewCell"
#define HEADERID @"headerId"

@interface JMColumnMenu ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** 导航栏的view */
@property (nonatomic, weak) UIView *navView;
/** navTitle */
@property (nonatomic, weak) UILabel *navTitle;
/** navColseBtn */
@property (nonatomic, weak) UIButton *navCloseBtn;
/** tags */
@property (nonatomic, strong) NSMutableArray *tagsArrM;
/** others */
@property (nonatomic, strong) NSMutableArray *otherArrM;
/** CollectionView */
@property (nonatomic, weak) UICollectionView *collectionView;
/** 头部视图 */
@property (nonatomic, weak) JMColumnMenuHeaderView *headerView;
/** 长按手势 */
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;


@end

@implementation JMColumnMenu

- (NSMutableArray *)tagsArrM {
    if (!_tagsArrM) {
        _tagsArrM = [NSMutableArray array];
    }
    return _tagsArrM;
}

- (NSMutableArray *)otherArrM {
    if (!_otherArrM) {
        _otherArrM = [NSMutableArray array];
    }
    return _otherArrM;
}

+ (instancetype)columnMenuWithTagsArrM:(NSMutableArray *)tagsArrM OtherArrM:(NSMutableArray *)otherArrM Delegate:(id<JMColumnMenuDelegate>)delegate{
    return [[self alloc] initWithTagsArrM:tagsArrM OtherArrM:otherArrM Delegate:delegate];
}

- (instancetype)initWithTagsArrM:(NSMutableArray *)tagsArrM OtherArrM:(NSMutableArray *)otherArrM Delegate:(id<JMColumnMenuDelegate>)delegate{
    if (self = [super init]) {

        self.delegate = delegate;
        
        for (int i = 0; i < tagsArrM.count; i++) {
            JMColumnMenuModel *model = tagsArrM[i];
            [self.tagsArrM addObject:model];
        }
        
        for (int i = 0; i < otherArrM.count; i++) {
            JMColumnMenuModel *model = otherArrM[i];
            [self.otherArrM addObject:model];
        }
        
        //初始化UI
        [self initColumnMenuUI];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    

}

#pragma mark - 初始化UI
- (void)initColumnMenuUI {
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, DEVICE_STATUS_BAR_HEIGHT+DEVICE_NAVIGATION_BAR_HEIGHT)];
    navView.backgroundColor = [UIColor whiteColor];
    self.navView = navView;
    [self.view addSubview:navView];
    
    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.navView.centerx - 100, DEVICE_STATUS_BAR_HEIGHT, 150, DEVICE_NAVIGATION_BAR_HEIGHT)];
    navTitle.text = @"频道定制";
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.textColor = [UIColor whiteColor];
    self.navTitle = navTitle;
    [self.navView addSubview:navTitle];
    
    UIButton *navCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navCloseBtn.frame = CGRectMake(self.navView.width - 40, DEVICE_STATUS_BAR_HEIGHT, 30, DEVICE_NAVIGATION_BAR_HEIGHT);
    [navCloseBtn setImage:[UIImage imageNamed:@"zixun_icon_close"] forState:UIControlStateNormal];
    self.navCloseBtn = navCloseBtn;
    [navCloseBtn addTarget:self action:@selector(navCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:navCloseBtn];
    
    //视图布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
    
    //UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navView.frame), self.view.width, self.view.height - self.navView.height-DEVICE_BOTTOM_MARGIN) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    [self.view addSubview:self.collectionView];
    
    //注册cell
    [self.collectionView registerClass:[JMColumnMenuCell class] forCellWithReuseIdentifier:CELLID];
    [self.collectionView registerClass:[JMColumnMenuHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADERID];
    
    //添加长按的手势
    self.longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [self.collectionView addGestureRecognizer:self.longPress];
   
}

#pragma mark - 手势识别
- (void)longPress:(UIGestureRecognizer *)longPress {
    NSLog(@"长按手势开始");
    //获取点击在collectionView的坐标
    CGPoint point=[longPress locationInView:self.collectionView];
    //从长按开始
    NSIndexPath *indexPath=[self.collectionView indexPathForItemAtPoint:point];
    
    //判断是否可以移动
    if (indexPath.item == 0) {
        return;
    }
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (indexPath.item == 0) {
            return;
        }
        [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        //长按手势状态改变
    } else if(longPress.state==UIGestureRecognizerStateChanged) {
        if (indexPath.item == 0) {
            return;
        }
        [self.collectionView updateInteractiveMovementTargetPosition:point];
        //长按手势结束
    } else if (longPress.state==UIGestureRecognizerStateEnded) {
        [self.collectionView endInteractiveMovement];
        //其他情况
    } else {
        [self.collectionView cancelInteractiveMovement];
    }
}


#pragma mark - UICollectionViewDataSource
//一共有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.tagsArrM.count;
    } else {
        return self.otherArrM.count;
    }
}

//每一个cell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JMColumnMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        JMColumnMenuModel *model = self.tagsArrM[indexPath.item];
        cell.model = model;
        cell.title.textColor = COLOR_WHITE;
        cell.emptyView.backgroundColor = COLOR_MAIN;
    } else {
        cell.model = self.otherArrM[indexPath.item];
        cell.title.textColor = COLOR_BLACK;
        cell.emptyView.backgroundColor = COLOR_TABLE;
    }
    
    return cell;
}

//和tableView差不多, 可设置头部和尾部
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        JMColumnMenuHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HEADERID forIndexPath:indexPath];
        if(headerView == nil)
        {
            headerView = [[JMColumnMenuHeaderView alloc] init];
        }
        if (indexPath.section == 0) {
            headerView.titleStr = @"设置频道分类";
            headerView.detailStr = @"已选频道拖拽可编辑顺序";
        } else if (indexPath.section == 1) {
            headerView.editBtn.hidden = YES;
            headerView.titleStr = @"  ";
            headerView.detailStr = @"点击可添加更多频道";
        }
        self.headerView = headerView;
        return headerView;
    }
    
    return nil;
}

//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 4, 10);
}

//头部视图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 70);
}


//定义每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.collectionView.width * 0.25 - 10, 53);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    JMColumnMenuModel *model;
    if (indexPath.section == 0) {
        model = self.tagsArrM[indexPath.item];
        //判断是否可以删除（0-可编辑，1-不可编辑）
        if ([model.state isEqualToString:@"1"]) {
            return;
        }

        [self.tagsArrM removeObjectAtIndex:indexPath.item];
        [self.otherArrM insertObject:model atIndex:0];
        
    } else if (indexPath.section == 1) {
    
        model  = self.otherArrM[indexPath.item];

        [self.otherArrM removeObjectAtIndex:indexPath.item];
        [self.tagsArrM addObject:model];

    }

    [_collectionView reloadData];
    
}



//在开始移动是调动此代理方法
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"开始移动");
    return YES;
}

//在移动结束的时候调用此代理方法
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSLog(@"结束移动");
    JMColumnMenuModel *model;
    if (sourceIndexPath.section == 0) {
        model = self.tagsArrM[sourceIndexPath.item];
        [self.tagsArrM removeObjectAtIndex:sourceIndexPath.item];
    } else {
        model = self.otherArrM[sourceIndexPath.item];
        [self.otherArrM removeObjectAtIndex:sourceIndexPath.item];
    }
    
    if (destinationIndexPath.section == 0) {
        [self.tagsArrM insertObject:model atIndex:destinationIndexPath.item];
    } else if (destinationIndexPath.section == 1) {
        [self.otherArrM insertObject:model atIndex:destinationIndexPath.item];
    }
    
    [collectionView reloadItemsAtIndexPaths:@[destinationIndexPath]];

}

#pragma mark - 更新block数组
- (void)updateBlockArr {
    
    if ([self.delegate respondsToSelector:@selector(columnMenuTagsArr:OtherArr:menu:)]) {
        [self.delegate columnMenuTagsArr:self.tagsArrM OtherArr:self.otherArrM menu:self];
    }
}

#pragma mark - 导航栏右侧关闭按钮点击事件
- (void)navCloseBtnClick {
    
    [self updateBlockArr];

}

@end
