//
//  MeHistoryOrderDetail_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/15.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "MeHistoryOrderDetail_VC.h"
#import "HistoryOrderDetailCell.h"
#import "HistoryOrderAddressCell.h"
#import "HistoryOrderThirdCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AlipayHeader.h"

static NSString *orderDetailCellIdentifier = @"orderDetailCell";
static NSString *addressCellIdentifier = @"addressCell";
static NSString *thirdCellIdentifier = @"thirdCell";
@interface MeHistoryOrderDetail_VC () {
    UIButton *lastButton;
}

@end

@implementation MeHistoryOrderDetail_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
//    self.tableView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    [self.tableView registerClass:[HistoryOrderDetailCell class] forCellReuseIdentifier:orderDetailCellIdentifier];
    [self.tableView registerClass:[HistoryOrderAddressCell class] forCellReuseIdentifier:addressCellIdentifier];
    [self.tableView registerClass:[HistoryOrderThirdCell class] forCellReuseIdentifier:thirdCellIdentifier];
//    if ([self.orderModel.payType isEqualToString:@"待付款"] && self.isBuy == YES) {
//        [self creatTableViewFooterView];
//    }
}

- (void)creatTableViewFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
    lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lastButton.frame = CGRectMake(20, 30, kScreenW - 40, 38);
    [lastButton setTitle:@"去付款" forState:UIControlStateNormal];
    lastButton.titleLabel.font = [UIFont systemFontOfSize:15.5];
    lastButton.layer.cornerRadius = 4;
    lastButton.clipsToBounds = YES;
    lastButton.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:171.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
    [lastButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lastButton addTarget:self action:@selector(actionOfPay:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:lastButton];
    DLog(@"^^^^^^^^^%@", self.orderModel.orderNumber);
    self.tableView.tableFooterView = footerView;
}
- (void)actionOfPay:(UIButton *)button {
    DLog(@"去付款");
    NSString *tradeNO = self.orderModel.orderNumber;
    NSString *descriptionStr = self.orderModel.descriptions;
    NSString *subject = [NSString stringWithFormat:@"%@ %@ X%@", self.orderModel.name, self.orderModel.category, self.orderModel.amount];
    NSString *amountStr = self.orderModel.totalPrice;
    if (tradeNO && descriptionStr && subject) {
        [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:tradeNO productName:subject productDescription:descriptionStr amount:amountStr notifyURL:kNotifyURL itBPay:@"30m"];
    } else {
        kTipAlert(@"生成订单信息失败");
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HistoryOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:orderDetailCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.orderModel.photoArray.count > 0) {
            [cell.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PhotoAPI, self.orderModel.photoArray[0]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
        } else {
            cell.photoView.image = [UIImage imageNamed:@"默认图片"];
        }
        cell.orderTitleLabel.text = self.orderModel.name;
        cell.categoryLabel.text = [NSString stringWithFormat:@"分类：%@", self.orderModel.category];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%@", self.orderModel.price];
        cell.numberLabel.text = [NSString stringWithFormat:@"X%@", self.orderModel.amount];
        cell.totalPriceLabel.text = [NSString stringWithFormat:@"共%@件商品 合计：%@", self.orderModel.amount, self.orderModel.totalPrice];
        return cell;
    } else if (indexPath.section == 1) {
        HistoryOrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.personName.text = [NSString stringWithFormat:@"收货人：%@", self.orderModel.personName];
        cell.personPhoneNumber.text = [NSString stringWithFormat:@"电话：%@", self.orderModel.personPhone];
        cell.personAddress.text = [NSString stringWithFormat:@"收货地址：%@", self.orderModel.personAddress];
        
        return cell;
    } else {
        HistoryOrderThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:thirdCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.creatTime.text = [NSString stringWithFormat:@"创建时间：%@", self.orderModel.creatTime];
        cell.orderNum.text = [NSString stringWithFormat:@"订单编号：%@", self.orderModel.orderNumber];
        cell.payType.text = [NSString stringWithFormat:@"付款状态：%@", self.orderModel.payType];
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    } else if (indexPath.section == 1) {
        return 100;
    } else {
        return 80;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
