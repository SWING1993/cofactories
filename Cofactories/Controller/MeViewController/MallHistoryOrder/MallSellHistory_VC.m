//
//  MallSellHistory_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/1/30.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallSellHistory_VC.h"
#import "MallHistoryOrderCell.h"
#import "MeHistoryOrderModel.h"
#import "MJRefresh.h"
#import "TableViewHeaderView.h"
#import "IMChatViewController.h"
#import "MallOrderSellDetail_VC.h"
#import "MallOrderMark_VC.h"

static NSString *mallSellCellIdentifier = @"mallSellCell";
@interface MallSellHistory_VC ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    UITableView     *mallSellTableView;
    UILabel         *lineLabel;
    NSMutableArray  *buttonArray;
    NSInteger       refrushCount;
    NSArray         *statusArray;
}
@property (nonatomic, strong) NSMutableArray *mallSellHistoryArray;

@end

@implementation MallSellHistory_VC
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    statusArray = @[@"", @"wait_buyer_pay", @"wait_seller_send", @"wait_buyer_receive", @"wait_comment"];
    
    self.status = [ApplicationDelegate.mallStatus integerValue];
    [self changeStatus:self.status];
    
    refrushCount = 1;
    [self network];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"出售交易";
    
    [self creatTableView];
    [mallSellTableView registerClass:[MallHistoryOrderCell class] forCellReuseIdentifier:mallSellCellIdentifier];
    [self creatHeaderView];
}

- (void)network {
    [HttpClient getMallOrderOfSellWithStatus:statusArray[self.status] page:@1 WithBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        if (statusCode == 200) {
            self.mallSellHistoryArray = [NSMutableArray arrayWithCapacity:0];
            for (NSMutableDictionary *historyDic in dictionary[@"data"]) {
                MeHistoryOrderModel *historyOrderModel = [MeHistoryOrderModel getMeHistoryOrderModelWithDictionary:historyDic];
                [self.mallSellHistoryArray addObject:historyOrderModel];
            }
            if (self.mallSellHistoryArray.count == 0) {
                mallSellTableView.backgroundView = [[TableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 - 44) withImage:@"数据暂无" withLabelText:@"您还没有相关的订单"];
            } else {
                mallSellTableView.backgroundView = nil;
                [self setupRefresh];
                [mallSellTableView reloadData];
            }
        }
    }];
}

- (void)setupRefresh{
    [mallSellTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    mallSellTableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    mallSellTableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    mallSellTableView.footerRefreshingText = @"加载中...";
}

- (void)footerRereshing{
    refrushCount++;
    DLog(@"_refrushCount==%ld",refrushCount);
    [HttpClient getMallOrderOfSellWithStatus:statusArray[self.status] page:@(refrushCount) WithBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        if (statusCode == 200) {
            for (NSMutableDictionary *historyDic in dictionary[@"data"]) {
                MeHistoryOrderModel *historyOrderModel = [MeHistoryOrderModel getMeHistoryOrderModelWithDictionary:historyDic];
                [self.mallSellHistoryArray addObject:historyOrderModel];
            }
            [mallSellTableView reloadData];
        }
    }];
    [mallSellTableView footerEndRefreshing];
}

- (void)creatTableView {
    mallSellTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 43, kScreenW, kScreenH - 43)style:UITableViewStyleGrouped];
    mallSellTableView.dataSource = self;
    mallSellTableView.delegate = self;
    [self.view addSubview:mallSellTableView];
}

- (void)creatHeaderView {
    NSArray *btnTitleArray = @[@"全部", @"待付款", @"待发货", @"待收货", @"待评价"];
    buttonArray = [NSMutableArray arrayWithCapacity:0];
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, 44)];
    headerView.backgroundColor=[UIColor whiteColor];
    for (int i = 0; i < 5; i++) {
        UIButton*typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typeBtn.frame = CGRectMake(i*(kScreenW/5), 0, kScreenW/5.f, 44);
        typeBtn.tag = i;
        typeBtn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        [typeBtn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [typeBtn setTitleColor:kDeepBlue forState:UIControlStateSelected];
        [typeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == self.status) {
            typeBtn.selected = YES;
            lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeBtn.frame.origin.x + 5, 42, kScreenW/5 - 10, 2)];
            lineLabel.backgroundColor = kDeepBlue;
            [headerView addSubview:lineLabel];
        }
        
        [headerView addSubview:typeBtn];
        [buttonArray addObject:typeBtn];
        
        CALayer *line = [CALayer layer];
        line.frame = CGRectMake(0, 44 - 0.3, kScreenW, 0.3);
        line.backgroundColor = kLineGrayCorlor.CGColor;
        [headerView.layer addSublayer:line];
    }
    [self.view addSubview:headerView];
}

