//
//  MeHistoryBuy_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/17.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "MeHistoryBuy_VC.h"
#import "HistoryOrderListCell.h"
#import "MeHistoryOrderDetail_VC.h"
#import "MeHistoryOrderModel.h"
#import "MJRefresh.h"

static NSString *reuseIdentifier = @"reuseIdentifier";
@interface MeHistoryBuy_VC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView     *_tableView;
    NSInteger        _refrushCount;

}
@property (nonatomic, strong) NSMutableArray *historyBuyArray;

@end

@implementation MeHistoryBuy_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    _refrushCount = 1;
    [HttpClient getMyGoodsBuyHistoryWithPage:@1 WithBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        self.historyBuyArray = [NSMutableArray arrayWithCapacity:0];
        if (statusCode == 200) {
            for (NSDictionary *myDic in dictionary[@"responseArray"]) {
                MeHistoryOrderModel *historyOrderModel = [MeHistoryOrderModel getMeHistoryOrderModelWithDictionary:myDic];
                [self.historyBuyArray addObject:historyOrderModel];
            }
            [_tableView reloadData];
        } else {
            kTipAlert(@"请求失败");
        }
    }];

    [self setupRefresh];
}
- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-44-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    [_tableView registerClass:[HistoryOrderListCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_tableView];
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
    [HttpClient getMyGoodsBuyHistoryWithPage:@(_refrushCount) WithBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        if (statusCode == 200) {
            for (NSDictionary *myDic in dictionary[@"responseArray"]) {
                MeHistoryOrderModel *historyOrderModel = [MeHistoryOrderModel getMeHistoryOrderModelWithDictionary:myDic];
                [self.historyBuyArray addObject:historyOrderModel];
            }
            [_tableView reloadData];
        } else {
            kTipAlert(@"请求失败");
        }
    }];
    [_tableView footerEndRefreshing];
    
}






- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historyBuyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MeHistoryOrderModel *historyOrderModel = self.historyBuyArray[indexPath.row];
    cell.timeLabel.text = historyOrderModel.creatTime;
    cell.payStatus.text = historyOrderModel.payType;
    if ([historyOrderModel.payType isEqualToString:@"已付款"]) {
        cell.payStatus.textColor = kGreen;
    } else if ([historyOrderModel.payType isEqualToString:@"待付款"]) {
        cell.payStatus.textColor = [UIColor redColor];
    }
    if (historyOrderModel.photoArray.count > 0) {
        [cell.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PhotoAPI, historyOrderModel.photoArray[0]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
    } else {
        cell.photoView.image = [UIImage imageNamed:@"默认图片"];
    }
    cell.orderTitleLabel.text = historyOrderModel.name;
    cell.categoryLabel.text = historyOrderModel.category;
    cell.priceLabel.text = historyOrderModel.price;
    cell.numberLabel.text = [NSString stringWithFormat:@"X%@", historyOrderModel.amount];
    cell.totalPriceLabel.text = [NSString stringWithFormat:@"共%@件商品 合计：%@", historyOrderModel.amount, historyOrderModel.totalPrice];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MeHistoryOrderModel *myModel = self.historyBuyArray[indexPath.row];
    MeHistoryOrderDetail_VC *detailVC = [[MeHistoryOrderDetail_VC alloc] init];
    detailVC.orderModel = myModel;
    detailVC.isBuy = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
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
