//
//  ZGYMallDownView.m
//  MallOfCofactories
//
//  Created by 赵广印 on 16/4/16.
//  Copyright © 2016年 聚工科技. All rights reserved.
//

#import "ZGYMallDownView.h"
#import "ZGYTextCollectionItem.h"
#import "ZGYMallTitleView.h"
#import "ZGYMallSelectModel.h"
#import "ZGYKoreaSelectView.h"

#define kDragBtnHeight 30//拖拽按钮的高度
static NSString *priceCellIdentifier = @"priceCell";
static NSString *moreTextCellIdentifier = @"moreTextCell";
static NSString *moreTitleCellIdentifier = @"moreTitleCell";
static NSString *moreLineCellIdentifier = @"moreLineCell";
static NSString *priceSelect = @"默认排序";
@implementation ZGYMallDownView {
    SelectType currType;
    UIView* selectView;
    UIButton* dragBtn;
    CGFloat currH;//当前视图的高度
    NSArray *moreTitleArray;
    UICollectionView *moreCollectionView;
    
    NSMutableDictionary *moreDic;
    
    UILabel *myTitleLabel;
    CALayer *lineOfFooter;
}


- (instancetype)initWithFrame:(CGRect)frame withSelectType:(SelectType)type {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatDownViewWithFrame:frame withSelectType:type];
    }
    return self;
}

- (void)creatDownViewWithFrame:(CGRect)frame withSelectType:(SelectType)type {
    currType = type;
    self.frame = frame;
    self.backgroundColor = [UIColor colorWithRed:0.145 green:0.145 blue:0.145 alpha:0];
    self.userInteractionEnabled = YES;
    
    UIView* touchView = [[UIView alloc] initWithFrame:self.bounds];
    touchView.backgroundColor = [UIColor clearColor];
    [self addSubview:touchView];
    UITapGestureRecognizer* tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
    [touchView addGestureRecognizer:tapG];
    
    //操作视图
    selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
    selectView.backgroundColor = [UIColor whiteColor];
    selectView.layer.masksToBounds = YES;
    [self addSubview:selectView];
    self.opaque = NO;
    
    
    switch (currType) {
        case 0:
            [self creatMoreView];
            break;
        case 1:
            [self creatNewView];
            break;
        case 2:
            [self creatPriceView];
            break;
        
        default:
            break;
    }
}

- (void)creatCollectionFooterView {
    lineOfFooter = [CALayer layer];
    lineOfFooter.frame = CGRectMake(20, 5, kScreenW - 40, 0.6);
    lineOfFooter.backgroundColor = kLineGrayCorlor.CGColor;
}

- (void)creatCollectionHeaderView {
    myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
    myTitleLabel.font = [UIFont systemFontOfSize:15];
    myTitleLabel.textColor = [UIColor lightGrayColor];
}


- (void)creatMoreView {
//    NSLog(@"————————————————————————筛选");
    
    
    [self creatNewDictionary];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    
    moreCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 - kSelectViewHeight - 44) collectionViewLayout:layout];
    moreCollectionView.delegate = self;
    moreCollectionView.dataSource = self;
    moreCollectionView.backgroundColor = [UIColor whiteColor];
    [selectView addSubview:moreCollectionView];
    
    [moreCollectionView registerClass:[ZGYTextCollectionItem class] forCellWithReuseIdentifier:moreTextCellIdentifier];
    
    [moreCollectionView registerClass:[ZGYMallTitleView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:moreTitleCellIdentifier];
    [moreCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:moreLineCellIdentifier];
    
    
    //确定按钮
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, kScreenH - 64 - kSelectViewHeight - 44, kScreenW, 44);
    doneButton.backgroundColor = kMainDeepBlue;
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(actionOfMoreDone:) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:doneButton];
    
    [UIView animateWithDuration:0.35f animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.145 green:0.145 blue:0.145 alpha:0.65];
        selectView.frame = CGRectMake(0, 0, self.frame.size.width, kScreenH - 64 - kSelectViewHeight);
        
    } completion:^(BOOL finished){
        currH = selectView.bounds.size.height;
    }];
}

- (void)creatNewView {
//    NSLog(@"————————————————————————最新");
//    [self creatNewDictionary];
}

