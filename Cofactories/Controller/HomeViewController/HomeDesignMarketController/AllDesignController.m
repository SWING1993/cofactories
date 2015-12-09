//
//  AllDesignController.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/2.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "AllDesignController.h"
#import "AllDesignCell.h"
#import "DOPDropDownMenu.h"
#import "MJRefresh.h"
#import "PersonalMessage_Design_VC.h"

@interface AllDesignController ()<UITableViewDataSource,UITableViewDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UISearchBarDelegate>{
    NSDictionary    *_selectDataDictionary;
    DOPDropDownMenu *_dropDownMenu;
    UITableView     *_tableView;
    NSArray         *_zhejiangArray;
    NSArray         *_anhuiArray;
    NSArray         *_guangdongArray;
    NSMutableArray  *_dataArray;
    NSInteger        _refrushCount;
}

@property (nonatomic,copy)NSString *userType;
@property (nonatomic,copy)NSString *userSubrole;
@property (nonatomic,copy)NSString *userBusinessName;
@property (nonatomic,copy)NSString *userProvince;
@property (nonatomic,copy)NSString *userCity;
@end
static NSString *const reuseIdentifier = @"reuseIdentifier";
@implementation AllDesignController

- (id)initWithSelecteDataDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        _selectDataDictionary = dictionary;
        [self customSearchBar];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _zhejiangArray = @[@"浙江不限",@"湖州(含织里)",@"杭州",@"宁波",@"浙江其他"];
    _anhuiArray = @[@"安徽不限",@"宣城(含广德)",@"安徽其他"];
    _guangdongArray = @[@"广东不限",@"广州(含新塘)",@"广东其他"];
    _dropDownMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    _dropDownMenu.delegate = self;
    _dropDownMenu.dataSource = self;
    [self.view addSubview:_dropDownMenu];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+64, kScreenW, kScreenH-44-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = 80;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[AllDesignCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_tableView];
    
    
    _dataArray = [@[] mutableCopy];
    _refrushCount = 1;
    [self setupRefresh];
    [HttpClient searchBusinessWithRole:@"designer" scale:nil province:nil city:nil subRole:nil keyWord:nil verified:nil page:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
        DLog(@"==%@",dictionary);
        NSArray *array = dictionary[@"message"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            Business_Supplier_Model *model = [Business_Supplier_Model getBusinessSupplierModelWithDictionary:dic];
            [_dataArray addObject:model];
        }];
        [_tableView reloadData];
        
    }];

}

- (void)setupRefresh{
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText = @"加载中...";
}

- (void)footerRereshing{
    _refrushCount++;
    DLog(@"_refrushCount==%d",_refrushCount);
    [HttpClient searchBusinessWithRole:@"designer" scale:nil province:_userProvince city:_userCity subRole:_userSubrole keyWord:_userBusinessName verified:_userType page:@(_refrushCount) WithCompletionBlock:^(NSDictionary *dictionary) {
        NSArray *array = dictionary[@"message"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            Business_Supplier_Model *model = [Business_Supplier_Model getBusinessSupplierModelWithDictionary:dic];
            [_dataArray addObject:model];
        }];
        [_tableView reloadData];
        
    }];
    [_tableView footerEndRefreshing];
    
}



#pragma mark - 搜索框
- (void)customSearchBar{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入店铺名称";
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
    
    _refrushCount = 1;
    _userBusinessName = searchBar.text;
    _userCity = nil;
    _userProvince = nil;
    _userType = nil;
    _userSubrole = nil;
    
    DLog(@"==%@,==%@,==%@,==%@",_userProvince,_userCity,_userBusinessName,_userType);
    [HttpClient searchBusinessWithRole:@"clothing" scale:nil province:_userProvince city:_userCity subRole:_userSubrole keyWord:_userBusinessName verified:_userType page:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
        [_dataArray removeAllObjects];
        NSArray *array = dictionary[@"message"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            Business_Supplier_Model *model = [Business_Supplier_Model getBusinessSupplierModelWithDictionary:dic];
            [_dataArray addObject:model];
        }];
        [_tableView reloadData];
        
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
                    _userType = @"enterprise";
                    break;
                case 2:
                    _userType = @"verified";
                    break;
                case 3:
                    _userType = @"register";
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    _userSubrole = nil;
                    break;
                case 1:
                    _userSubrole = @"个人设计者";
                    break;
                case 2:
                    _userSubrole = @"设计工作室";
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
    
    _refrushCount = 1;
    _userBusinessName = nil;
    
    DLog(@"==%@,==%@,==%@,==%@,==%@",_userProvince,_userCity,_userBusinessName,_userType,_userSubrole);
    [HttpClient searchBusinessWithRole:@"designer" scale:nil province:_userProvince city:_userCity subRole:_userSubrole keyWord:_userBusinessName verified:_userType page:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
        [_dataArray removeAllObjects];
        NSArray *array = dictionary[@"message"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            Business_Supplier_Model *model = [Business_Supplier_Model getBusinessSupplierModelWithDictionary:dic];
            [_dataArray addObject:model];
        }];
        [_tableView reloadData];
        
    }];
    
}

#pragma mark - 表方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AllDesignCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    Business_Supplier_Model *model = _dataArray[indexPath.row];
    [cell layoutDataWith:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Business_Supplier_Model *model = _dataArray[indexPath.row];
    PersonalMessage_Design_VC *vc = [PersonalMessage_Design_VC new];
    vc.userID = model.businessUid;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
