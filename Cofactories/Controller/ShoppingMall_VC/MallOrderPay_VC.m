//
//  MallOrderPay_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/1/29.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallOrderPay_VC.h"
#import "MallPayTypeCell.h"
#import "MallHistoryOrderCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AlipayHeader.h"
#import "MallBuyHistory_VC.h"
#import "TradeSuccessVC.h"

@interface MallOrderPay_VC () {
    NSArray *payPhotoArray, *payTitleArray;
    UIView *_header;
    NSString *paySelectString;
}

@property (nonatomic, strong) MallBuyHistoryModel *goodsModel;
@property (nonatomic,retain)UserModel * MyProfile;

@end

static NSString *CellIndentifier = @"cell";
static NSString *payCellIndentifier = @"payCell";
@implementation MallOrderPay_VC

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.MyProfile = [[UserModel alloc]getMyProfile];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(aliPaySuccess) name: @"aliPaySuccess" object: nil];
    
    self.navigationItem.title = @"订单支付";
    self.MyProfile = [[UserModel alloc]getMyProfile];
    payPhotoArray = @[@"Mall-alipay", @"Home-icon", @"qiyezhanghaopay"];
    payTitleArray = @[@"支付宝支付", @"账户支付", @"企业账号支付"];
    paySelectString = @"支付宝支付";
    _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 35)];
    _header.backgroundColor = [UIColor whiteColor];
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenW - 30, 35)];
    myLabel.font = [UIFont systemFontOfSize:12];
    myLabel.textColor = GRAYCOLOR(100);
    myLabel.text = @"请选择一种付款方式";
    [_header addSubview:myLabel];
    [self creatTableViewFooterView];
    [self.tableView registerClass:[MallHistoryOrderCell class] forCellReuseIdentifier:CellIndentifier];
    [self.tableView registerClass:[MallPayTypeCell class] forCellReuseIdentifier:payCellIndentifier];
    [self netWork];
}
- (void)netWork {
    [HttpClient getMallOrderDetailWithPurchseId:self.mallPurchseId WithBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        if (statusCode == 200) {
            self.goodsModel = [MallBuyHistoryModel getMallBuyHistorymodelWithDictionary:dictionary[@"data"]];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        } else {
            kTipAlert(@"%@",[dictionary objectForKey:@"message"]);
        }
    }];
}
- (void) creatTableViewFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 110)];
    UIButton *doneButton = [Tools buttonWithFrame:CGRectMake(20, 60, kScreenW - 40, 38) withTitle:@"确认支付"];
    
    [doneButton addTarget:self action:@selector(actionOfDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:doneButton];
    
    self.tableView.tableFooterView = footerView;
}

#pragma mark - UITableViewDataSurce

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if (self.MyProfile.enterpriseType == EnterpriseType_noEnterprise) {
            return 2;
        } else {
            return 3;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MallHistoryOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier forIndexPath:indexPath];
        [cell reloadMallBuyHistoryOrderDetailDataWithMallBuyHistoryModel:self.goodsModel];
        cell.changeStatus.hidden = YES;
        return cell;
    } else {
        MallPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:payCellIndentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.payTitle.text = payTitleArray[indexPath.row];
        cell.photoView.image = [UIImage imageNamed:payPhotoArray[indexPath.row]];
        if ([cell.payTitle.text isEqualToString:paySelectString]) {
            cell.paySelect.image = [UIImage imageNamed:@"MeIsSelect"];
            [Tools showOscillatoryAnimationWithLayer:cell.paySelect.layer isToBig:YES];
        } else {
            cell.paySelect.image = [UIImage imageNamed:@"MeIsNoSelect"];
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 160;
    }
    return 60;
}

