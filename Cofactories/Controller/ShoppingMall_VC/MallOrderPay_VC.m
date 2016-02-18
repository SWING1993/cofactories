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

@interface MallOrderPay_VC ()<UIAlertViewDelegate> {
    NSArray *payPhotoArray, *payTitleArray;
    UIView *_header;
    NSString *paySelectString;
}

@end

static NSString *CellIndentifier = @"cell";
static NSString *payCellIndentifier = @"payCell";
@implementation MallOrderPay_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单支付";
    
    payPhotoArray = @[@"Mall-alipay", @"Home-icon"];
    payTitleArray = @[@"支付宝支付", @"账户支付"];
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
}

- (void) creatTableViewFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
    UIButton *doneButton = [Tools buttonWithFrame:CGRectMake(20, 100, kScreenW - 40, 38) withTitle:@"确认支付"];
    
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
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MallHistoryOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.goodsStatus.text = self.goodsModel.waitPayType;
        if (self.goodsModel.photoArray.count > 0) {
            NSString* encodedString = [[NSString stringWithFormat:@"%@%@", PhotoAPI, self.goodsModel.photoArray[0]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [cell.photoView sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"MallNoPhoto"]];
        } else {
            cell.photoView.image = [UIImage imageNamed:@"MallNoPhoto"];
        }
        cell.goodsTitle.text = self.goodsModel.name;
        cell.goodsPrice.text = [NSString stringWithFormat:@"¥ %@", self.goodsModel.price];
        cell.goodsCategory.text = self.goodsModel.category;
        cell.goodsNumber.text = [NSString stringWithFormat:@"x%@", self.goodsModel.amount];
        cell.totalPrice.text = [NSString stringWithFormat:@"共%@件商品 合计：¥ %@", self.goodsModel.amount, self.goodsModel.totalPrice];
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
    if ([paySelectString isEqualToString:@"支付宝支付"]) {
        [HttpClient buyGoodsWithPurchaseId:self.goodsModel.orderNumber payment:@"alipay" WithBlock:^(NSDictionary *dictionary) {
            NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
            if (statusCode == 200) {
                DLog(@"支付宝付款成功%@", dictionary);
                NSString *tradeNO = dictionary[@"data"][@"out_trade_no"];
                NSString *descriptionStr = dictionary[@"data"][@"body"];
                NSString *subject = dictionary[@"data"][@"subject"];
                NSString *amountStr = self.goodsModel.totalPrice;
                DLog(@"amountPrice = %@", amountStr);
                if (tradeNO && descriptionStr && subject) {
                    [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:tradeNO productName:subject productDescription:descriptionStr amount:amountStr notifyURL:kNotifyURL itBPay:@"30m"];
                } else {
                    kTipAlert(@"支付宝付款失败");
                }
            } else {
                kTipAlert(@"%@",[dictionary objectForKey:@"message"]);
            }

        }];
        
    } else if ([paySelectString isEqualToString:@"账户支付"]) {
        [HttpClient buyGoodsWithPurchaseId:self.goodsModel.orderNumber payment:@"wallet" WithBlock:^(NSDictionary *dictionary) {
            NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
            if (statusCode == 200) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"账户付款成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [alert show];
            } else {
                kTipAlert(@"%@",[dictionary objectForKey:@"message"]);
            }
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        MallBuyHistory_VC *mallBuyVC = [[MallBuyHistory_VC alloc] init];
        mallBuyVC.status = 2;
        [self.navigationController pushViewController:mallBuyVC animated:YES];
    }
}

@end
