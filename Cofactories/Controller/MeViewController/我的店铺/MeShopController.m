//
//  MeShopController.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/10.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MeShopController.h"
#import "MeShopCell.h"
#import "MeAddSupply_VC.h"//添加商品
#import "MeDetailSupply_VC.h"//商品详情页


static NSString *shopCellIdentifier = @"shopCell";

@interface MeShopController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    BOOL isEdit;

}


@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation MeShopController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的店铺";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(pressItem:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    isEdit = NO;
    [self creatCollectionView];
    //加号按钮
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(kScreenW - 70, kScreenH - 70, 50, 50);
    [addButton setImage:[UIImage imageNamed:@"MeShop-加号"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(actionOfAdd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
}

- (void)creatCollectionView {
    //创建CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 2.0;
    layout.minimumInteritemSpacing = 2.0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[MeShopCell class] forCellWithReuseIdentifier:shopCellIdentifier];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MeShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shopCellIdentifier forIndexPath:indexPath];
    if (isEdit == YES) {
        cell.deleteButton.hidden = NO;
        [cell.deleteButton setImage:[UIImage imageNamed:@"删除图片"] forState:UIControlStateNormal];
        
    } else {
        cell.deleteButton.hidden = YES;
    }
    cell.photoView.image = [UIImage imageNamed:@"5.jpg"];
    cell.shopTitle.text = @"法莱蓉面料 法兰绒布料 双面";
    cell.saleLabel.text = @"已售 999 件";
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MeDetailSupply_VC *medetailSupplyVC = [[MeDetailSupply_VC alloc] init];
    [self.navigationController pushViewController:medetailSupplyVC animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenW - 10*kZGY)/3, (kScreenW - 10*kZGY)/3 + 60*kZGY);
}
//分区边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10*kZGY, 0, 0, 0);
}


#pragma mark - 编辑按钮
- (void)pressItem:(UIBarButtonItem *)item {
    if ([item.title isEqualToString:@"编辑"]) {
        item.title = @"完成";
        isEdit = YES;
    } else {
        item.title = @"编辑";
        isEdit = NO;
    }
    [self.collectionView reloadData];
}


#pragma mark - 添加产品
- (void)actionOfAdd:(UIButton *)button {
    DLog(@"供应商添加");
    MeAddSupply_VC *meAddVC = [[MeAddSupply_VC alloc] init];
    [self.navigationController pushViewController:meAddVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
