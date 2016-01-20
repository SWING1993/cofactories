//
//  MeHistorySell_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/17.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "MeHistorySell_VC.h"
#import "HistoryOrderListCell.h"
#import "MeHistoryOrderDetail_VC.h"
#import "MeHistoryOrderModel.h"
#import "MJRefresh.h"
#import "TableViewHeaderView.h"

static NSString *reuseIdentifier = @"reuseIdentifier";
@interface MeHistorySell_VC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView     *_tableView;
    NSInteger        _refrushCount;
}
@property (nonatomic, strong) NSMutableArray *historySellArray;

@end

@implementation MeHistorySell_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    _refrushCount = 1;
    [HttpClient getMyGoodsSellHistoryWithPage:@1 WithBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        self.historySellArray = [NSMutableArray arrayWithCapacity:0];
        if (statusCode == 200) {
            for (NSDictionary *myDic in dictionary[@"responseArray"]) {
                MeHistoryOrderModel *historyOrderModel = [MeHistoryOrderModel getMeHistoryOrderModelWithDictionary:myDic];
                [self.historySellArray addObject:historyOrderModel];
            }
            if (self.historySellArray.count == 0) {
                _tableView.backgroundView = [[TableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 - 44) withImage:@"数据暂无" withLabelText:@"暂无出售记录"];
            } else {
                [self setupRefresh];
                [_tableView reloadData];
            }

        } else {
            kTipAlert(@"您的网络有点不太顺畅哦！");
        }
    }];
    
}
- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-44-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    _tableView.tableFooterView = [[UIView alloc] init];
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
    DLog(@"_refrushCount==%ld",_refrushCount);
    [HttpClient getMyGoodsSellHistoryWithPage:@(_refrushCount) WithBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        if (statusCode == 200) {
            for (NSDictionary *myDic in dictionary[@"responseArray"]) {
                MeHistoryOrderModel *historyOrderModel = [MeHistoryOrderModel getMeHistoryOrderModelWithDictionary:myDic];
                [self.historySellArray addObject:historyOrderModel];
            }
            [_tableView reloadData];
        } else {
            kTipAlert(@"您的网络有点不太顺畅哦！");
        }
    }];
    [_tableView footerEndRefreshing];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.historySellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MeHistoryOrderModel *historyOrderModel = self.historySellArray[indexPath.row];
    cell.timeLabel.text = historyOrderModel.creatTime;
    cell.payStatus.text = historyOrderModel.payType;
    if ([historyOrderModel.payType isEqualToString:@"已付款"]) {
        cell.payStatus.textColor = kGreen;
    } else if ([historyOrderModel.payType isEqualToString:@"待付款"]) {
        cell.payStatus.textColor = [UIColor redColor];
    }
    if (historyOrderModel.photoArray.count > 0) {
        NSString* encodedString = [[NSString stringWithFormat:@"%@%@", PhotoAPI, historyOrderModel.photoArray[0]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [cell.photoView sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"默认图片"]];
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
    MeHistoryOrderModel *myModel = self.historySellArray[indexPath.row];
    MeHistoryOrderDetail_VC *detailVC = [[MeHistoryOrderDetail_VC alloc] initWithStyle:UITableViewStyleGrouped];
    detailVC.orderModel = myModel;
    detailVC.isBuy = NO;
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
