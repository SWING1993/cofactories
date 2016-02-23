//
//  MallOrderSellDetail_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/2/18.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallOrderSellDetail_VC.h"
#import "MallHistoryOrderCell.h"
#import "MallOrderAddressCell.h"
#import "MallOrderStatusCell.h"
#import "IMChatViewController.h"
#import "MallOrderMark_VC.h"

static NSString *mallGoodsCellIdentifier = @"mallGoodsCell";
static NSString *mallAddressCellIdentifier = @"mallAddressCell";
static NSString *mallStatusCellIdentifier = @"mallStatusCell";
@interface MallOrderSellDetail_VC (){
    UIButton *lastButton;
}

@end

@implementation MallOrderSellDetail_VC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIBarButtonItem appearance] setTintColor:[UIColor grayColor]];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.goodsModel.mallOrderTitle;
    
    [self.tableView registerClass:[MallHistoryOrderCell class] forCellReuseIdentifier:mallGoodsCellIdentifier];
    [self.tableView registerClass:[MallOrderAddressCell class] forCellReuseIdentifier:mallAddressCellIdentifier];
    [self.tableView registerClass:[MallOrderStatusCell class] forCellReuseIdentifier:mallStatusCellIdentifier];
    
    UIBarButtonItem *mallDetailBackItem = [[UIBarButtonItem alloc] init];
    mallDetailBackItem.image = [UIImage imageNamed:@"back"];
    mallDetailBackItem.target = self;
    mallDetailBackItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = mallDetailBackItem;
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"MePhoneCall"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(phoneCall);
    self.navigationItem.rightBarButtonItem = temporaryBarButtonItem;
    
    [self creatTableViewFooterView];
}

- (void)creatTableViewFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 160 - 20*(self.goodsModel.status - 1))];
    switch (self.goodsModel.status) {
        case 2:
            lastButton = [Tools buttonWithFrame:CGRectMake(20, 100 - 20*(self.goodsModel.status - 1), kScreenW - 40, 38) withTitle:@"确认发货"];
            self.tableView.tableFooterView = footerView;
            break;
        case 4:
            if ([self.goodsModel.comment isEqualToString:@"1"]) {
                lastButton.hidden = YES;
            } else {
                lastButton = [Tools buttonWithFrame:CGRectMake(20, 100 - 20*(self.goodsModel.status - 1), kScreenW - 40, 38) withTitle:@"立即评价"];
                self.tableView.tableFooterView = footerView;
            }
            break;
        default:
            lastButton.hidden = YES;
            break;
    }
    [lastButton addTarget:self action:@selector(actionOfLastButton:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:lastButton];
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
        MallHistoryOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:mallGoodsCellIdentifier forIndexPath:indexPath];
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
    } else if (indexPath.section == 1) {
        MallOrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:mallAddressCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.personName.text = [NSString stringWithFormat:@"收货人：%@", self.goodsModel.personName];
        cell.personPhoneNumber.text = [NSString stringWithFormat:@"电话：%@", self.goodsModel.personPhone];
        cell.personAddress.text = [NSString stringWithFormat:@"收货地址：%@", self.goodsModel.personAddress];
        return cell;
    } else {
        MallOrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:mallStatusCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.creatTime.text = [NSString stringWithFormat:@"创建时间：%@", self.goodsModel.creatTime];
        cell.orderNum.text = [NSString stringWithFormat:@"订单编号：%@", self.goodsModel.orderNumber];
        switch (self.goodsModel.status) {
            case 2:
                cell.payTime.text = [NSString stringWithFormat:@"付款时间：%@", self.goodsModel.payTime];
                cell.sendTime.hidden = YES;
                cell.receiveTime.hidden = YES;
                break;
            case 3:
                cell.payTime.text = [NSString stringWithFormat:@"付款时间：%@", self.goodsModel.payTime];
                cell.sendTime.text = [NSString stringWithFormat:@"发货时间：%@", self.goodsModel.sendTime];
                cell.receiveTime.hidden = YES;
                break;
            case 4:
                cell.payTime.text = [NSString stringWithFormat:@"付款时间：%@", self.goodsModel.payTime];
                cell.sendTime.text = [NSString stringWithFormat:@"发货时间：%@", self.goodsModel.sendTime];
                cell.receiveTime.text = [NSString stringWithFormat:@"收货时间：%@", self.goodsModel.receiveTime];
                break;
            case 5:
                cell.payTime.text = [NSString stringWithFormat:@"付款时间：%@", self.goodsModel.payTime];
                cell.sendTime.text = [NSString stringWithFormat:@"发货时间：%@", self.goodsModel.sendTime];
                cell.receiveTime.text = [NSString stringWithFormat:@"收货时间：%@", self.goodsModel.receiveTime];
                break;
            default:
                cell.payTime.hidden = YES;
                cell.sendTime.hidden = YES;
                cell.receiveTime.hidden = YES;
                break;
        }
        return cell;
    }
    
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 195;
    } else if (indexPath.section == 1) {
        return 80;
    } else {
        if (self.goodsModel.status == 0) {
            return 60;
        } else if (self.goodsModel.status == 5) {
            return 120;
        } else {
            return 60 + 20*(self.goodsModel.status - 1);
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}


- (void)actionOfLastButton:(UIButton *)button {
    switch (self.goodsModel.status) {
        case 2: {
            DLog(@"确认发货");
            [HttpClient sellerSendGoodsToBuyerWithPurchaseId:self.goodsModel.orderNumber WithBlock:^(NSDictionary *dictionary) {
                NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
                if (statusCode == 200) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发货成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alert show];
                } else {
                    kTipAlert(@"%@",[dictionary objectForKey:@"message"]);
                }
            }];
        }
            break;
        case 4: {
            DLog(@"立即评价");
            MallOrderMark_VC *mallMarkVC = [[MallOrderMark_VC alloc] initWithStyle:UITableViewStyleGrouped];
            mallMarkVC.isBuyHistory = NO;
            mallMarkVC.purchaseId = self.goodsModel.orderNumber;
            [self.navigationController pushViewController:mallMarkVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        ApplicationDelegate.mallStatus = @"3";
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)phoneCall {
    NSString *str = @"telprompt://4006400391";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
