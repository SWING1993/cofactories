//
//  MachineShop_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/12.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MachineShop_VC.h"
#import "DOPDropDownMenu.h"

@interface MachineShop_VC ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UISearchBarDelegate>{
    NSString        *_subrole;
    NSDictionary    *_selectDataDictionary;
    DOPDropDownMenu *_dropDownMenu;
    NSArray         *_zhejiangArray;
    NSArray         *_anhuiArray;
    NSArray         *_guangdongArray;
    NSMutableArray  *_dataArray;
    NSInteger        _refrushCount;
}
@property (nonatomic,copy)NSString *userType;
@property (nonatomic,copy)NSString *userPrice;
@property (nonatomic,copy)NSString *userProvince;
@property (nonatomic,copy)NSString *userCity;

@end

@implementation MachineShop_VC

- (id)initWithSubrole:(NSString *)subrole andSelecteDataDictionary:(NSDictionary *)dictionary{
    
    if (self = [super init]) {
        _subrole = subrole;
        _selectDataDictionary = dictionary;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _zhejiangArray = @[@"浙江不限",@"湖州(含织里)",@"杭州",@"宁波",@"浙江其他"];
    _anhuiArray = @[@"安徽不限",@"宣城(含广德)",@"安徽其他"];
    _guangdongArray = @[@"广东不限",@"广州(含新塘)",@"广东其他"];
    _dropDownMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    _dropDownMenu.delegate = self;
    _dropDownMenu.dataSource = self;
    [self.view addSubview:_dropDownMenu];
    
    
    
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
                    _userType = @"machine";
                    break;
                case 2:
                    _userType = @"part";
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
    
    _refrushCount = 1;
    DLog(@"==%@,==%@,==%@,==%@",_userType,_userPrice,_userProvince,_userCity);
    //    [HttpClient searchBusinessWithRole:@"supplier" scale:nil province:_userProvince city:_userCity subRole:_subrole keyWord:_userBusinessName verified:_userType page:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
    //        [_dataArray removeAllObjects];
    //        NSArray *array = dictionary[@"message"];
    //        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            NSDictionary *dic = obj;
    //            Business_Supplier_Model *model = [Business_Supplier_Model getBusinessSupplierModelWithDictionary:dic];
    //            [_dataArray addObject:model];
    //        }];
    //        [_tableView reloadData];
    //        
    //    }];
    
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
