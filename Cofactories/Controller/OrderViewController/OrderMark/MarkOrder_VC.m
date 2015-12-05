//
//  MarkOrder_TVC.m
//  Cofactories
//
//  Created by GTF on 15/12/5.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MarkOrder_VC.h"

@interface MarkOrder_VC ()

@end
static NSString *const reuseIdentifier = @"reuseIdentifier";
@implementation MarkOrder_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评分";
    self.tableView.rowHeight = 100;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW/2.f)];
    headerView.backgroundColor = [UIColor redColor];
    self.tableView.tableHeaderView = headerView;
    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 80)];
    
    UIButton *markButton = [UIButton buttonWithType:UIButtonTypeCustom];
    markButton.frame = CGRectMake(20, 30, kScreenW-40, 40);
    markButton.backgroundColor = MAIN_COLOR;
    markButton.layer.masksToBounds = YES;
    markButton.layer.cornerRadius = 5;
    [markButton setTitle:@"提交评价" forState:UIControlStateNormal];
    markButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [markButton addTarget:self action:@selector(markClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:markButton];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)markClick{
    switch (_markOrderType) {
        case MarkOrderType_Supplier:
            DLog(@"11111");
            break;
        case MarkOrderType_Factory:
            DLog(@"22222");
            break;
        case MarkOrderType_Design:
            DLog(@"33333");
            break;
        default:
            break;
    }
}

@end
