//
//  OrderList_Supplier_VC.m
//  Cofactories
//
//  Created by GTF on 16/3/8.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "OrderList_Supplier_VC.h"
#import "OrderList_Supplier_TVC.h"
#import "SupplierOrderModel.h"
#import "MJRefresh.h"
#import "SupplierOrderDetail_VC.h"

@interface OrderList_Supplier_VC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic,strong) UITableView    *tableView;
@property (nonatomic,strong) NSMutableArray *buttonArray;
@property (nonatomic,strong) UILabel        *lineLB;
@property (nonatomic,strong) UIButton       *scrollTopBtn;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int            refrushCount;
@property (nonatomic,copy  ) NSString       *oderKeywordString;
@property (nonatomic,copy  ) NSString       *oderTypeString;

@end

static NSString *const reuseIdentifier = @"reuseIdentifier";
@implementation OrderList_Supplier_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    _refrushCount = 1;
    _buttonArray  = [@[] mutableCopy];
    _dataArray    = [@[] mutableCopy];
    [self setupSearchBar];
    [self setupTableView];
    [self setupTableHeader];
    [self requestDataWithKeyStr:nil typeStr:nil pageCount:@1];
    [self setupRefresh];
}

- (void)setupTableView{
    _tableView            = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) style:UITableViewStyleGrouped];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _tableView.rowHeight  = 100;
    [_tableView registerClass:[OrderList_Supplier_TVC class] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_tableView];
}

- (void)setupTableHeader{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    
    NSArray *array = @[@"不限",@"面料",@"辅料",@"机械设备"];
    for (int i = 0; i<array.count; i++) {
        UIButton *button       = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame           = CGRectMake(i*(kScreenW/4.f), 0, kScreenW/4.f, 35);
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.tag             = i+1;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
        if (i==0) {
            [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            [_buttonArray removeAllObjects];
            [_buttonArray addObject:button];
        }else{
            [button setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        }
    }
    
    _lineLB                        = [UILabel new];
    _lineLB.backgroundColor        = MAIN_COLOR;
    _lineLB.frame                  = CGRectMake(0, 38, kScreenW/4.f, 2);
    [headerView addSubview:_lineLB];

    self.tableView.tableHeaderView = headerView;
}

#pragma mark - refrush
- (void)setupRefresh{
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText = @"加载中...";
}

- (void)footerRereshing{
    _refrushCount++;
    DLog(@"_refrushCount==%d",_refrushCount);
    [HttpClient searchSupplierOrderWithKeyword:_oderKeywordString type:_oderTypeString pageCount:@(_refrushCount) WithCompletionBlock:^(NSDictionary *dictionary){
        NSArray *array = dictionary[@"message"];;
        
        for (int i=0; i<array.count; i++){
            SupplierOrderModel *model = array[i];
            
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
    }];
    [_tableView footerEndRefreshing];
}


#pragma mark - 关键字搜索
- (void)setupSearchBar{
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
    
    [self requestDataWithKeyStr:_oderKeywordString typeStr:_oderTypeString pageCount:@1];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderList_Supplier_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.orderModel = _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SupplierOrderModel *model = _dataArray[indexPath.row];
    
    SupplierOrderDetail_VC *vc = [SupplierOrderDetail_VC new];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"返回";
    backItem.tintColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    
    [HttpClient getSupplierOrderDetailWithID:model.ID WithCompletionBlock:^(NSDictionary *dictionary) {
        SupplierOrderModel *dataModel = [SupplierOrderModel getSupplierOrderModelWithDictionary:dictionary];
        vc.dataModel = dataModel;
        vc.supplierOrderDetailBidStatus = SupplierOrderDetailBidStatus_Common;
        [HttpClient getOtherIndevidualsInformationWithUserID:dataModel.userUid WithCompletionBlock:^(NSDictionary *dictionary) {
            OthersUserModel *model = dictionary[@"message"];
            vc.otherUserModel = model;
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    DLog(@">>>>>>>>>>>+=====------%@",NSStringFromCGPoint(_tableView.contentOffset));
    
    if (_tableView.contentOffset.y < 500) {
        [self isShowTopView:NO];
    }else if (_tableView.contentOffset.y > 1500) {
        [self isShowTopView:YES];
    }
    
}
#pragma mark - private

- (void)typeClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    UIButton *lastButton = _buttonArray[0] ;
    [lastButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    
    [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [_buttonArray removeAllObjects];
    [_buttonArray addObject:button];
    
    [UIView animateWithDuration:0.2f animations:^{
        _lineLB.frame = CGRectMake((button.tag-1)*kScreenW/4.f, 38, kScreenW/4.f, 2);
    }];
    
    DLog(@"---------%ld------%@------",(long)button.tag,NSStringFromCGRect(_lineLB.frame));
    _refrushCount = 1;
    _oderKeywordString = nil;
    
    switch (button.tag) {
        case 1:
            _oderTypeString = nil;
            break;
            
        case 2:
            _oderTypeString = @"fabric";
            break;
            
        case 3:
            _oderTypeString = @"accessory";
               break;
            
        case 4:
            _oderTypeString = @"machine";
            break;
            
        default:
            break;
    }

    [self requestDataWithKeyStr:_oderKeywordString typeStr:_oderTypeString pageCount:@1];
}

- (void)isShowTopView:(BOOL)isShow{
    if (isShow) {
        if (!_scrollTopBtn) {
            _scrollTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _scrollTopBtn.frame = CGRectMake(kScreenW-60,
                                            kScreenH-80,
                                            40,
                                            40);
            [_scrollTopBtn setBackgroundImage:[UIImage imageNamed:@"zhiding"] forState:UIControlStateNormal];
            [_scrollTopBtn addTarget:self action:@selector(scrollToTopClick) forControlEvents:UIControlEventTouchUpInside];
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:_scrollTopBtn];
        }
    }else{
        [_scrollTopBtn removeFromSuperview];
        _scrollTopBtn = nil;
    }
}

- (void)scrollToTopClick{
    [self isShowTopView:NO];
    _tableView.contentOffset = CGPointMake(0, 0);
}

- (void)requestDataWithKeyStr:(NSString *)keyStr typeStr:(NSString *)typeStr pageCount:(NSNumber *)pageCount{
    [HttpClient searchSupplierOrderWithKeyword:keyStr type:typeStr pageCount:pageCount WithCompletionBlock:^(NSDictionary *dictionary) {
        _dataArray = dictionary[@"message"];
        [_tableView reloadData];
    }];
}

- (void)goBack{
    [self dismissViewControllerAnimated:NO completion:^{
        [self isShowTopView:NO];
    }];
}
@end
