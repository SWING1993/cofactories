//
//  MallBuyHistory_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/1/30.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallBuyHistory_VC.h"
#import "MallHistoryOrderCell.h"

static NSString *mallBuyCellIdentifier = @"mallBuyCell";
@interface MallBuyHistory_VC ()<UITableViewDataSource, UITableViewDelegate> {
    UITableView *mallBuyTableView;
    UILabel         *lineLabel;
    NSMutableArray  *buttonArray;
}

@end

@implementation MallBuyHistory_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"购买交易";
    [self creatTableView];
    [mallBuyTableView registerClass:[MallHistoryOrderCell class] forCellReuseIdentifier:mallBuyCellIdentifier];
    [self creatHeaderView];
}

- (void)creatTableView {
    mallBuyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenW, kScreenH - 44)style:UITableViewStyleGrouped];
    mallBuyTableView.dataSource = self;
    mallBuyTableView.delegate = self;
    [self.view addSubview:mallBuyTableView];
    
}

- (void)creatHeaderView {
    NSArray *btnTitleArray = @[@"全部", @"待付款", @"待发货", @"待收货", @"待评价"];
    buttonArray = [NSMutableArray arrayWithCapacity:0];
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, 44)];
    headerView.backgroundColor=[UIColor whiteColor];
    for (int i = 0; i < 5; i++) {
        UIButton*typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typeBtn.frame = CGRectMake(i*(kScreenW/5), 0, kScreenW/5.f, 44);
        typeBtn.tag=i;
        typeBtn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        [typeBtn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [typeBtn setTitleColor:kDeepBlue forState:UIControlStateSelected];
        [typeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            typeBtn.selected = YES;
            lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeBtn.frame.origin.x + 5, 42, kScreenW/5 - 10, 2)];
            lineLabel.backgroundColor = kDeepBlue;
            [headerView addSubview:lineLabel];
        }
        
        [headerView addSubview:typeBtn];
        [buttonArray addObject:typeBtn];
        
        CALayer *line = [CALayer layer];
        line.frame = CGRectMake(0, 44 - 0.3, kScreenW, 0.3);
        line.backgroundColor = kLineGrayCorlor.CGColor;
        [headerView.layer addSublayer:line];
    }
    [self.view addSubview:headerView];
}

- (void)buttonClick:(UIButton *)button {
    button.selected = YES;
    for (UIButton *sunbBtn in buttonArray) {
        if (sunbBtn != button) {
            sunbBtn.selected = NO;
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        lineLabel.frame = CGRectMake(button.frame.origin.x + 5, 42, button.frame.size.width - 10, 2);
    }];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MallHistoryOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:mallBuyCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.goodsStatus.text = @"等待卖家付款";
    cell.photoView.image = [UIImage imageNamed:@"Market-流行资讯.jpg"];
    cell.goodsTitle.text = @"印花染布";
    cell.goodsPrice.text = @"¥ 28.00";
    cell.goodsCategory.text = @"分类：打板纸板";
    cell.goodsNumber.text = @"x10";
    cell.totalPrice.text = @"共10件商品 合计：¥ 280.00";
    [cell.changeStatus setTitle:@"联系商家" forState:UIControlStateNormal];
    [cell.changeStatus addTarget:self action:@selector(actionOfStatus:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 195;
}
- (CGFloat)tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"订单详情");
}

- (void)actionOfStatus:(UIButton *)button {
    DLog(@"*************");
    if ([button.titleLabel.text isEqualToString:@"联系商家"]) {
        DLog(@"hirhvgoirdjvfoljgvpor");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
