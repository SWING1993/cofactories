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
#import "MeAddDesign_VC.h"
#import "SVPullToRefresh.h"
#import "FabricMarketModel.h"
#import "MeDetailSupply_VC.h"//商品详情页
#import "TableViewHeaderView.h"

static NSString *shopCellIdentifier = @"shopCell";
static NSString *headerIdentifier = @"header";
@interface MeShopController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    BOOL isEdit;
//    BOOL isReload;
}

@property (nonatomic,retain)UserModel * MyProfile;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *myShopGoodsArray;

@property (nonatomic)NSInteger page;

@end

@implementation MeShopController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.page = 1;
    //上拉加载更多数据
    __weak typeof(self) weakSelf = self;
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        weakSelf.page++;
        DLog(@"^^^^^^^^^^^^^^^^^^^^^^^");
        [HttpClient getMyShopWithUserID:weakSelf.MyProfile.uid page:@(weakSelf.page) WithCompletionBlock:^(NSDictionary *dictionary) {
            int statusCode = [dictionary[@"statusCode"] intValue];
            if (statusCode == 200) {
                NSArray *array = dictionary[@"message"];
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dic = (NSDictionary *)obj;
                    PersonalShop_Model *model = [PersonalShop_Model getPersonalShopModelWithDictionary:dic];
                    [weakSelf.myShopGoodsArray addObject:model];
                }];
                [weakSelf.collectionView.infiniteScrollingView stopAnimating];
                [weakSelf.collectionView reloadData];
            }
        }];
    }];
    
    [self netWork];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的店铺";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(pressItem:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    isEdit = NO;
    [self creatCollectionView];
    self.MyProfile = [[UserModel alloc]getMyProfile];
    //加号按钮
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(kScreenW - 70, kScreenH - 70, 50, 50);
    [addButton setImage:[UIImage imageNamed:@"MeShop-加号"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(actionOfAdd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
}

- (void)netWork {
    self.myShopGoodsArray = [NSMutableArray arrayWithCapacity:0];
    [HttpClient getMyShopWithUserID:self.MyProfile.uid page:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
        int statusCode = [dictionary[@"statusCode"] intValue];
        if (statusCode == 200) {
            NSArray *array = dictionary[@"message"];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                PersonalShop_Model *model = [PersonalShop_Model getPersonalShopModelWithDictionary:dic];
                [self.myShopGoodsArray addObject:model];
            }];
            if (self.myShopGoodsArray.count == 0) {
                self.collectionView.backgroundView = [[TableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) withImage:@"数据暂无" withLabelText:@"店铺空空如也，点击加号上传商品吧"];
            } else {
                self.collectionView.backgroundView = nil;
                [self.collectionView reloadData];
            }
        }
    }];
}

- (void)creatCollectionView {
    //创建CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 2*kZGY;
    layout.minimumInteritemSpacing = 2*kZGY;
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
    return self.myShopGoodsArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MeShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shopCellIdentifier forIndexPath:indexPath];
    
    if (isEdit == YES) {
        cell.deleteButton.hidden = NO;
        cell.deleteButton.tag = 222 + indexPath.row;
        [cell.deleteButton setImage:[UIImage imageNamed:@"删除图片"] forState:UIControlStateNormal];
        [cell.deleteButton addTarget: self action:@selector(actionOfDeleteItem:) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        cell.deleteButton.hidden = YES;
    }
    PersonalShop_Model *myShopModel = self.myShopGoodsArray[indexPath.row];
    if (myShopModel.photoArray.count > 0) {
        [cell.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PhotoAPI, myShopModel.photoArray[0]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
    } else {
        cell.photoView.image = [UIImage imageNamed:@"默认图片"];
    }
    
    cell.shopTitle.text = myShopModel.goodsName;
    cell.saleLabel.text = [NSString stringWithFormat:@"已售 %@ 件", myShopModel.goodsSales];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MeDetailSupply_VC *medetailSupplyVC = [[MeDetailSupply_VC alloc] initWithStyle:UITableViewStyleGrouped];
    PersonalShop_Model *myShopModel = self.myShopGoodsArray[indexPath.row];
    medetailSupplyVC.goodsID = myShopModel.goodsID;
    [self.navigationController pushViewController:medetailSupplyVC animated:YES];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenW - 10*kZGY)/3, (kScreenW - 10*kZGY)/3 + 60*kZGY);
}
//分区边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(3*kZGY, 3*kZGY, 3*kZGY, 3*kZGY);
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

#pragma mark - 删除商品
- (void)actionOfDeleteItem:(UIButton *)button {
    
    //删除商品
    PersonalShop_Model *myShopModel = self.myShopGoodsArray[button.tag - 222];
    [self.myShopGoodsArray removeObjectAtIndex:button.tag - 222];
    [HttpClient deleteUserShopWithShopID:myShopModel.goodsID withCompletionBlock:^(int statusCode) {
        DLog(@"^^^^^^^^^^^^^^^^%d", statusCode);
        if (statusCode == 200) {
            
            NSIndexPath *index = [NSIndexPath indexPathForItem:button.tag - 222 inSection:0];
            NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:1];
            [indexPaths addObject:index];
            [self performBatchUpdatesWithAction:UICollectionUpdateActionDelete indexPaths:indexPaths animated:isEdit];
        }
    }];
}

- (void)performBatchUpdatesWithAction:(UICollectionUpdateAction)action indexPaths:(NSArray *)indexPaths animated:(BOOL)animated {
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    [self.collectionView performBatchUpdates:^{
        switch (action) {
            case UICollectionUpdateActionInsert:
                [self.collectionView insertItemsAtIndexPaths:indexPaths];
                break;
            case UICollectionUpdateActionDelete:
                [self.collectionView deleteItemsAtIndexPaths:indexPaths];
            default:
                break;
        }
    } completion:^(BOOL finished) {
        if (!animated) {
            [UIView setAnimationsEnabled:YES];
        }
        if (self.myShopGoodsArray.count == 0) {
            self.collectionView.backgroundView = [[TableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) withImage:@"数据暂无" withLabelText:@"店铺空空如也，点击加号上传商品吧"];
        }
        [self.collectionView reloadData];
        
    }];
}

#pragma mark - 添加产品
- (void)actionOfAdd:(UIButton *)button {
    DLog(@"供应商添加");
    if (self.myUserType == UserType_designer) {
        //设计者
        MeAddDesign_VC *meDesignVC = [[MeAddDesign_VC alloc] init];
        [self.navigationController pushViewController:meDesignVC animated:YES];
    } else if (self.myUserType == UserType_supplier) {
        //供应商
        MeAddSupply_VC *meAddVC = [[MeAddSupply_VC alloc] init];
        [self.navigationController pushViewController:meAddVC animated:YES];
    }
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
