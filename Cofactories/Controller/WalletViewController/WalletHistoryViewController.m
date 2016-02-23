//
//  WalletHistoryViewController.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//
#import "TableViewHeaderView.h"
#import "MJRefresh.h"
#import "WalletHistoryModel.h"
#import "WalletHistoryViewController.h"
#import "WalletHistoryTableViewCell.h"
#import "WalletHistoryInfoViewController.h"

static NSString * const CellIdentifier = @"CellIdentifier";

@interface WalletHistoryViewController () {
    NSInteger        _refrushCount;
    UILabel * footerLabel;
}


@property (nonatomic,retain)WalletHistoryModel * model;

@property (nonatomic,retain)NSMutableArray * modelArray;

@end

@implementation WalletHistoryViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _refrushCount = 1;
    self.modelArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.tableView = [[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 70.0f;
    
  
    
    footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    footerLabel.text = @"没有更多数据";
    footerLabel.font = kFont;
    footerLabel.textColor = [UIColor grayColor];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    
    [self setupRefresh];
    
    [HttpClient walletHistoryWithPage:@1 WithBlock:^(NSDictionary *responseDictionary) {
        NSInteger statusCode = [[responseDictionary objectForKey:@"statusCode"]integerValue];
        if (statusCode == 200) {
            self.modelArray = [[responseDictionary objectForKey:@"ModelArray"] mutableCopy];
            DLog(@"第一页有%lu条数据",(unsigned long)[self.modelArray count]);
            if (self.modelArray.count < 20) {
                if (self.modelArray.count == 0) {
                    TableViewHeaderView * view = [[TableViewHeaderView alloc]initWithFrame:kScreenBounds withImage:@"数据暂无2" withLabelText:@"暂无数据"];
                    self.tableView.backgroundView = view;
                }else {
                    self.tableView.tableFooterView = footerLabel;
                }
            }
            [self.tableView reloadData];
        }
        else if (statusCode == 0) {
            kTipAlert(@"网络暂无连接");
        }
        else {
            NSString * message = [responseDictionary objectForKey:@"message"];
            kTipAlert(@"%@(错误状态码：%ld)",message,(long)statusCode);
        }
    }];
}

#pragma mark - MJRefesh

- (void)setupRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"加载中。。。";
}

- (void)footerRereshing
{
    _refrushCount++;
    DLog(@"加载第%ld页",(long)_refrushCount);
    NSNumber * pageNumber = [[NSNumber alloc]initWithInteger:_refrushCount];
    [HttpClient walletHistoryWithPage:pageNumber WithBlock:^(NSDictionary *responseDictionary) {
        NSInteger statusCode = [[responseDictionary objectForKey:@"statusCode"]integerValue];
        if (statusCode == 200) {
            NSArray *array = [[responseDictionary objectForKey:@"ModelArray"] mutableCopy];
            DLog(@"第%lu页有%lu条数据",(long)_refrushCount,(unsigned long)[array count]);
            if ([array count] == 0) {
                DLog(@"共有%lu条数据",(unsigned long)[self.modelArray count]);
                self.tableView.tableFooterView = footerLabel;
            }else {
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    WalletHistoryModel *model = array[idx];
                    [self.modelArray addObject:model];
                }];
                DLog(@"共有%lu条数据",(unsigned long)[self.modelArray count]);
                [self.tableView reloadData];
            }
        }
        else {
            NSString * message = [responseDictionary objectForKey:@"message"];
            kTipAlert(@"%@(错误码：%ld)",message,(long)statusCode);
        }
    }];
    [self.tableView footerEndRefreshing];
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
        DLog(@"^^^^^^%@", model.type);
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
