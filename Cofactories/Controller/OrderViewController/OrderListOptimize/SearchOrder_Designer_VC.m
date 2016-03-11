//
//  SearchOrder_Designer_VC.m
//  Cofactories
//
//  Created by GTF on 15/11/30.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "SearchOrder_Designer_VC.h"
#import "Order_Designer_TVC.h"
#import "MJRefresh.h"
#import "DesignOrderDetail_VC.h"

@interface SearchOrder_Designer_VC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    UITableView     *_tableView;
    NSMutableArray  *_dataArray;
    int              _refrushCount;

}
@property (nonatomic,copy)NSString  *oderKeywordString;
@end
static NSString *const reuseIdentifier = @"reuseIdentifier";

@implementation SearchOrder_Designer_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    _dataArray = [@[] mutableCopy];
    [HttpClient searchDesignOrderWithKeyword:nil pageCount:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
        DLog(@"%@",dictionary);
        _dataArray = dictionary[@"message"];
        [_tableView reloadData];

    }];;
    
    [self customSearchBar];
    [self initTable];
    
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
    [HttpClient searchDesignOrderWithKeyword:_oderKeywordString pageCount:@(_refrushCount) WithCompletionBlock:^(NSDictionary *dictionary){
        NSArray *array = dictionary[@"message"];;
        
        for (int i=0; i<array.count; i++)
        {
            DesignOrderModel *model = array[i];
            
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
        
    }];
    [_tableView footerEndRefreshing];
}


#pragma mark - 搜索框

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
    [HttpClient searchDesignOrderWithKeyword:_oderKeywordString pageCount:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
        DLog(@"%@",dictionary);
        _dataArray = dictionary[@"message"];
        [_tableView reloadData];
        
    }];;
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark - 表
- (void)initTable{
    _tableView = [[UITableView alloc] initWithFrame:kScreenBounds style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = 150;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[Order_Designer_TVC class] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Order_Designer_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    DesignOrderModel *model = _dataArray[indexPath.row];
    [cell laoutWithDataModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DesignOrderModel *model = _dataArray[indexPath.row];
    
    DesignOrderDetail_VC *vc = [DesignOrderDetail_VC new];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"返回";
    backItem.tintColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [HttpClient getDesignOrderDetailWithID:model.ID WithCompletionBlock:^(NSDictionary *dictionary) {
        DesignOrderModel *dataModel = [DesignOrderModel getDesignOrderModelWithDictionary:dictionary];
        vc.dataModel = dataModel;
        vc.designOrderDetailBidStatus = DesignOrderDetailBidStatus_Common;
        [HttpClient getOtherIndevidualsInformationWithUserID:dataModel.userUid WithCompletionBlock:^(NSDictionary *dictionary) {
            OthersUserModel *model = dictionary[@"message"];
            vc.otherUserModel = model;
            [self.navigationController pushViewController:vc animated:YES];
            
        }];
    }];
    
}

- (void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