- (CGFloat)tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section {
    if (section == 1) {
        return 35;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 20;
    }
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return _header;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        paySelectString = payTitleArray[indexPath.row];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - 确认支付
- (void)actionOfDoneButton:(UIButton *)button {
    
    DLog(@"确认支付");
    [button addShakeAnimation];
    button.userInteractionEnabled = NO;
    if ([paySelectString isEqualToString:@"支付宝支付"]) {
        [HttpClient buyGoodsWithPurchaseId:self.mallPurchseId payment:@"alipay" WithBlock:^(NSDictionary *dictionary) {
            NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
            switch (statusCode) {
                case 200: {
                    button.userInteractionEnabled = YES;
                    DLog(@"支付宝付款成功%@", dictionary);
                    NSString *tradeNO = dictionary[@"data"][@"out_trade_no"];
                    NSString *descriptionStr = dictionary[@"data"][@"body"];
                    NSString *subject = dictionary[@"data"][@"subject"];
                    NSString *amountStr = self.goodsModel.totalPrice;
                    DLog(@"amountPrice = %@, tradeNO = %@", amountStr, tradeNO);
                    if (tradeNO && descriptionStr && subject) {
                        [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:tradeNO productName:subject productDescription:descriptionStr amount:amountStr notifyURL:kNotifyURL itBPay:@"60m"];

                    } else {
                        kTipAlert(@"支付宝付款失败");
                    }
                }
                    break;
                default:
                    kTipAlert(@"%@(错误码：%ld)",[dictionary objectForKey:@"message"],(long)statusCode);
                    button.userInteractionEnabled = YES;
                    break;
            }
        }];
        
    } else if ([paySelectString isEqualToString:@"账户支付"]) {
        [HttpClient buyGoodsWithPurchaseId:self.mallPurchseId payment:@"wallet" WithBlock:^(NSDictionary *dictionary) {
            NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
            switch (statusCode) {
                case 200: {
                    [self orderPaySuccess:@"账户支付"];
                    button.userInteractionEnabled = YES;
                }
                    break;
                default: {
                    kTipAlert(@"%@(错误码：%ld)",[dictionary objectForKey:@"message"],(long)statusCode);
                    button.userInteractionEnabled = YES;
                }
                    break;
            }
        }];
    } else if ([paySelectString isEqualToString:@"企业账号支付"]) {
        //企业账号支付
        [HttpClient buyGoodsWithPurchaseId:self.mallPurchseId payment:@"enterprise" WithBlock:^(NSDictionary *dictionary) {
            NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
            switch (statusCode) {
                case 200: {
                    [self orderPaySuccess:@"企业账号支付"];
                    button.userInteractionEnabled = YES;
                }
                    break;
                default: {
                    kTipAlert(@"%@(错误码：%ld)",[dictionary objectForKey:@"message"],(long)statusCode);
                    button.userInteractionEnabled = YES;
                }
                    break;
            }
        }];
    }
}


//支付宝支付成功返回
- (void)aliPaySuccess {
    //支付宝付款成功，跳转到相应付款成功界面
    TradeSuccessVC *tradeSuccessVC = [[TradeSuccessVC alloc] init];
    tradeSuccessVC.purchaseId = self.mallPurchseId;
    tradeSuccessVC.orderTitle = @"付款成功";
    tradeSuccessVC.status = @"待发货订单";
    tradeSuccessVC.totalPrice = self.goodsModel.totalPrice;
    [self.navigationController pushViewController:tradeSuccessVC animated:YES];
}


- (void) orderPaySuccess:(NSString *)payType {
    TradeSuccessVC *tradeSuccessVC = [[TradeSuccessVC alloc] init];
    tradeSuccessVC.purchaseId = self.mallPurchseId;
    if ([payType isEqualToString:@"账户支付"]) {
        tradeSuccessVC.orderTitle = @"付款成功";
        tradeSuccessVC.status = @"待发货订单";
    } else if ([payType isEqualToString:@"企业账号支付"]) {
        tradeSuccessVC.orderTitle = @"付款申请已提交至主账号";
        tradeSuccessVC.status = @"等待主账号审核通过";
    }
    tradeSuccessVC.totalPrice = self.goodsModel.totalPrice;
    [self.navigationController pushViewController:tradeSuccessVC animated:YES];
    
}
- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end