- (void)creatPriceView {
//    NSLog(@"————————————————————————价格排序");
    [self creatNewDictionary];
    float hh = 44 * [moreDic[@"价格"] count] + kDragBtnHeight;
    UITableView *priceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, selectView.bounds.size.width, hh)];
    priceTableView.delegate = self;
    priceTableView.dataSource = self;
    priceTableView.rowHeight = 44;
    [selectView addSubview:priceTableView];
    [priceTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:priceCellIdentifier];
    
    //底部的拖动按钮
    dragBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dragBtn.backgroundColor = [UIColor whiteColor];
    dragBtn.frame = CGRectMake(0, 0, kScreenW, 0);
    dragBtn.adjustsImageWhenHighlighted = NO;
    [dragBtn setImage:[UIImage imageNamed:@"MallShow"] forState:UIControlStateNormal];
    [dragBtn addTarget:self action:@selector(dragMoving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [dragBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [dragBtn addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dragBtn.bounds.size.width, 1)];
    line.backgroundColor = [UIColor colorWithRed:0.835 green:0.831 blue:0.827 alpha:0.5];
    [dragBtn addSubview:line];
    [selectView addSubview:dragBtn];
    
    [UIView animateWithDuration:0.35f animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.145 green:0.145 blue:0.145 alpha:0.65];
        selectView.frame = CGRectMake(0, 0, self.frame.size.width, hh);
        dragBtn.frame = CGRectMake(0, selectView.bounds.size.height-kDragBtnHeight, selectView.bounds.size.width, kDragBtnHeight);
        
    } completion:^(BOOL finished){
        currH = selectView.bounds.size.height;
    }];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [moreDic[@"价格"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (currType == SelectTypeOfPrice) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:priceCellIdentifier forIndexPath:indexPath];
        ZGYMallSelectModel *myModel = moreDic[@"价格"][indexPath.row];
        NSLog(@"^^^^^^^^^%@", myModel.name);
        cell.textLabel.text = myModel.name;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        if (myModel.isSelect) {
            cell.textLabel.textColor = kMainDeepBlue;
        } else {
            cell.textLabel.textColor = [UIColor darkGrayColor];
        }
        return cell;
    } else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (currType == SelectTypeOfPrice) {
        ZGYMallSelectModel *myModel = moreDic[@"价格"][indexPath.row];
        if (self.selected) {
            self.selected(currType, myModel.name);
        }
        if (!myModel.isSelect) {
            myModel.isSelect = YES;
        }
        for (int i = 0; i < [moreDic[@"价格"] count]; i++) {
            if (i != indexPath.row) {
                ZGYMallSelectModel *selectModel = moreDic[@"价格"][i];
                selectModel.isSelect = NO;
            }
        }
        
        [self findIsSelect];
        
        [self tappedCancel];
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [moreDic[moreTitleArray[section]] count];
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZGYTextCollectionItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:moreTextCellIdentifier forIndexPath:indexPath];
    ZGYMallSelectModel *selectModel = moreDic[moreTitleArray[indexPath.section]][indexPath.row];
    cell.myTextLabel.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    cell.myTextLabel.text = selectModel.name;
    if (selectModel.isSelect) {
        cell.myTextLabel.backgroundColor = kMainDeepBlue;
        cell.myTextLabel.textColor = [UIColor whiteColor];
    } else {
        cell.myTextLabel.backgroundColor = [UIColor whiteColor];
        cell.myTextLabel.textColor = [UIColor darkGrayColor];
    }
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        ZGYMallTitleView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:moreTitleCellIdentifier forIndexPath:indexPath];
        headerView.myTitleLabel.text = moreTitleArray[indexPath.section];
        return headerView;
    } else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:moreLineCellIdentifier forIndexPath:indexPath];
        [self creatCollectionFooterView];
        [footerView.layer addSublayer:lineOfFooter];
        return footerView;
    }
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
        ZGYMallSelectModel *myModel = moreDic[moreTitleArray[indexPath.section]][indexPath.row];
        if (!myModel.isSelect) {
            myModel.isSelect = YES;
        } 
        //加上这个实现分区单选
        for (int i = 0; i < moreTitleArray.count; i++) {
            NSArray *items = moreDic[moreTitleArray[i]];
            if (i == indexPath.section) {
                for (int j = 0; j < items.count; j++) {
                    if (j != indexPath.row) {
                        ZGYMallSelectModel *selectModel = items[j];
                        selectModel.isSelect = NO;
                    }
                }
            }
        }
        [moreCollectionView reloadData];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((kScreenW - 100)/4, 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 20, 15, 20);
}

