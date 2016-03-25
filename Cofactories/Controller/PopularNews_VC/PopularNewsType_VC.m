//
//  PopularNewsType_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/3/8.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "PopularNewsType_VC.h"
#import "PopularNewsType_Cell.h"
#import "PopularNews_List_VC.h"

static NSString *typeCellIndetifier = @"typeCell";
@interface PopularNewsType_VC () {
    NSArray *titleArray, *detailArray, *photoArray;
}

@end

@implementation PopularNewsType_VC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"文章分类";
    self.tableView.rowHeight = 80*kZGY;
    [self.tableView registerClass:[PopularNewsType_Cell class] forCellReuseIdentifier:typeCellIndetifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
    photoArray = @[@"PopularNews-男装", @"PopularNews-女装", @"PopularNews-童装", @"PopularNews-面料", @"PopularNews-行业", @"PopularNews-娱乐", @"PopularNews-设计师", @"PopularNews-吐槽"];
    titleArray = @[@"男装", @"女装", @"童装", @"面料", @"行业", @"娱乐", @"设计师", @"吐槽"];
    detailArray = @[@"色彩预测、款式趋势、热销单品实拍、品牌订货会、系列大片直推", @"流行元素预测、时尚潮牌解析、品牌定会货、街拍潮流、电商TOP", @"随时观看国内外热销单品、款式细节、童装设计、潮流趋势预测", @"国际面料展会实况详情、面料工艺、色卡、设计细节", @"洞悉服装产业行情、品牌咨询访谈、财报、交易、焦点", @"原创设计师访谈、品牌解析、设计之家", @"明星时尚、娱乐星闻、奢侈品带动趋势", @"有病区、有病得知、没病找事、病例分析、一吐为快"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopularNewsType_Cell *cell = [tableView dequeueReusableCellWithIdentifier:typeCellIndetifier forIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.photoView.image = [UIImage imageNamed:photoArray[indexPath.row]];
    cell.typeLabel.text = titleArray[indexPath.row];
    cell.detailLabel.text = detailArray[indexPath.row];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"点击了%@", titleArray[indexPath.row]);
    PopularNews_List_VC *popularNewsListVC = [[PopularNews_List_VC alloc] init];
    popularNewsListVC.newsCategory = titleArray[indexPath.row];
    [self.navigationController pushViewController:popularNewsListVC animated:YES];
}

@end
