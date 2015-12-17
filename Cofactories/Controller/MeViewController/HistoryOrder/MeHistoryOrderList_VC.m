//
//  MeHistoryOrderList_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/14.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MeHistoryOrderList_VC.h"
#import "HistoryOrderListCell.h"
#import "MeHistoryOrderDetail_VC.h"
#import "MeHistoryOrderModel.h"

static NSString *historyOrderCellIdentifier = @"historyCell";
@interface MeHistoryOrderList_VC ()

@property (nonatomic, strong) NSMutableArray *historyOrderArray;

@end

@implementation MeHistoryOrderList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"购买记录";
    [self.tableView registerClass:[HistoryOrderListCell class] forCellReuseIdentifier:historyOrderCellIdentifier];
    
    [HttpClient getMyGoodsBuyHistoryWithBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        self.historyOrderArray = [NSMutableArray arrayWithCapacity:0];
        if (statusCode == 200) {
            for (NSDictionary *myDic in dictionary[@"responseArray"]) {
                MeHistoryOrderModel *historyOrderModel = [MeHistoryOrderModel getMeHistoryOrderModelWithDictionary:myDic];
                [self.historyOrderArray addObject:historyOrderModel];
            }
            [self.tableView reloadData];
        } else {
            kTipAlert(@"请求失败");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.historyOrderArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:historyOrderCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MeHistoryOrderModel *historyOrderModel = self.historyOrderArray[indexPath.row];
    cell.timeLabel.text = historyOrderModel.creatTime;
    cell.payStatus.text = historyOrderModel.payType;
    if ([historyOrderModel.payType isEqualToString:@"已付款"]) {
        cell.payStatus.textColor = [UIColor greenColor];
    } else if ([historyOrderModel.payType isEqualToString:@"待付款"]) {
        cell.payStatus.textColor = [UIColor redColor];
    }
    if (historyOrderModel.photoArray.count > 0) {
        [cell.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PhotoAPI, historyOrderModel.photoArray[0]]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
    } else {
        cell.photoView.image = [UIImage imageNamed:@"默认图片"];
    }
    cell.orderTitleLabel.text = historyOrderModel.name;
    cell.categoryLabel.text = historyOrderModel.category;
    cell.priceLabel.text = historyOrderModel.price;
    cell.numberLabel.text = [NSString stringWithFormat:@"X%@", historyOrderModel.amount];
    cell.totalPriceLabel.text = [NSString stringWithFormat:@"共%@件商品 合计：%@", historyOrderModel.amount, historyOrderModel.totalPrice];
    return cell;
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MeHistoryOrderModel *myModel = self.historyOrderArray[indexPath.row];
    MeHistoryOrderDetail_VC *detailVC = [[MeHistoryOrderDetail_VC alloc] init];
    detailVC.orderModel = myModel;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"返回";
    backItem.tintColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:detailVC animated:YES];
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
