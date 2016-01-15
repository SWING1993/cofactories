//
//  FabricShop_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/12.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "FabricShop_VC.h"
#import "DOPDropDownMenu.h"
#import "MaterialShopCell.h"
#import "materialShopDetailController.h"
#import "SVPullToRefresh.h"
#import "SearchShopMarketModel.h"

static NSString *materialCellIdentifier = @"materialCell";
@interface FabricShop_VC ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    NSString        *_subrole;
    NSDictionary    *_selectDataDictionary;
    DOPDropDownMenu *_dropDownMenu;
    NSArray         *_zhejiangArray;
    NSArray         *_anhuiArray;
    NSArray         *_guangdongArray;
    
}
@property (nonatomic,copy)NSString *userType;
@property (nonatomic,copy)NSString *userPrice;
@property (nonatomic,copy)NSString *userProvince;
@property (nonatomic,copy)NSString *userCity;

@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic)NSInteger page;
@property (nonatomic,copy)NSString *userBusinessName;


@end

@implementation FabricShop_VC


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
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"back"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    [self creatCollectionView];
    
    _zhejiangArray = @[@"浙江不限",@"湖州(含织里)",@"杭州",@"宁波",@"浙江其他"];
    _anhuiArray = @[@"安徽不限",@"宣城(含广德)",@"安徽其他"];
    _guangdongArray = @[@"广东不限",@"广州(含新塘)",@"广东其他"];
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
        [HttpClient searchFabricWithMarket:@"fabric" type:weakSelf.userType price:nil priceOrder:weakSelf.userPrice keyword:nil province:weakSelf.userProvince city:weakSelf.userCity page:@(weakSelf.page) WithCompletionBlock:^(NSDictionary *dictionary) {
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

- (void)netWork {
    self.goodsArray = [NSMutableArray arrayWithCapacity:0];
    [HttpClient searchFabricWithMarket:@"fabric" type:nil price:nil priceOrder:nil keyword:nil province:nil city:nil page:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
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
    searchBar.tintColor = kDeepBlue;
    [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"SearchBarBackgroundColor"] forState:UIControlStateNormal];
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
    
    self.page = 1;
    _userBusinessName = searchBar.text;
    _userCity = nil;
    _userProvince = nil;
    _userType = nil;
    
    DLog(@"==%@,==%@,==%@,==%@",_userProvince,_userCity,_userBusinessName,_userType);
    [HttpClient searchFabricWithMarket:@"fabric" type:self.userType price:nil priceOrder:self.userPrice keyword:_userBusinessName province:self.userProvince city:self.userCity page:@(self.page) WithCompletionBlock:^(NSDictionary *dictionary) {
        [self.goodsArray removeAllObjects];
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
    
    if (column == 2) {
        switch (row) {
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
    if (indexPath.column == 2) {
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
                    break;
                case 1:
                    _userType = @"knit";
                    break;
                case 2:
                    _userType = @"woven";
                    break;
                case 3:
                    _userType = @"special";
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
    DLog(@"==%@,==%@,==%@,==%@",_userType,_userPrice,_userProvince,_userCity);
    self.goodsArray = [NSMutableArray arrayWithCapacity:0];
    [HttpClient searchFabricWithMarket:@"fabric" type:self.userType price:nil priceOrder:self.userPrice keyword:self.userBusinessName province:self.userProvince city:self.userCity page:@(self.page) WithCompletionBlock:^(NSDictionary *dictionary) {
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
    self.myCollectionView.backgroundColor = kBackgroundColor;
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

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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
