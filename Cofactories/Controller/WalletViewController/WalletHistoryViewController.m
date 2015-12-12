//
//  WalletHistoryViewController.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "WalletHistoryModel.h"
#import "WalletHistoryViewController.h"
#import "WalletHistoryTableViewCell.h"
#import "WalletHistoryInfoViewController.h"

@interface WalletHistoryViewController ()

@property (nonatomic,retain)WalletHistoryModel * model;

@property (nonatomic,retain)NSMutableArray * modelArray;

@end

@implementation WalletHistoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [HttpClient walletHistoryWithPage:@1 WithBlock:^(NSDictionary *responseDictionary) {
        NSInteger statusCode = [[responseDictionary objectForKey:@"statusCode"]integerValue];
        if (statusCode == 200) {
            self.modelArray = [[responseDictionary objectForKey:@"ModelArray"] mutableCopy];
            DLog(@"array count = %lu",(unsigned long)[self.modelArray count]);
            [self.tableView reloadData];
        }
        else {
            NSString * message = [responseDictionary objectForKey:@"message"];
            kTipAlert(@"%@(错误码：%ld)",message,(long)statusCode);
        }
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.modelArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.tableView = [[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 70.0f;
    
   }

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.modelArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WalletHistoryTableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[WalletHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier withRowSize:CGSizeMake(kScreenW, 80)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        WalletHistoryModel * model = [self.modelArray objectAtIndex:indexPath.row];
        cell.typeLabel.text = [NSString stringWithFormat:@"\n%@",model.type];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@\n",model.createdTime];
        
        if (model.fee>0) {
            cell.feeLabel.text = [NSString stringWithFormat:@"+%.2f 元",model.fee];
            cell.feeLabel.textColor = kGreen;
            //[UIColor colorWithRed:0.322 green:0.655 blue:0.184 alpha:1.000];
        }else {
            cell.feeLabel.text = [NSString stringWithFormat:@"%.2f 元",model.fee];
            cell.feeLabel.textColor = [UIColor redColor];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    return 5.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WalletHistoryInfoViewController * infoVC = [[WalletHistoryInfoViewController alloc]init];
        infoVC.title = @"明细详情";
        infoVC.model = self.modelArray[indexPath.row];
        [self.navigationController pushViewController:infoVC animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
