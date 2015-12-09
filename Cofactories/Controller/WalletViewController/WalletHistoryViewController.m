//
//  WalletHistoryViewController.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "WalletHistoryModel.h"
#import "WalletHistoryViewController.h"

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
            self.modelArray = [responseDictionary objectForKey:@"ModelArray"];
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
    
   }

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.modelArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.font=[UIFont systemFontOfSize:14.5];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"资金明细";
            }
            else if (indexPath.row == 1) {
                cell.textLabel.text = @"实名认证";
            }
        } else {
            cell.textLabel.text = @"关于钱包";
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 55;
    }
    return 5.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