- (void)buttonClick:(UIButton *)button {
    
    self.status = button.tag;
    [self changeStatus:self.status];
    refrushCount = 1;
    [HttpClient getMallOrderOfSellWithStatus:statusArray[self.status] page:@(refrushCount) WithBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        if (statusCode == 200) {
            self.mallSellHistoryArray = [NSMutableArray arrayWithCapacity:0];
            for (NSMutableDictionary *historyDic in dictionary[@"data"]) {
                MeHistoryOrderModel *historyOrderModel = [MeHistoryOrderModel getMeHistoryOrderModelWithDictionary:historyDic];
                [self.mallSellHistoryArray addObject:historyOrderModel];
            }
            
            if (self.mallSellHistoryArray.count == 0) {
                [mallSellTableView removeFooter];
                mallSellTableView.backgroundView = [[TableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 - 44) withImage:@"数据暂无" withLabelText:@"您还没有相关的订单"];
            } else {
                mallSellTableView.backgroundView = nil;
                [self setupRefresh];
            }
            [mallSellTableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mallSellHistoryArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MallHistoryOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:mallSellCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MeHistoryOrderModel *historyOrderModel = self.mallSellHistoryArray[indexPath.section];
    cell.goodsStatus.text = historyOrderModel.waitPayType;
    if (historyOrderModel.photoArray.count > 0) {
        NSString* encodedString = [[NSString stringWithFormat:@"%@%@", PhotoAPI, historyOrderModel.photoArray[0]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [cell.photoView sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"MallNoPhoto"]];
    } else {
        cell.photoView.image = [UIImage imageNamed:@"MallNoPhoto"];
    }
    cell.goodsTitle.text = historyOrderModel.name;
    cell.goodsPrice.text = [NSString stringWithFormat:@"¥ %@", historyOrderModel.price];
    cell.goodsCategory.text = historyOrderModel.category;
    cell.goodsNumber.text = [NSString stringWithFormat:@"x%@", historyOrderModel.amount];
    cell.totalPrice.text = [NSString stringWithFormat:@"共%@件商品 合计：¥ %@", historyOrderModel.amount, historyOrderModel.totalPrice];
    
    switch (historyOrderModel.status) {
        case 2:
            [cell.changeStatus setTitle:@"确认发货" forState:UIControlStateNormal];
            break;
        case 4:
            if ([historyOrderModel.comment isEqualToString:@"1"]){
                [cell.changeStatus setTitle:@"待买家评" forState:UIControlStateNormal];
            } else {
                [cell.changeStatus setTitle:@"评价" forState:UIControlStateNormal];
            }
            break;
        case 5:
            [cell.changeStatus setTitle:@"已完成" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    cell.showButton = historyOrderModel.showButton;//判断button是否隐藏
    cell.changeStatus.tag = 222 + indexPath.section;
    [cell.changeStatus addTarget:self action:@selector(actionOfStatus:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 195;
}
- (CGFloat)tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"订单详情");
    ApplicationDelegate.mallStatus = [NSString stringWithFormat:@"%ld", self.status];
    MallOrderSellDetail_VC *mallDetailVC = [[MallOrderSellDetail_VC alloc] initWithStyle:UITableViewStyleGrouped];
    mallDetailVC.goodsModel = self.mallSellHistoryArray[indexPath.section];
    [self.navigationController pushViewController:mallDetailVC animated:YES];
}
- (void)actionOfStatus:(UIButton *)button {
    ApplicationDelegate.mallStatus = [NSString stringWithFormat:@"%ld", self.status];
    if ([button.titleLabel.text isEqualToString:@"确认发货"]) {
        DLog(@"确认发货");
        button.userInteractionEnabled = NO;
        MeHistoryOrderModel *orderModel = self.mallSellHistoryArray[button.tag - 222];
        [HttpClient sellerSendGoodsToBuyerWithPurchaseId:orderModel.orderNumber WithBlock:^(NSDictionary *dictionary) {
            NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
            if (statusCode == 200) {
                button.userInteractionEnabled = YES;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发货成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [alert show];
            } else {
                button.userInteractionEnabled = YES;
                kTipAlert(@"%@",[dictionary objectForKey:@"message"]);
            }
        }];
    } else if ([button.titleLabel.text isEqualToString:@"评价"]) {
        MeHistoryOrderModel *orderModel = self.mallSellHistoryArray[button.tag - 222];
        MallOrderMark_VC *mallMarkVC = [[MallOrderMark_VC alloc] initWithStyle:UITableViewStyleGrouped];
        mallMarkVC.isBuyHistory = NO;
        mallMarkVC.purchaseId = orderModel.orderNumber;
        [self.navigationController pushViewController:mallMarkVC animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self changeStatus:3];
        self.status = 3;
        refrushCount = 1;
        [self network];
    }
}

- (void)changeStatus:(NSInteger)status {
    UIButton *button = buttonArray[status];
    button.selected = YES;
    for (UIButton *sunbBtn in buttonArray) {
        if (sunbBtn != button) {
            sunbBtn.selected = NO;
        }
    }
    [UIView animateWithDuration:0.2 animations:^{
        lineLabel.frame = CGRectMake(button.frame.origin.x + 5, 42, button.frame.size.width - 10, 2);
    }];
}


@end
