//
//  MallBuyHistory_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/1/30.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallBuyHistory_VC.h"
#import "MallHistoryOrderCell.h"
#import "MeHistoryOrderModel.h"
#import "MJRefresh.h"
#import "TableViewHeaderView.h"
#import "MallOrderPay_VC.h"
#import "IMChatViewController.h"
#import "MallOrderBuyDetail_VC.h"
#import "MallOrderMark_VC.h"

static NSString *mallBuyCellIdentifier = @"mallBuyCell";
@interface MallBuyHistory_VC ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    UITableView     *mallBuyTableView;
    UILabel         *lineLabel;
    NSMutableArray  *buttonArray;
    NSArray         *statusArray;
    NSInteger       refrushCount;
}
@property (nonatomic, strong) NSMutableArray *mallBuyHistoryArray;

@end

@implementation MallBuyHistory_VC

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
    
    self.navigationItem.title = @"购买交易";
    
    [self creatTableView];
    [mallBuyTableView registerClass:[MallHistoryOrderCell class] forCellReuseIdentifier:mallBuyCellIdentifier];
    [self creatHeaderView];
}

- (void)network {
    [HttpClient getMallOrderOfBuyWithStatus:statusArray[self.status] page:@1 WithBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        if (statusCode == 200) {
            self.mallBuyHistoryArray = [NSMutableArray arrayWithCapacity:0];
            for (NSMutableDictionary *historyDic in dictionary[@"data"]) {
                MeHistoryOrderModel *historyOrderModel = [MeHistoryOrderModel getMeHistoryOrderModelWithDictionary:historyDic];
                [self.mallBuyHistoryArray addObject:historyOrderModel];
            }
            if (self.mallBuyHistoryArray.count == 0) {
                [mallBuyTableView reloadData];
                mallBuyTableView.backgroundView = [[TableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 - 44) withImage:@"数据暂无" withLabelText:@"您还没有相关的订单"];
            } else {
                mallBuyTableView.backgroundView = nil;
                [self setupRefresh];
                [mallBuyTableView reloadData];
            }
        }
    }];
}

- (void)setupRefresh{
    [mallBuyTableView addFooterWithTarget:self action:@selector(footerRereshing)];
    mallBuyTableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    mallBuyTableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    mallBuyTableView.footerRefreshingText = @"加载中...";
}

- (void)footerRereshing{
    refrushCount++;
    DLog(@"_refrushCount==%ld",refrushCount);
    [HttpClient getMallOrderOfBuyWithStatus:statusArray[self.status] page:@(refrushCount) WithBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        if (statusCode == 200) {
            for (NSMutableDictionary *historyDic in dictionary[@"data"]) {
                MeHistoryOrderModel *historyOrderModel = [MeHistoryOrderModel getMeHistoryOrderModelWithDictionary:historyDic];
                [self.mallBuyHistoryArray addObject:historyOrderModel];
            }
            [mallBuyTableView reloadData];
        }
    }];
    [mallBuyTableView footerEndRefreshing];
}

