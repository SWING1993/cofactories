//
//  IMSearchResult_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/3/28.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "IMSearchResult_VC.h"
#import "IMSearchResultCell.h"
#import "PersonalMessage_Clothing_VC.h"
#import "IMChatViewController.h"
#import "IMSearchResultModel.h"

static NSString *seachResultCellIdentifier = @"seachResultCell";
@interface IMSearchResult_VC ()

@end

@implementation IMSearchResult_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[IMSearchResultCell class] forCellReuseIdentifier:seachResultCellIdentifier];
    self.tableView.rowHeight = 90;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IMSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:seachResultCellIdentifier forIndexPath:indexPath];
    IMSearchResultModel *model = self.searchResultArray[indexPath.row];
    [cell layoutSomeDataWithMarketModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 聊天
    IMSearchResultModel *model = self.searchResultArray[indexPath.row];
    [_delegate IMSearchResult_VC:self myModel:model];

}

@end
