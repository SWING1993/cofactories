//
//  SearchNews_List_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/3/23.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "SearchNews_List_VC.h"
#import "PopularNews_Cell.h"
#import "MJRefresh.h"
#import "PopularNewsModel.h"
#import "PopularNews_Detail_VC.h"
static NSString *newsCellIdentifier = @"newsCell";
@interface SearchNews_List_VC ()

@end

@implementation SearchNews_List_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"搜索结果";
    self.tableView.rowHeight = 135*kZGY;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[PopularNews_Cell class] forCellReuseIdentifier:newsCellIdentifier];
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
    return self.searchNewsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopularNews_Cell *cell = [tableView dequeueReusableCellWithIdentifier:newsCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PopularNewsModel *popularNewsModel = self.searchNewsArray[indexPath.row];
    [cell reloadDataWithPopularNewsModel:popularNewsModel];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"进入文章详情页");
    PopularNewsModel *newsModel = self.searchNewsArray[indexPath.row];
    PopularNews_Detail_VC *detailVC = [[PopularNews_Detail_VC alloc] init];
    detailVC.popularNewsModel = newsModel;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

@end
