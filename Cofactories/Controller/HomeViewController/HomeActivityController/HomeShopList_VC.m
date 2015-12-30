//
//  HomeShopList_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/29.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "HomeShopList_VC.h"
#import "MaterialShopCell.h"
#import "SVPullToRefresh.h"
#import "SearchShopMarketModel.h"
#import "materialShopDetailController.h"

static NSString *designCellIdentifier = @"designCell";

@interface HomeShopList_VC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate>
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic)NSInteger page;
@property (nonatomic,copy)NSString *userBusinessName;

@end

@implementation HomeShopList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSearchBar];
    [self creatCollectionView];
    self.page = 1;
    //上拉加载更多数据
    __weak typeof(self) weakSelf = self;
    [self.myCollectionView addInfiniteScrollingWithActionHandler:^{
        weakSelf.page++;
        [HttpClient searchDesignWithMarket:@"design" type:nil part:nil price:nil priceOrder:nil keyword:nil province:nil city:nil country:@"kr" page:@(weakSelf.page) WithCompletionBlock:^(NSDictionary *dictionary) {
            NSArray *array = dictionary[@"message"];
            for (NSDictionary *myDic in array) {
                SearchShopMarketModel *searchModel = [SearchShopMarketModel getSearchShopModelWithDictionary:myDic];
                [weakSelf.goodsArray addObject:searchModel];
            }
            [weakSelf.myCollectionView.infiniteScrollingView stopAnimating];
            [weakSelf.myCollectionView reloadData];
        }];
    }];
    
    [self netWork];
    
}

- (void)creatCollectionView {
    //创建CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 4;
    layout.minimumInteritemSpacing = 4;
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:kScreenBounds collectionViewLayout:layout];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.myCollectionView];
    
    [self.myCollectionView registerClass:[MaterialShopCell class] forCellWithReuseIdentifier:designCellIdentifier];
}

- (void)netWork {
    self.goodsArray = [NSMutableArray arrayWithCapacity:0];
    [HttpClient searchDesignWithMarket:@"design" type:nil part:nil price:nil priceOrder:nil keyword:nil province:nil city:nil country:@"kr" page:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
        NSArray *array = dictionary[@"message"];
        for (NSDictionary *myDic in array) {
            SearchShopMarketModel *searchModel = [SearchShopMarketModel getSearchShopModelWithDictionary:myDic];
            [self.goodsArray addObject:searchModel];
        }
        [self.myCollectionView reloadData];
        
    }];
}
#pragma mark - 搜索框
- (void)customSearchBar{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入商品名称";
    [searchBar setShowsCancelButton:YES];
    self.navigationItem.titleView = searchBar;
    
    for (UIView *view in [[searchBar.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)view;
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    NSLog(@"%@",searchBar.text);
    _userBusinessName = searchBar.text;

    self.page = 1;
    self.goodsArray = [NSMutableArray arrayWithCapacity:0];
    [HttpClient searchDesignWithMarket:@"design" type:nil part:nil price:nil priceOrder:nil keyword:_userBusinessName province:nil city:nil country:@"kr" page:@(self.page) WithCompletionBlock:^(NSDictionary *dictionary) {
        NSArray *array = dictionary[@"message"];
        for (NSDictionary *myDic in array) {
            SearchShopMarketModel *searchModel = [SearchShopMarketModel getSearchShopModelWithDictionary:myDic];
            [self.goodsArray addObject:searchModel];
        }
        [self.myCollectionView reloadData];
        
    }];
    
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MaterialShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:designCellIdentifier forIndexPath:indexPath];
    SearchShopMarketModel *myModel = self.goodsArray[indexPath.row];
    //    cell.photoView.image = [UIImage imageNamed:@"4.jpg"];
    if (myModel.photoArray.count > 0) {
        [cell.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PhotoAPI, myModel.photoArray[0]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
    } else {
        cell.photoView.image = [UIImage imageNamed:@"默认图片"];
    }
    
    cell.materialTitle.text = myModel.name;
    cell.priceLabel.attributedText = [self changeFontAndColorWithString:[NSString stringWithFormat:@"￥ %@", myModel.price]];
    cell.saleLabel.text = [NSString stringWithFormat:@"已售 %@ 件", myModel.sales];
    cell.placeLabel.text = myModel.city;
    return cell;
}
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    [self removeSearchBar];
    materialShopDetailController *materialShopVC = [[materialShopDetailController alloc] init];
    SearchShopMarketModel *myModel = self.goodsArray[indexPath.row];
    materialShopVC.shopID = myModel.ID;
    [self.navigationController pushViewController:materialShopVC animated:YES];
}
#pragma mark - UICollectionViewDelegateFlowLayout
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenW/2 - 2 , kScreenW/2 + 100);
}
//分区边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (NSAttributedString *)changeFontAndColorWithString:(NSString *)myString {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:myString];
    
    //设置尺寸
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(2, myString.length - 5)]; // 0为起始位置 length是从起始位置开始 设置指定字体尺寸的长度
    
    return attributedString;
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
