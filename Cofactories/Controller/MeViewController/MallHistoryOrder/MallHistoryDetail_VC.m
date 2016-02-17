//
//  MallHistoryDetail_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/2/17.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallHistoryDetail_VC.h"
#import "MallHistoryOrderCell.h"
#import "MallOrderAddressCell.h"
#import "MallOrderStatusCell.h"
#import "IMChatViewController.h"

static NSString *mallGoodsCellIdentifier = @"mallGoodsCell";
static NSString *mallAddressCellIdentifier = @"mallAddressCell";
static NSString *mallStatusCellIdentifier = @"mallStatusCell";
@interface MallHistoryDetail_VC ()

@end

@implementation MallHistoryDetail_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[MallHistoryOrderCell class] forCellReuseIdentifier:mallGoodsCellIdentifier];
    [self.tableView registerClass:[MallOrderAddressCell class] forCellReuseIdentifier:mallAddressCellIdentifier];
    [self.tableView registerClass:[MallOrderStatusCell class] forCellReuseIdentifier:mallStatusCellIdentifier];
    
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        cell.goodsStatus.text = self.goodsModel.waitPayType;
        if (self.goodsModel.photoArray.count > 0) {
            NSString* encodedString = [[NSString stringWithFormat:@"%@%@", PhotoAPI, self.goodsModel.photoArray[0]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [cell.photoView sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"默认图片"]];
        } else {
            cell.photoView.image = [UIImage imageNamed:@"默认图片"];
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
        cell.personName.text = [NSString stringWithFormat:@"收货人：%@", self.goodsModel.personName];
        cell.personPhoneNumber.text = [NSString stringWithFormat:@"电话：%@", self.goodsModel.personPhone];
        cell.personAddress.text = [NSString stringWithFormat:@"收货地址：%@", self.goodsModel.personAddress];
        return cell;
    } else {
        MallOrderStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:mallStatusCellIdentifier forIndexPath:indexPath];
        cell.creatTime.text = [NSString stringWithFormat:@"创建时间：%@", self.goodsModel.creatTime];
        cell.orderNum.text = [NSString stringWithFormat:@"订单编号：%@", self.goodsModel.orderNumber];
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
        return 80;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}
- (void)actionOfStatus:(UIButton *)button {
    // 聊天
    //解析工厂信息
    [HttpClient getOtherIndevidualsInformationWithUserID:self.goodsModel.userId WithCompletionBlock:^(NSDictionary *dictionary) {
        OthersUserModel *otherModel = (OthersUserModel *)dictionary[@"message"];
        IMChatViewController *conversationVC = [[IMChatViewController alloc]init];
        conversationVC.conversationType = ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        conversationVC.targetId = self.goodsModel.userId; // 接收者的 targetId，这里为举例。
        conversationVC.title = otherModel.name; // 会话的 title。
        conversationVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController.navigationBar setHidden:NO];
        [self.navigationController pushViewController:conversationVC animated:YES];
    }];

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
