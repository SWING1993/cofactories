//
//  SearchOrder_VC.m
//  Cofactories
//
//  Created by GTF on 15/11/28.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "SearchOrder_Supplier_VC.h"
#import "Order_Supplier_TVC.h"
#import "OrderPhotoViewController.h"
#import "SupplierOrderDetail_VC.h"
#import "MJRefresh.h"

@interface SearchOrder_Supplier_VC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    UITableView     *_tableView;
    UILabel         *_lineLB;
    NSMutableArray  *_buttonArray;
    NSMutableArray  *_dataArray;
    int              _refrushCount;

}
@property (nonatomic,copy)NSString  *oderKeywordString;
@property (nonatomic,copy)NSString  *oderTypeString;

@end
static NSString *const reuseIdentifier = @"reuseIdentifier";

@implementation SearchOrder_Supplier_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    _buttonArray = [@[] mutableCopy];
    _dataArray = [@[] mutableCopy];
    [HttpClient searchSupplierOrderWithKeyword:nil type:nil pageCount:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
        DLog(@"%@",dictionary);
        _dataArray = dictionary[@"message"];
        [_tableView reloadData];

    }];
    [self initSelectView];
    [self customSearchBar];
    [self initTableView];
    
    _refrushCount = 1;
    [self setupRefresh];
}

- (void)initSelectView{
    NSArray *array = @[@"不限",@"面料",@"辅料",@"机械设备"];
    for (int i = 0; i<4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*(kScreenW/4.f), 64, kScreenW/4.f, 42);
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.tag = i+1;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        if (i==0) {
            [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            [_buttonArray removeAllObjects];
            [_buttonArray addObject:button];
        }else{
            [button setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        }
    }
    
    _lineLB = [UILabel new];
    _lineLB.backgroundColor = MAIN_COLOR;
    _lineLB.frame = CGRectMake(0, 42+64, kScreenW/4.f, 2);
    [self.view addSubview:_lineLB];
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
    [HttpClient searchSupplierOrderWithKeyword:_oderKeywordString type:_oderTypeString pageCount:@(_refrushCount) WithCompletionBlock:^(NSDictionary *dictionary){
        NSArray *array = dictionary[@"message"];;
        
        for (int i=0; i<array.count; i++)
        {
            SupplierOrderModel *model = array[i];
            
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
    _refrushCount = 1;
    _oderTypeString = nil;
    
    [HttpClient searchSupplierOrderWithKeyword:_oderKeywordString type:_oderTypeString pageCount:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+44, kScreenW, kScreenH-64-44) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = 100;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[Order_Supplier_TVC class] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Order_Supplier_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    SupplierOrderModel *model = _dataArray[indexPath.row];
    [cell laoutWithDataModel:model];
    cell.imageButton.tag = indexPath.row+1;
    [cell.imageButton addTarget:self action:@selector(imageDetailClick:) forControlEvents:UIControlEventTouchUpInside];

    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SupplierOrderModel *model = _dataArray[indexPath.row];
    
    SupplierOrderDetail_VC *vc = [SupplierOrderDetail_VC new];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"返回";
    backItem.tintColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [HttpClient getSupplierOrderDetailWithID:model.ID WithCompletionBlock:^(NSDictionary *dictionary) {
        SupplierOrderModel *dataModel = [SupplierOrderModel getSupplierOrderModelWithDictionary:dictionary];
        vc.dataModel = dataModel;
        
        [HttpClient getOtherIndevidualsInformationWithUserID:dataModel.userUid WithCompletionBlock:^(NSDictionary *dictionary) {
            OthersUserModel *model = dictionary[@"message"];
            vc.otherUserModel = model;
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
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

- (void)typeClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    UIButton *lastButton = _buttonArray[0] ;
    [lastButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    
    [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [_buttonArray removeAllObjects];
    [_buttonArray addObject:button];
    
    [UIView animateWithDuration:0.2f animations:^{
        _lineLB.frame = CGRectMake(button.frame.origin.x, 42+64, kScreenW/4.f, 2);
    }];
    
    
    _refrushCount = 1;
    _oderKeywordString = nil;
    switch (button.tag) {
        case 1:
        {
            _oderTypeString = nil;
            [HttpClient searchSupplierOrderWithKeyword:_oderKeywordString type:_oderTypeString pageCount:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
                DLog(@"%@",dictionary);
                _dataArray = dictionary[@"message"];
                [_tableView reloadData];
            }];

        }
            break;
            
        case 2:
        {
            _oderTypeString = @"fabric";
            [HttpClient searchSupplierOrderWithKeyword:_oderKeywordString type:_oderTypeString pageCount:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
                DLog(@"%@",dictionary);
                _dataArray = dictionary[@"message"];
                [_tableView reloadData];
            }];

        }
            break;
            
        case 3:
        {
            _oderTypeString = @"accessory";
            [HttpClient searchSupplierOrderWithKeyword:_oderKeywordString type:_oderTypeString pageCount:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
                DLog(@"%@",dictionary);
                _dataArray = dictionary[@"message"];
                [_tableView reloadData];
            }];

        }
            break;
            
        case 4:
        {
            _oderTypeString = @"machine";
            [HttpClient searchSupplierOrderWithKeyword:_oderKeywordString type:_oderTypeString pageCount:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
                DLog(@"%@",dictionary);
                _dataArray = dictionary[@"message"];
                [_tableView reloadData];
            }];

            
        }
            
            break;
        default:
            break;
    }
}

- (void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
