//
//  BidManage_Design_VC.m
//  Cofactories
//
//  Created by GTF on 15/12/5.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "BidManage_Design_VC.h"
#import "BidManage_Design_TVC.h"

@interface BidManage_Design_VC ()<UIAlertViewDelegate>{
    NSMutableArray  *_dataArray;
    NSMutableArray  *_buttonArray;
    NSInteger        _selectedIndex;
}


@end
static NSString *const reuseIdentifier = @"reuseIdentifier";
@implementation BidManage_Design_VC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [HttpClient getDesignOrderBidUserAmountWithOrderID:self.orderID WithCompletionBlock:^(NSDictionary *dictionary) {
        NSArray *responseArray = (NSArray *)dictionary[@"message"];
        _dataArray = [@[] mutableCopy];
        [responseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = (NSDictionary *)obj;
            BidManage_Design_Model *model = [BidManage_Design_Model getBidManage_Design_ModelWithDictionary:dic];
            [_dataArray addObject:model];
        }];
        DLog(@">>=%@",_dataArray);
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"投标管理";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认中标" style:UIBarButtonItemStylePlain target:self action:@selector(bidClick)];
    self.tableView.rowHeight = 160;
    _buttonArray = [@[] mutableCopy];}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BidManage_Design_TVC *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[BidManage_Design_TVC alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    BidManage_Design_Model *model = _dataArray[indexPath.row];
    [cell layoutDataWithModel:model];
    
    cell.selectButton.tag = indexPath.row;
    
    if (_selectedIndex == indexPath.row) {
        [cell.selectButton setTitle:@"已选" forState:UIControlStateNormal];
        cell.selectButton.backgroundColor = MAIN_COLOR;
    }else{
        [cell.selectButton setTitle:@"选择" forState:UIControlStateNormal];
        cell.selectButton.backgroundColor = [UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1];
    }
    
    [cell.selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)selectButtonClick:(UIButton *)button{
    _selectedIndex = button.tag;
    
    if (_buttonArray.count > 0) {
        UIButton *lastButton = [_buttonArray firstObject];
        [lastButton setTitle:@"选择" forState:UIControlStateNormal];
        lastButton.backgroundColor = [UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1];
    }
    
    
    [button setTitle:@"已选" forState:UIControlStateNormal];
    button.backgroundColor = MAIN_COLOR;
    [_buttonArray removeAllObjects];
    [_buttonArray addObject:button];
    
    [self.tableView reloadData];
    
    DLog(@"%d",_selectedIndex);
    
}

- (void)bidClick{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认让该用户中标" delegate:self cancelButtonTitle:@"再看看" otherButtonTitles:@"确定", nil];
    alert.tag = 10;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10) {
        
        if (buttonIndex == 1) {
            // 关闭订单
            BidManage_Design_Model *model = _dataArray[_selectedIndex];
            DLog(@"userID==%@",model.userID);
            
            [HttpClient closeDesignOrderWithOrderID:_orderID winnerUserID:model.userID WithCompletionBlock:^(NSDictionary *dictionary) {
                DLog(@"%@",dictionary);
                if ([dictionary[@"statusCode"] isEqualToString:@"200"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"订单完成" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                    alert.tag = 110;
                    [alert show];
                }else{
                    kTipAlert(@"操作失败请检查网络");
                }
            }];
        }
        
    }
    
    if (alertView.tag == 110) {
        if (buttonIndex == 0) {
            [self dismissViewControllerAnimated:YES completion:nil];

        }
    }
}


@end