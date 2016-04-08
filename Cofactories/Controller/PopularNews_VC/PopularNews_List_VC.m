//
//  PopularNews_List_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/3/8.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "PopularNews_List_VC.h"
#import "PopularNews_Cell.h"
#import "MJRefresh.h"
#import "PopularNewsModel.h"
#import "PopularNews_Detail_VC.h"

static NSString *newsCellIdentifier = @"newsCell";
@interface PopularNews_List_VC () {
    NSInteger page;
}
@property (nonatomic, strong) NSMutableArray *newsArray;

@end

@implementation PopularNews_List_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"%@文章", self.newsCategory];
    self.tableView.rowHeight = 135*kZGY;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[PopularNews_Cell class] forCellReuseIdentifier:newsCellIdentifier];
    page = 1;
    [self netWork];
    [self setupRefresh];
}

- (void)setupRefresh{
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"加载中...";
}
- (void)footerRereshing{
    page++;
    [self netWork];
    [self.tableView footerEndRefreshing];
}
- (void)netWork {
    [HttpClient getPopularNewsListWithCategory:self.newsCategory page:@(page) withBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        if (statusCode == 200) {
            if (page == 1) {
                self.newsArray = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *newsDic in dictionary[@"data"]) {
                    PopularNewsModel *newsModel = [PopularNewsModel getPopularNewsModelWithDictionary:newsDic];
                    [self.newsArray addObject:newsModel];
                }
            } else if (page > 1) {
                for (NSDictionary *newsDic in dictionary[@"data"]) {
                    PopularNewsModel *newsModel = [PopularNewsModel getPopularNewsModelWithDictionary:newsDic];
                    [self.newsArray addObject:newsModel];
                }
            }
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopularNews_Cell *cell = [tableView dequeueReusableCellWithIdentifier:newsCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PopularNewsModel *popularNewsModel = self.newsArray[indexPath.row];
    [cell reloadDataWithPopularNewsModel:popularNewsModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"进入文章详情页");
    PopularNewsModel *newsModel = self.newsArray[indexPath.row];
    PopularNews_Detail_VC *detailVC = [[PopularNews_Detail_VC alloc] init];
    detailVC.popularNewsModel = newsModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
