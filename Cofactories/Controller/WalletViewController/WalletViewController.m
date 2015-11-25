//
//  WalletViewController.m
//  Cofactories
//
//  Created by GTF on 15/11/18.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "WalletViewController.h"
#import "HttpClient.h"
#import "RechargeViewController.h"
@interface WalletViewController () {
    NSArray *titleArray;
}

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatTableView];
    titleArray = @[@"账户余额", @"充值", @"余额转出(提现)"];

}


- (void)creatTableView {
    self.walletTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 44)style:UITableViewStyleGrouped];
    self.walletTableView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
    self.walletTableView.delegate = self;
    self.walletTableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = YES;// 自动调整视图关闭
    self.walletTableView.showsVerticalScrollIndicator = NO;// 竖直滚动条不显示
    [self.view addSubview:self.walletTableView];
    
        
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font=[UIFont systemFontOfSize:14.5];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    if (indexPath.section == 0) {
        cell.textLabel.text = titleArray[indexPath.row];
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"100.00元";
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    } else {
        cell.textLabel.text = @"查看明细";
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            //充值
            RechargeViewController *rechargeVC = [[RechargeViewController alloc] init];
            rechargeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:rechargeVC animated:YES];
            
            
        } else if (indexPath.row == 2) {
            //余额转出
        }
    } else if (indexPath.section == 1) {
        //查看明细
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