//区头高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(100, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kScreenW, 10);
}
#pragma mark - 处理第一个筛选的数据
- (void)actionOfMoreDone:(UIButton *)button {
    //获取更多一栏的选择数据
    [self findIsSelect];
    
    
    [self tappedCancel];
}

#pragma mark - 拖动
- (void) dragMoving: (UIButton *)sender withEvent:ev
{
    CGPoint point = [[[ev allTouches] anyObject] locationInView:selectView];
    
    if (point.y > currH - kDragBtnHeight) {
        return;
    }
    
    selectView.frame = CGRectMake(0, 0, selectView.bounds.size.width, point.y + kDragBtnHeight);
    dragBtn.frame = CGRectMake(0, selectView.bounds.size.height - kDragBtnHeight, selectView.bounds.size.width, kDragBtnHeight);
    
    if (point.y < currH/2) {
        sender.accessibilityIdentifier = @"1";
    }else{
        sender.accessibilityIdentifier = @"0";
    }
}

- (void)touchDown:(UIButton*)sender{
    sender.accessibilityIdentifier = @"0";
}

- (void)touchUpInside:(UIButton*)sender{
    BOOL cando = [sender.accessibilityIdentifier boolValue];
    if (cando) {
        [self tappedCancel];
    }else{
        //恢复
        [self noChange];
    }
}

- (void)noChange{
    //
    [UIView animateWithDuration:0.35f animations:^{
        selectView.frame = CGRectMake(0, 0, self.frame.size.width, currH);
        dragBtn.frame = CGRectMake(0, selectView.bounds.size.height - kDragBtnHeight, selectView.bounds.size.width, kDragBtnHeight);
    }];
}
//收起View
- (void)tappedCancel{
    if (self.removeTheView) {
        self.removeTheView(YES);
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.145 green:0.145 blue:0.145 alpha:0];
        
        selectView.frame = CGRectMake(0, 0, selectView.frame.size.width, 0);
        
    } completion:^(BOOL finished){
        if (finished) {
            [self removeFromSuperview];
            [selectView removeFromSuperview];
            selectView = nil;
        }
    }];
}

- (void)creatNewDictionary {
    moreTitleArray = @[@"所有分类", @"商品分类", @"款式分类", @"价格"];
    if (ApplicationDelegate.moreSelectDic) {
        moreDic = ApplicationDelegate.moreSelectDic;
    } else {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"KoreaMallSelect" ofType:@"plist"];
        NSDictionary *plistDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        moreDic = [NSMutableDictionary dictionaryWithDictionary:plistDic];
        for (int i = 0; i < moreTitleArray.count; i++) {
            NSMutableArray *array = moreDic [moreTitleArray[i]];
            NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dic in array) {
                ZGYMallSelectModel *selectModel = [ZGYMallSelectModel getZGYmallSelectModdelWithDictionary:dic];
                [items addObject:selectModel];
            }
            [moreDic setObject:items forKey:moreTitleArray[i]];
        }
    }
}


- (void)findIsSelect {
    moreTitleArray = @[@"所有分类", @"商品分类", @"款式分类",@"价格"];
    ApplicationDelegate.moreSelectDic = moreDic;
    NSArray *myArray = @[@"year", @"type", @"part", @"priceOrder"];
    NSMutableDictionary *selectDic = [NSMutableDictionary dictionaryWithCapacity:0];
    for (int i = 0; i < myArray.count; i++) {
        NSArray *array = moreDic[moreTitleArray[i]];
        NSString *selectString = nil;
        for (ZGYMallSelectModel *myModel in array) {
            if (myModel.isSelect) {
                selectString = myModel.mark;
            }
        }
        if (selectString.length > 0 && ![selectString isEqualToString:@"空"]) {
            
            [selectDic setObject:selectString forKey:myArray[i]];
        }
    }
    if (self.moreSelected) {
        self.moreSelected(currType, selectDic);
    }
}


@end
