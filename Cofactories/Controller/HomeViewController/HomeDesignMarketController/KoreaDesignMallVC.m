//
//  KoreaDesignMallVC.m
//  Cofactories
//
//  Created by 赵广印 on 16/4/18.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "KoreaDesignMallVC.h"
#import "MaterialShopCell.h"
#import "ShoppingMallDetail_VC.h"
#import "SVPullToRefresh.h"
#import "SearchShopMarketModel.h"
#import "ZGYMallSelectView.h"
#import "ZGYKoreaSelectView.h"

static NSString *materialCellIdentifier = @"materialCell";
@interface KoreaDesignMallVC ()<UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, ZGYMallSelectViewDelegate> {
    UISearchBar *mySearchBar;
    UIButton    *backgroundView;
    NSString    *searchText;
}

@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic)NSInteger page;
@property (nonatomic, strong) NSMutableDictionary *postDic;

@end

@implementation KoreaDesignMallVC
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self controlBackgroundView:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self creatCollectionView];
    
    [self creatSelectView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickBackgroundViewAction) name:UIKeyboardWillHideNotification object:nil];
    [self customSearchBar];
    [self creatBackgroundView];
    
    self.page = 1;
    //上拉加载更多数据
    __weak typeof(self) weakSelf = self;
    [self.myCollectionView addInfiniteScrollingWithActionHandler:^{
        weakSelf.page++;
        
//        weakSelf.goodsArray = [NSMutableArray arrayWithCapacity:0];
//        [weakSelf.postDic setObject:@"design" forKey:@"market"];
//        [weakSelf.postDic setObject:@"kr" forKey:@"country"];
        [weakSelf.postDic setObject:@(weakSelf.page) forKey:@"page"];
        [HttpClient searchKoreaDesignWithDictionary:weakSelf.postDic WithBlock:^(NSDictionary *dictionary) {
            NSArray *array = dictionary[@"data"];
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

- (void)netWork {
    self.goodsArray = [NSMutableArray arrayWithCapacity:0];
    
    self.postDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self.postDic setObject:@"design" forKey:@"market"];
    [self.postDic setObject:@"kr" forKey:@"country"];
    [HttpClient searchKoreaDesignWithDictionary:self.postDic WithBlock:^(NSDictionary *dictionary) {
        NSArray *array = dictionary[@"data"];
        for (NSDictionary *myDic in array) {
            SearchShopMarketModel *searchModel = [SearchShopMarketModel getSearchShopModelWithDictionary:myDic];
            [self.goodsArray addObject:searchModel];
        }
        [self.myCollectionView reloadData];
    }];
    
}


- (void)creatSelectView {
    ZGYMallSelectView *selectView = [[ZGYMallSelectView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kSelectViewHeight)];
    selectView.delegate = self;
    selectView.backgroundColor = [UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1];
    [self.view addSubview:selectView];
}


#pragma mark - 遮盖层
- (void)creatBackgroundView {
    backgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundView.frame = CGRectMake(0, 64, kScreenW, kScreenH);
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.0f;
    [backgroundView addTarget:self action:@selector(clickBackgroundViewAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backgroundView];
}

- (void)clickBackgroundViewAction {
    [self controlBackgroundView:0];
}

- (void)controlBackgroundView:(float)alphaValue {
    [UIView animateWithDuration:0.2 animations:^{
        backgroundView.alpha = alphaValue;
        if (alphaValue <= 0) {
            [mySearchBar resignFirstResponder];
            [mySearchBar setShowsCancelButton:NO animated:YES];
        }
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 搜索框
- (void)customSearchBar{
    mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    mySearchBar.delegate = self;
    mySearchBar.placeholder = @"请输入商品名称";
    mySearchBar.tintColor = kMainDeepBlue;
    [mySearchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"SearchBarBackgroundColor"] forState:UIControlStateNormal];
    mySearchBar.backgroundColor = [UIColor clearColor];
    [mySearchBar setShowsCancelButton:NO];
    self.navigationItem.titleView = mySearchBar;
    
    for (UIView *view in [[mySearchBar.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)view;
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    [self.view bringSubviewToFront:backgroundView];
    [self controlBackgroundView:0.3];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    NSLog(@"%@",searchBar.text);
    
    self.page = 1;
    searchText = searchBar.text;
    
    if (searchText) {
        [self.postDic setObject:searchText forKey:@"keyword"];
    }
    if (self.page) {
        [self.postDic setObject:@(self.page) forKey:@"page"];
    }
    self.goodsArray = [NSMutableArray arrayWithCapacity:0];
    [HttpClient searchKoreaDesignWithDictionary:self.postDic WithBlock:^(NSDictionary *dictionary) {
        NSArray *array = dictionary[@"data"];
        for (NSDictionary *myDic in array) {
            SearchShopMarketModel *searchModel = [SearchShopMarketModel getSearchShopModelWithDictionary:myDic];
            [self.goodsArray addObject:searchModel];
        }
        [self.myCollectionView reloadData];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self controlBackgroundView:0];
    [self.view endEditing:YES];
}

- (void)creatCollectionView {
    //创建CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 4;
    layout.minimumInteritemSpacing = 4;
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 45, kScreenW, kScreenH - 45) collectionViewLayout:layout];
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.backgroundColor = kTableViewBackgroundColor;
    [self.view addSubview:self.myCollectionView];
    
    [self.myCollectionView registerClass:[MaterialShopCell class] forCellWithReuseIdentifier:materialCellIdentifier];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MaterialShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:materialCellIdentifier forIndexPath:indexPath];
    SearchShopMarketModel *myModel = self.goodsArray[indexPath.row];
    [cell reloadDataWithSearchShopMarketModel:myModel];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    [self removeSearchBar];
    ShoppingMallDetail_VC *materialShopVC = [[ShoppingMallDetail_VC alloc] init];
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

#pragma mark - ZGYMallSelectViewDelegate
- (void)selectView:(ZGYMallSelectView *)selectView moreSelectDic:(NSDictionary *)moreSelectDic {
    
    self.page = 1;
    self.postDic = [NSMutableDictionary dictionaryWithDictionary:moreSelectDic];
    
    [self.postDic setObject:@"design" forKey:@"market"];
    [self.postDic setObject:@"kr" forKey:@"country"];
    if (searchText) {
        [self.postDic setObject:searchText forKey:@"keyword"];
    }
    if (self.page) {
        [self.postDic setObject:@(self.page) forKey:@"page"];
    }
    
    NSLog(@"moreSelectDic = %@", self.postDic);
//    kTipAlert(@"moreSelectDic = %@", self.postDic);
    self.goodsArray = [NSMutableArray arrayWithCapacity:0];
    [HttpClient searchKoreaDesignWithDictionary:self.postDic WithBlock:^(NSDictionary *dictionary) {
        NSArray *array = dictionary[@"data"];
        for (NSDictionary *myDic in array) {
            SearchShopMarketModel *searchModel = [SearchShopMarketModel getSearchShopModelWithDictionary:myDic];
            [self.goodsArray addObject:searchModel];
        }
        [self.myCollectionView reloadData];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
