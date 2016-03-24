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
    self.tableView.rowHeight = 80;
    [self.tableView registerClass:[PopularNewsType_Cell class] forCellReuseIdentifier:typeCellIndetifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
    photoArray = @[@"PopularNews-男装", @"PopularNews-女装", @"PopularNews-童装", @"PopularNews-面料", @"PopularNews-行业", @"PopularNews-娱乐", @"PopularNews-设计师", @"PopularNews-吐槽"];
    titleArray = @[@"男装", @"女装", @"童装", @"面料", @"行业", @"娱乐", @"设计师", @"吐槽"];
    detailArray = @[@"在北京市西城区的文昌胡同深处，一间小小的、不起眼的、甚至杂草丛生，可以说有点破败的房子，刚刚卖出了相当于20公斤黄金的价格", @"确切地说，这处仅仅11.4平米的房产，卖出了530万元人民币的天价，每平米房价达到46万元人民币。", @"卖出如此高价的原因，就因为它是北京最著名的小学之一实验二小的学区房。46万的单价，也创造了北京最贵学区房的记录", @"不知道这个记录可以保持多久，也不知道这个买家是有钱任性，还是咬紧牙关勒紧裤腰带", @"我们知道的是，只有教育资源的不均衡才能助长学区房的疯狂。这个问题不彻底解决，房价只能有更贵，没有最贵，有关学区房的故事也就不会有结尾", @"陈女内穿紧身裤，但裤里面夹藏新台币500元及100元钞现金，总计共140万元", @"但不得不说，抛开性能、拍照不谈，单纯比拼手机的“耐操”程度，Galaxy S7还是略胜iPhone 6S一筹", @"值得一提的是，从沸水中拿出来之后，iPhone 6S已经无法开机了，而Galaxy S7却可以正常使用"];
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
