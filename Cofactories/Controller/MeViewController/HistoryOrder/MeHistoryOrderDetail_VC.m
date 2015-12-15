//
//  MeHistoryOrderDetail_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/15.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "MeHistoryOrderDetail_VC.h"
#import "HistoryOrderListCell.h"
#import "HistoryOrderAddressCell.h"

static NSString *orderDetailCellIdentifier = @"orderDetailCell";
static NSString *addressCellIdentifier = @"addressCell";
@interface MeHistoryOrderDetail_VC ()

@end

@implementation MeHistoryOrderDetail_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[HistoryOrderListCell class] forCellReuseIdentifier:orderDetailCellIdentifier];
    [self.tableView registerClass:[HistoryOrderAddressCell class] forCellReuseIdentifier:addressCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
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
        HistoryOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:orderDetailCellIdentifier forIndexPath:indexPath];
        cell.timeLabel.text = @"2015-12-09";
        cell.photoView.image = [UIImage imageNamed:@"4.jpg"];
        cell.orderTitleLabel.text = @"太空棉布料面料";
        cell.categoryLabel.text = @"分类：蓝色*半米";
        cell.priceLabel.text = @"￥19.80";
        cell.numberLabel.text = @"X3";
        cell.totalPriceLabel.text = @"共3件商品 合计：59.40";
        return cell;
    } else if (indexPath.section == 1) {
        HistoryOrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCellIdentifier forIndexPath:indexPath];
        cell.personName.text = @"收货人：朕真帅啊";
        cell.personPhoneNumber.text = @"157****6409";
        cell.personAddress.text = @"收货地址：浙江省 杭州市 江干区 白杨街道 下沙**************号楼";
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 110;
    } else if (indexPath.section == 1) {
        return 100;
    } else {
        return 60;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
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
