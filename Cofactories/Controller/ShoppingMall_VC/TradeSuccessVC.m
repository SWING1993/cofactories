//
//  TradeSuccessVC.m
//  Cofactories
//
//  Created by 赵广印 on 16/4/14.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "TradeSuccessVC.h"
#import "MallOrderBuyDetail_VC.h"

#define kTopViewHeight 250

@interface TradeSuccessVC ()

@end

@implementation TradeSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.orderTitle;
    [self creatTopView];
    [self creatbottomView];

}

- (void)creatTopView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kTopViewHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    CGSize size = [Tools getSize:self.orderTitle andFontOfSize:20];
    CGFloat width = size.width;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenW - width)/2, 40, width, 35)];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.text = self.orderTitle;
    titleLabel.textColor = kMainLightBlueColor;
    [topView addSubview:titleLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), 75, width, 35)];
    priceLabel.font = [UIFont boldSystemFontOfSize:20];
    priceLabel.text = [NSString stringWithFormat:@"¥ %@", self.totalPrice];
    priceLabel.textColor = kMainLightBlueColor;
    [topView addSubview:priceLabel];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), 110, width, 35)];
    statusLabel.font = [UIFont systemFontOfSize:12];
    statusLabel.textColor = [UIColor darkGrayColor];
    statusLabel.text = self.status;
    [topView addSubview:statusLabel];
    
    UIImageView *successImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame) - 30, 45, 20, 20)];
    successImage.image = [UIImage imageNamed:@"Mall_tradeSuccess"];
    [topView addSubview:successImage];
    
    CALayer *line1 = [CALayer layer];
    line1.frame = CGRectMake(CGRectGetMinX(successImage.frame) + 9.5, CGRectGetMaxY(successImage.frame), 1, 30);
    line1.backgroundColor = kMainLightBlueColor.CGColor;
    [topView.layer addSublayer:line1];
    
    CALayer *line2 = [CALayer layer];
    line2.frame = CGRectMake(CGRectGetMinX(successImage.frame) + 9.5, CGRectGetMaxY(line1.frame), 1, 30);
    line2.backgroundColor = kLineGrayCorlor.CGColor;
    [topView.layer addSublayer:line2];
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(successImage.frame) + 7.5, CGRectGetMaxY(line2.frame), 5, 5)];
    myView.layer.cornerRadius = 2.5;
    myView.clipsToBounds = YES;
    myView.backgroundColor = kLineGrayCorlor;
    [topView addSubview:myView];
    
}
- (void)creatbottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopViewHeight, kScreenW, kScreenH - kTopViewHeight)];
    bottomView.backgroundColor = GRAYCOLOR(239);
    [self.view addSubview:bottomView];
    
    UIButton *orderDetail = [Tools buttonWithFrame:CGRectMake(15, 50, kScreenW - 30, 35) withTitle:@"订单详情"];
    [orderDetail addTarget:self action:@selector(actionOfOrderDetail:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:orderDetail];
    
    UIButton *goMall = [Tools buttonWithFrame:CGRectMake(15, 100, kScreenW - 30, 35) withTitle:@"继续购物"];
    goMall.backgroundColor = [UIColor whiteColor];
    [goMall setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goMall addTarget:self action:@selector(actionOfGoMall:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:goMall];
    
    
}

- (void)actionOfOrderDetail:(UIButton *)button {
    //去订单详情页
    [button addShakeAnimation];
    [HttpClient getMallOrderDetailWithPurchseId:self.purchaseId WithBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        if (statusCode == 200) {
            MallBuyHistoryModel *goodsModel = [MallBuyHistoryModel getMallBuyHistorymodelWithDictionary:dictionary[@"data"]];
            MallOrderBuyDetail_VC *mallDetailVC = [[MallOrderBuyDetail_VC alloc] initWithStyle:UITableViewStyleGrouped];
            mallDetailVC.goodsModel = goodsModel;
            [self.navigationController pushViewController:mallDetailVC animated:YES];
        } else {
            kTipAlert(@"%@",[dictionary objectForKey:@"message"]);
        }
    }];
}

- (void)actionOfGoMall:(UIButton *)button {
    //继续购物
    [button addShakeAnimation];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
