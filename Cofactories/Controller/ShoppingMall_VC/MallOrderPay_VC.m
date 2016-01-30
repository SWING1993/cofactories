//
//  MallOrderPay_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/1/29.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallOrderPay_VC.h"
#import "MallOrderInfoCell.h"
#import "MallPayTypeCell.h"

@interface MallOrderPay_VC () {
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
    _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
    _header.backgroundColor = [UIColor whiteColor];
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenW - 30, 30)];
    myLabel.font = [UIFont systemFontOfSize:12];
    myLabel.textColor = GRAYCOLOR(100);
    myLabel.text = @"请选择一种付款方式";
    [_header addSubview:myLabel];
    
    [self creatTableViewFooterView];
    [self.tableView registerClass:[MallOrderInfoCell class] forCellReuseIdentifier:CellIndentifier];
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
        MallOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.payStatus.text = @"等待卖家付款";
        cell.photoView.image = [UIImage imageNamed:@"Market-流行资讯.jpg"];
        cell.goodsTitle.text = @"印花染布";
        cell.goodsPrice.text = @"¥ 28.00";
        cell.goodsCategory.text = @"分类：打板纸板";
        cell.goodsNumber.text = @"x10";
        cell.totalPrice.text = @"共10件商品 合计：¥ 280.00";
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
        return 150;
    }
    return 60;
}

- (CGFloat)tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section {
    if (section == 1) {
        return 30;
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
- (void) actionOfDoneButton:(UIButton *)button {
    DLog(@"确认支付");
    
}

@end
