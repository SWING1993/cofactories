//
//  MallHistoryDetail_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/2/17.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallOrderBuyDetail_VC.h"
#import "MallHistoryOrderCell.h"
#import "MallOrderAddressCell.h"
#import "MallOrderStatusCell.h"
#import "IMChatViewController.h"
#import "MallOrderPay_VC.h"
#import "MallOrderMark_VC.h"

static NSString *mallGoodsCellIdentifier = @"mallGoodsCell";
static NSString *mallAddressCellIdentifier = @"mallAddressCell";
static NSString *mallStatusCellIdentifier = @"mallStatusCell";
@interface MallOrderBuyDetail_VC ()<UIAlertViewDelegate> {
    UIButton *lastButton;
}

@end

@implementation MallOrderBuyDetail_VC
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
        case 1:
            lastButton = [Tools buttonWithFrame:CGRectMake(20, 100 - 20*(self.goodsModel.status - 1), kScreenW - 40, 38) withTitle:@"立即付款"];
            self.tableView.tableFooterView = footerView;
            if ([self.goodsModel.waitPayType isEqualToString:@"等待主账号付款"]) {
                lastButton.hidden = YES;
            }
            break;
        case 3:
            lastButton = [Tools buttonWithFrame:CGRectMake(20, 100 - 20*(self.goodsModel.status - 1), kScreenW - 40, 38) withTitle:@"确认收货"];
            self.tableView.tableFooterView = footerView;
            break;
        case 4:
            if ([self.goodsModel.comment isEqualToString:@"2"]) {
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
        cell.changeStatus.tag = 222 + indexPath.section;
        
        [cell.changeStatus setTitle:@"联系卖家" forState:UIControlStateNormal];
        [cell.changeStatus addTarget:self action:@selector(actionOfStatus:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if (indexPath.section == 1) {
        MallOrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:mallAddressCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.personName.text = [NSString stringWithFormat:@"收货人：%@", self.goodsModel.personName];
        cell.personPhoneNumber.text = [NSString stringWithFormat:@"电话：%@", self.goodsModel.personPhone];
        CGSize size = [Tools getSize:[NSString stringWithFormat:@"收货地址：%@", self.goodsModel.personAddress] andFontOfSize:12 andWidthMake:kScreenW - 60];
        cell.personAddress.frame = CGRectMake(45, CGRectGetMaxY(cell.personName.frame) + 5, kScreenW - 60, size.height);
        cell.addressView.frame = CGRectMake(10, (45 + size.height - 25)/2, 25, 25);
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
        CGSize size = [Tools getSize:[NSString stringWithFormat:@"收货地址：%@", self.goodsModel.personAddress] andFontOfSize:12 andWidthMake:kScreenW - 60];
        return 45 + size.height;
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
- (void)actionOfStatus:(UIButton *)button {
    //统计聊天
    [HttpClient statisticsWithKey:@"IMChat" withUid:self.goodsModel.sellerUserId andBlock:^(NSInteger statusCode) {
        DLog(@"------------%ld--------------", statusCode);
    }];
    // 聊天
    //解析工厂信息
    [HttpClient getOtherIndevidualsInformationWithUserID:self.goodsModel.sellerUserId WithCompletionBlock:^(NSDictionary *dictionary) {
        OthersUserModel *otherModel = (OthersUserModel *)dictionary[@"message"];
        IMChatViewController *conversationVC = [[IMChatViewController alloc]init];
        conversationVC.conversationType = ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        conversationVC.targetId = self.goodsModel.sellerUserId; // 接收者的 targetId，这里为举例。
        conversationVC.title = otherModel.name; // 会话的 title。
        conversationVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController.navigationBar setHidden:NO];
        [self.navigationController pushViewController:conversationVC animated:YES];
    }];
}

- (void)actionOfLastButton:(UIButton *)button {
    switch (self.goodsModel.status) {
        case 1: {
            DLog(@"付款");
            MallOrderPay_VC *mallOrderPayVC = [[MallOrderPay_VC alloc] initWithStyle:UITableViewStyleGrouped];
            mallOrderPayVC.isMeMallOrder = YES;
            mallOrderPayVC.mallPurchseId = self.goodsModel.orderNumber;
            [self.navigationController pushViewController:mallOrderPayVC animated:YES];
        }
            break;
        case 3: {
            DLog(@"确认收货");
            button.userInteractionEnabled = NO;
            [HttpClient buyerReceiveGoodsFromSellerWithPurchaseId:self.goodsModel.orderNumber WithBlock:^(NSDictionary *dictionary) {
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
        }
            break;
        case 4: {
            DLog(@"立即评价");
            MallOrderMark_VC *mallMarkVC = [[MallOrderMark_VC alloc] initWithStyle:UITableViewStyleGrouped];
            mallMarkVC.isBuyHistory = YES;
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
        ApplicationDelegate.mallStatus = @"4";
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)phoneCall {
    NSString *str = @"telprompt://4006400391";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end
