//
//  DesignShop_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/14.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "DesignShop_VC.h"
#import "DOPDropDownMenu.h"
#import "MaterialShopCell.h"
#import "ShoppingMallDetail_VC.h"
#import "SVPullToRefresh.h"
#import "SearchShopMarketModel.h"

static NSString *materialCellIdentifier = @"materialCell";

@interface DesignShop_VC ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    NSString        *_subrole;
    NSDictionary    *_selectDataDictionary;
    DOPDropDownMenu *_dropDownMenu;
    NSArray         *_maleArray, *_femaleArray, *_boyArray, *_girlArray;
    NSArray         *_zhejiangArray;
    NSArray         *_anhuiArray;
    NSArray         *_guangdongArray;
    UISearchBar     *mySearchBar;
    UIButton        *backgroundView;
    
}
@property (nonatomic,copy)NSString *userType;
@property (nonatomic,copy)NSString *userPart;
@property (nonatomic,copy)NSString *userPrice;
@property (nonatomic,copy)NSString *userProvince;
@property (nonatomic,copy)NSString *userCity;

@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic,copy) NSString *userBusinessName;

@end

@implementation DesignShop_VC

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self controlBackgroundView:0];
}

- (id)initWithSubrole:(NSString *)subrole andSelecteDataDictionary:(NSDictionary *)dictionary{
    
    if (self = [super init]) {
        _subrole = subrole;
        _selectDataDictionary = dictionary;
        [self customSearchBar];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatCollectionView];

    _zhejiangArray = @[@"浙江不限",@"湖州(含织里)",@"杭州",@"宁波",@"浙江其他"];
    _anhuiArray = @[@"安徽不限",@"宣城(含广德)",@"安徽其他"];
    _guangdongArray = @[@"广东不限",@"广州(含新塘)",@"广东其他"];
    
    _maleArray = @[@"男装不限", @"上衣", @"下衣", @"套装"];
    _femaleArray = @[@"女装不限", @"上衣", @"下衣", @"套装"];
    _boyArray = @[@"男童不限", @"上衣", @"下衣", @"套装"];
    _girlArray = @[@"女童不限", @"上衣", @"下衣", @"套装"];
    
    _dropDownMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    _dropDownMenu.delegate = self;
    _dropDownMenu.dataSource = self;
    [self.view addSubview:_dropDownMenu];
    self.page = 1;
    //上拉加载更多数据
    __weak typeof(self) weakSelf = self;
    [self.myCollectionView addInfiniteScrollingWithActionHandler:^{
        weakSelf.page++;
        DLog(@"^^^^^^^^^^^^^^^^^^^^^^^");
        [HttpClient searchDesignWithMarket:@"design" type:weakSelf.userType part:weakSelf.userPart price:nil priceOrder:weakSelf.userPrice keyword:nil province:weakSelf.userProvince  city:weakSelf.userCity country:nil aCreatedAt:nil page:@(weakSelf.page) WithCompletionBlock:^(NSDictionary *dictionary) {
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickBackgroundViewAction) name:UIKeyboardWillHideNotification object:nil];
    
    [self creatBackgroundView];
}
- (void)netWork {
    self.goodsArray = [NSMutableArray arrayWithCapacity:0];
    
    [HttpClient searchDesignWithMarket:@"design" type:nil part:nil price:nil priceOrder:nil keyword:nil province:nil city:nil country:nil aCreatedAt:nil page:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
        NSArray *array = dictionary[@"message"];
        for (NSDictionary *myDic in array) {
            SearchShopMarketModel *searchModel = [SearchShopMarketModel getSearchShopModelWithDictionary:myDic];
            [self.goodsArray addObject:searchModel];
        }
        [self.myCollectionView reloadData];

    }];
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

- (void) clickBackgroundViewAction {
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
    //把backgroundView提到最前面，遮挡筛选器
    [self.view bringSubviewToFront:backgroundView];
    [self controlBackgroundView:0.3];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self controlBackgroundView:0];
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    NSLog(@"%@",searchBar.text);
    
    self.page = 1;
    _userBusinessName = searchBar.text;
    _userCity = nil;
    _userProvince = nil;
    _userType = nil;
    
    DLog(@"==%@,==%@,==%@,==%@",_userProvince,_userCity,_userBusinessName,_userType);
    self.goodsArray = [NSMutableArray arrayWithCapacity:0];
    
    [HttpClient searchDesignWithMarket:@"design" type:_userType part:_userPart price:nil priceOrder:_userPrice keyword:_userBusinessName province:_userProvince city:_userCity country:nil aCreatedAt:nil page:@(self.page) WithCompletionBlock:^(NSDictionary *dictionary) {
        NSArray *array = dictionary[@"message"];
        for (NSDictionary *myDic in array) {
            SearchShopMarketModel *searchModel = [SearchShopMarketModel getSearchShopModelWithDictionary:myDic];
            [self.goodsArray addObject:searchModel];
        }
        [self controlBackgroundView:0];
        [self.myCollectionView reloadData];
        
    }];
    
}


#pragma mark - 选择器方法
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu{
    return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    switch (column) {
        case 0:
            return [(NSArray *)_selectDataDictionary[@"accountType"] count];
            break;
        case 1:
            return [(NSArray *)_selectDataDictionary[@"scale"] count];
            break;
        case 2:
            return [(NSArray *)_selectDataDictionary[@"area"] count];
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    switch (indexPath.column) {
        case 0:
            return _selectDataDictionary[@"accountType"][indexPath.row];
            break;
        case 1:
            return _selectDataDictionary[@"scale"][indexPath.row];
            break;
        case 2:
            return _selectDataDictionary[@"area"][indexPath.row];
            break;
            
        default:
            break;
    }
    return nil;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column{
    if (column == 0) {
        switch (row) {
                case 0:
                return 0;
                break;
            case 1:
                return _maleArray.count;
                break;
            case 2:
                return _femaleArray.count;
                break;
            case 3:
                return _boyArray.count;
                break;
            case 4:
                return _girlArray.count;
                break;
            default:
                break;
        }
    } else if (column == 2) {
        switch (row) {
            case 0:
                return 0;
                break;
            case 1:
                return _zhejiangArray.count;
                break;
                
            case 2:
                return _anhuiArray.count;
                break;
            case 3:
                return _guangdongArray.count;
                break;
                
            default:
                break;
        }
    }
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath{
    if (indexPath.column == 0) {
        switch (indexPath.row) {
            case 1:
                return _maleArray[indexPath.item];
                break;
            case 2:
                return _femaleArray[indexPath.item];
                break;
            case 3:
                return _boyArray[indexPath.item];
                break;
            case 4:
                return _girlArray[indexPath.item];
                break;
            default:
                break;
        }

    } else if (indexPath.column == 2) {
        switch (indexPath.row) {
            case 1:
                return _zhejiangArray[indexPath.item];
                break;
                
            case 2:
                return _anhuiArray[indexPath.item];
                break;
            case 3:
                return _guangdongArray[indexPath.item];
                break;
                
            default:
                break;
        }
    }
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    NSLog(@"==%ld,==%ld,==%ld",(long)indexPath.column,(long)indexPath.row,(long)indexPath.item);
    
    switch (indexPath.column) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    _userType = nil;
                    _userPart = nil;
                    break;
                case 1:
                    _userType = @"male";
                    switch (indexPath.item) {
                        case 0:
                            _userPart = nil;
                            break;
                        case 1:
                            _userPart = @"top";
                            break;
                        case 2:
                            _userPart = @"bottom";
                            break;
                        case 3:
                            _userPart = @"suit";
                            break;
                        default:
                            break;
                    }
                    break;
                case 2:
                    _userType = @"female";
                    switch (indexPath.item) {
                        case 0:
                            _userPart = nil;
                            break;
                        case 1:
                            _userPart = @"top";
                            break;
                        case 2:
                            _userPart = @"bottom";
                            break;
                        case 3:
                            _userPart = @"suit";
                            break;
                        default:
                            break;
                    }
                    break;
                case 3:
                    _userType = @"boy";
                    switch (indexPath.item) {
                        case 0:
                            _userPart = nil;
                            break;
                        case 1:
                            _userPart = @"top";
                            break;
                        case 2:
                            _userPart = @"bottom";
                            break;
                        case 3:
                            _userPart = @"suit";
                            break;
                        default:
                            break;
                    }
                    break;
                case 4:
                    _userType = @"girl";
                    switch (indexPath.item) {
                        case 0:
                            _userPart = nil;
                            break;
                        case 1:
                            _userPart = @"top";
                            break;
                        case 2:
                            _userPart = @"bottom";
                            break;
                        case 3:
                            _userPart = @"suit";
                            break;
                        default:
                            break;
                    }
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    _userPrice = nil;
                    break;
                case 1:
                    _userPrice = @"asc";
                    break;
                case 2:
                    _userPrice = @"desc";
                    break;
                default:
                    break;
            }
            
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    _userProvince = @"";
                    _userCity = @"";
                    break;
                case 1:
                    _userProvince = @"浙江省";
                    _userCity = @"";
                    switch (indexPath.item) {
                        case 0:
                            _userCity = @"";
                            break;
                        case 1:
                            _userCity = @"湖州市";
                            break;
                        case 2:
                            _userCity = @"杭州市";
                            break;
                        case 3:
                            _userCity = @"宁波市";
                            break;
                        case 4:
                            _userCity = @"其他";
                            break;
                        default:
                            break;
                    }
                    break;
                case 2:
                    _userProvince = @"安徽省";
                    _userCity = @"";
                    switch (indexPath.item) {
                        case 0:
                            _userCity = @"";
                            break;
                        case 1:
                            _userCity = @"宣城市";
                            break;
                        case 2:
                            _userCity = @"其他";///////////////////////////
                            break;
                        default:
                            break;
                    }
                    
                    break;
                case 3:
                    _userProvince = @"广东省";
                    _userCity = @"";
                    switch (indexPath.item) {
                        case 0:
                            _userCity = @"";
                            break;
                        case 1:
                            _userCity = @"广州市";
                            break;
                        case 2:
                            _userCity = @"其他";/////////////////////////////
                            break;
                        default:
                            break;
                    }
                    break;
                case 4:
                    _userProvince = @"福建省";
                    _userCity = @"";
                    break;
                case 5:
                    _userProvince = @"江苏省";
                    _userCity = @"";
                    break;
                case 6:
                    _userProvince = @"其他";///////////////////////////
                    _userCity = @"";
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    self.page = 1;
    DLog(@"==%@,==%@,==%@,==%@,==%@",_userType, _userPart, _userPrice,_userProvince,_userCity);
    self.goodsArray = [NSMutableArray arrayWithCapacity:0];
    
    [HttpClient searchDesignWithMarket:@"design" type:_userType part:_userPart price:nil priceOrder:_userPrice keyword:nil province:_userProvince city:_userCity country:nil aCreatedAt:nil page:@(self.page) WithCompletionBlock:^(NSDictionary *dictionary) {
        NSArray *array = dictionary[@"message"];
        for (NSDictionary *myDic in array) {
            SearchShopMarketModel *searchModel = [SearchShopMarketModel getSearchShopModelWithDictionary:myDic];
            [self.goodsArray addObject:searchModel];
        }
        [self.myCollectionView reloadData];
    }];
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
    ShoppingMallDetail_VC *shoppingMallVC = [[ShoppingMallDetail_VC alloc] init];
    SearchShopMarketModel *myModel = self.goodsArray[indexPath.row];
    shoppingMallVC.shopID = myModel.ID;
    [self.navigationController pushViewController:shoppingMallVC animated:YES];
    
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