- (void)creatTableView {
    mallBuyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 43, kScreenW, kScreenH - 43)style:UITableViewStyleGrouped];
    mallBuyTableView.dataSource = self;
    mallBuyTableView.delegate = self;
    [self.view addSubview:mallBuyTableView];
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
        [typeBtn setTitleColor:kMainDeepBlue forState:UIControlStateSelected];
        [typeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == self.status) {
            typeBtn.selected = YES;
            lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeBtn.frame.origin.x + 5, 42, kScreenW/5 - 10, 2)];
            lineLabel.backgroundColor = kMainDeepBlue;
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
    [HttpClient getMallOrderOfBuyWithStatus:statusArray[self.status] page:@(refrushCount) WithBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        if (statusCode == 200) {
            self.mallBuyHistoryArray = [NSMutableArray arrayWithCapacity:0];
            for (NSMutableDictionary *historyDic in dictionary[@"data"]) {
                MeHistoryOrderModel *historyOrderModel = [MeHistoryOrderModel getMeHistoryOrderModelWithDictionary:historyDic];
                [self.mallBuyHistoryArray addObject:historyOrderModel];
            }
            [mallBuyTableView reloadData];
            if (self.mallBuyHistoryArray.count == 0) {
                [mallBuyTableView removeFooter];
                mallBuyTableView.backgroundView = [[TableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 - 44) withImage:@"数据暂无" withLabelText:@"您还没有相关的订单"];
            } else {
                mallBuyTableView.backgroundView = nil;
                [self setupRefresh];
            }
        }
    }];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mallBuyHistoryArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MallHistoryOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:mallBuyCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MeHistoryOrderModel *historyOrderModel = self.mallBuyHistoryArray[indexPath.section];
    
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
    cell.changeStatus.tag = 222 + indexPath.section;
    if (historyOrderModel.status == 4) {
        if ([historyOrderModel.comment isEqualToString:@"2"]) {
            [cell.changeStatus setTitle:@"待卖家评" forState:UIControlStateNormal];
        } else {
            [cell.changeStatus setTitle:@"评价" forState:UIControlStateNormal];
        }
    } else {
        [cell.changeStatus setTitle:historyOrderModel.payType forState:UIControlStateNormal];
    }
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
    DLog(@"订单详情%ld", self.status);
    ApplicationDelegate.mallStatus = [NSString stringWithFormat:@"%ld", self.status];
    MallOrderBuyDetail_VC *mallDetailVC = [[MallOrderBuyDetail_VC alloc] initWithStyle:UITableViewStyleGrouped];
    mallDetailVC.goodsModel = self.mallBuyHistoryArray[indexPath.section];
    [self.navigationController pushViewController:mallDetailVC animated:YES];
}

- (void)actionOfStatus:(UIButton *)button {
    DLog(@"*************");
    ApplicationDelegate.mallStatus = [NSString stringWithFormat:@"%ld", self.status];
    if ([button.titleLabel.text isEqualToString:@"付款"]) {
        DLog(@"付款");
        MallOrderPay_VC *mallOrderPayVC = [[MallOrderPay_VC alloc] initWithStyle:UITableViewStyleGrouped];
        mallOrderPayVC.isMeMallOrder = YES;
        mallOrderPayVC.mallPurchseId = [self.mallBuyHistoryArray[button.tag - 222] orderNumber];
        [self.navigationController pushViewController:mallOrderPayVC animated:YES];
    } else if ([button.titleLabel.text isEqualToString:@"联系卖家"]){
        button.userInteractionEnabled = NO;
        // 聊天
        MeHistoryOrderModel *historyOrder = self.mallBuyHistoryArray[button.tag - 222];
        //解析工厂信息
        [HttpClient getOtherIndevidualsInformationWithUserID:historyOrder.sellerUserId WithCompletionBlock:^(NSDictionary *dictionary) {
            NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
            if (statusCode == 200) {
                button.userInteractionEnabled = YES;
                OthersUserModel *otherModel = (OthersUserModel *)dictionary[@"message"];
                IMChatViewController *conversationVC = [[IMChatViewController alloc]init];
                conversationVC.conversationType = ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
                conversationVC.targetId = historyOrder.sellerUserId; // 接收者的 targetId，这里为举例。
                conversationVC.title = otherModel.name; // 会话的 title。
                conversationVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController.navigationBar setHidden:NO];
                [self.navigationController pushViewController:conversationVC animated:YES];
            }
            
        }];
    } else if ([button.titleLabel.text isEqualToString:@"确认收货"]){
        button.userInteractionEnabled = NO;
        MeHistoryOrderModel *orderModel = self.mallBuyHistoryArray[button.tag - 222];
        [HttpClient buyerReceiveGoodsFromSellerWithPurchaseId:orderModel.orderNumber WithBlock:^(NSDictionary *dictionary) {
            NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
            if (statusCode == 200) {
                button.userInteractionEnabled = YES;
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认收货成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [alert show];
            } else {
                button.userInteractionEnabled = YES;
                kTipAlert(@"%@",[dictionary objectForKey:@"message"]);
            }

        }];
    } else if ([button.titleLabel.text isEqualToString:@"评价"]){
        MeHistoryOrderModel *orderModel = self.mallBuyHistoryArray[button.tag - 222];
        MallOrderMark_VC *mallMarkVC = [[MallOrderMark_VC alloc] initWithStyle:UITableViewStyleGrouped];
        mallMarkVC.isBuyHistory = YES;
        mallMarkVC.purchaseId = orderModel.orderNumber;
        [self.navigationController pushViewController:mallMarkVC animated:YES];
    } 
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self changeStatus:4];
        self.status = 4;
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
