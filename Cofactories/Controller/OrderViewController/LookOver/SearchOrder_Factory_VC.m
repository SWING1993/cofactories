//
//  SearchOrder_Factory_VC.m
//  Cofactories
//
//  Created by GTF on 15/11/30.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "SearchOrder_Factory_VC.h"
#import "DOPDropDownMenu.h"
#import "Order_Factory_TVC.h"
#import "MJRefresh.h"
#import "FactoryOrderDetail_VC.h"
#import "OrderPhotoViewController.h"

@interface SearchOrder_Factory_VC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>{
    UITableView     *_tableView;
    DOPDropDownMenu *_dropDownMenu;
    NSArray         *_typeArray;
    NSArray         *_amountArray;
    NSArray         *_workingTimeArray;
    NSMutableArray  *_dataArray;
    int              _refrushCount;

}

@property (nonatomic,copy)NSString  *oderKeywordString;
@property (nonatomic,copy)NSString  *orderTypeString;
@property (nonatomic,strong)NSArray *orderAmountArray;
@property (nonatomic,strong)NSArray *orderDeadlineArray;

@end
static NSString *const reuseIdentifier = @"reuseIdentifier";

@implementation SearchOrder_Factory_VC

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    _typeArray = @[@"订单类型不限",@"加工厂",@"加工配套"];
    _amountArray = @[@"订单数量不限",@"小于500件",@"501-1000件",@"1001-2000件",@"2001-5000件",@"大于5001件"];
    _workingTimeArray = @[@"订单期限不限",@"1到3天",@"4到6天",@"7天以上"];
    _dropDownMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    _dropDownMenu.delegate = self;
    _dropDownMenu.dataSource = self;
    [self.view addSubview:_dropDownMenu];

    [self customSearchBar];
    [self initTableView];
    
    _dataArray = [@[] mutableCopy];
    [HttpClient searchFactoryOrderWithKeyword:nil type:nil amount:nil deadline:nil pageCount:@1 WithCompletionBlock:^(NSDictionary *dictionary){
        DLog(@"%@",dictionary);
        _dataArray = dictionary[@"message"];
        [_tableView reloadData];
    }];

    _refrushCount = 1;
    [self setupRefresh];

}

- (void)setupRefresh
{
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText = @"加载中...";
}

- (void)footerRereshing
{
    _refrushCount++;
    DLog(@"_refrushCount==%d",_refrushCount);
    [HttpClient searchFactoryOrderWithKeyword:_oderKeywordString type:_orderTypeString amount:_orderAmountArray deadline:_orderDeadlineArray pageCount:@(_refrushCount) WithCompletionBlock:^(NSDictionary *dictionary){
        NSArray *array = dictionary[@"message"];;
        
        for (int i=0; i<array.count; i++)
        {
            FactoryOrderMOdel *model = array[i];
            
            [_dataArray addObject:model];
        }
        [_tableView reloadData];

    }];
    [_tableView footerEndRefreshing];
}

#pragma mark - 关键字搜索
- (void)customSearchBar{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入搜索关键字";
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
    
    _oderKeywordString = searchBar.text;
    _orderTypeString = nil;
    _orderDeadlineArray = nil;
    _orderAmountArray = nil;
    _refrushCount = 1;

    [HttpClient searchFactoryOrderWithKeyword:_oderKeywordString type:_orderTypeString amount:_orderAmountArray deadline:_orderDeadlineArray pageCount:@1 WithCompletionBlock:^(NSDictionary *dictionary){
        DLog(@"%@",dictionary);
        _dataArray = dictionary[@"message"];
        [_tableView reloadData];
    }];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
}


#pragma mark - 表

- (void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+64, kScreenW, kScreenH-44-64) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = 100;
    [_tableView registerClass:[Order_Factory_TVC class] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Order_Factory_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    FactoryOrderMOdel *model = _dataArray[indexPath.row];
    [cell laoutWithDataModel:model];
    cell.imageButton.tag = indexPath.row+1;
    [cell.imageButton addTarget:self action:@selector(imageDetailClick:) forControlEvents:UIControlEventTouchUpInside];
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FactoryOrderMOdel *model = _dataArray[indexPath.row];
    
   
    FactoryOrderDetail_VC *vc = [FactoryOrderDetail_VC new];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"返回";
    backItem.tintColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [HttpClient getFactoryOrderDetailWithID:model.ID WithCompletionBlock:^(NSDictionary *dictionary) {
        FactoryOrderMOdel *dataModel = [FactoryOrderMOdel getSupplierOrderModelWithDictionary:dictionary];
        vc.dataModel = dataModel;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
}

- (void)imageDetailClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag-1;
    FactoryOrderMOdel *model = _dataArray[index];
    if (model.photoArray.count == 0) {
        kTipAlert(@"用户未上传图片");
    }else{
        OrderPhotoViewController *vc = [[OrderPhotoViewController alloc] initWithPhotoArray:model.photoArray];
        vc.titleString = @"订单图片";
        [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma mark - 选择器
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu{
    return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    switch (column) {
        case 0:
            return 3;
            break;
        case 1:
            return 6;
            break;
        case 2:
            return 4;
            break;
        default:
            break;
    }
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    switch (indexPath.column) {
        case 0:
            return _typeArray[indexPath.row];
            break;
        case 1:
            return _amountArray[indexPath.row];
            break;
        case 2:
            return _workingTimeArray[indexPath.row];
            break;
        default:
            break;
    }
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    DLog(@"%ld,%ld",(long)indexPath.column,(long)indexPath.row);
    switch (indexPath.column) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    _orderTypeString = nil;
                    break;
                case 1:
                    _orderTypeString = @"加工厂";
                    break;
                case 2:
                    _orderTypeString = @"其他";
                    break;

                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    _orderAmountArray = nil;
                    break;
                case 1:
                    _orderAmountArray = @[@"0",@"500"];
                    break;

                case 2:
                    _orderAmountArray = @[@"501",@"1000"];
                    break;

                case 3:
                    _orderAmountArray = @[@"1001",@"2000"];
                    break;
                case 4:
                    _orderAmountArray = @[@"2001",@"5000"];
                    break;
                case 5:
                    _orderAmountArray = @[@"5001",@"500000000"];
                    break;

                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    _orderDeadlineArray = nil;
                    break;
                case 1:
                    _orderDeadlineArray = @[@"1",@"3"];
                    break;
                case 2:
                    _orderDeadlineArray = @[@"4",@"6"];
                    break;
                case 3:
                    _orderDeadlineArray = @[@"7",@"88888888"];
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    DLog(@"%@,%@,%@",_orderTypeString,_orderAmountArray,_orderDeadlineArray);
    _oderKeywordString = nil;
    _refrushCount = 1;

    [HttpClient searchFactoryOrderWithKeyword:_oderKeywordString type:_orderTypeString amount:_orderAmountArray deadline:_orderDeadlineArray pageCount:@1 WithCompletionBlock:^(NSDictionary *dictionary){
        DLog(@"%@",dictionary);
        _dataArray = dictionary[@"message"];
        [_tableView reloadData];
    }];
    
}

- (void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
