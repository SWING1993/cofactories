//
//  ZGYDesignMarkrtController.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "ZGYDesignMarkrtController.h"
#import "PopularMessageController.h"
#import "ZGYSupplyMarketView.h"
#import "AllDesignController.h"
#import "UMSocial.h"
#import "DesignShop_VC.h"
#import "PopularNews_VC.h"

@interface ZGYDesignMarkrtController ()<ZGYSupplyMarketViewDelegate, UMSocialUIDelegate>
@property(nonatomic,strong)UserModel *userModel;
@end

@implementation ZGYDesignMarkrtController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设计市场";
    
    self.view.backgroundColor = [UIColor colorWithRed:251.0f/255.0f green:252.0f/255.0f blue:253.0f/255.0f alpha:1.0f];
    NSArray *photoArray = @[@"Market-流行资讯.jpg", @"Market-设计者汇总.jpg", @"Market-版型购买.jpg"];
    NSArray *titleArray = @[@"时尚资讯", @"设计师集中营", @"版型聚集地"];
    NSArray *detailTitleArray = @[@"最全流行资讯聚集地", @"最全潮流设计师聚集地", @"最全版型聚集地"];
    ZGYSupplyMarketView *designView = [[ZGYSupplyMarketView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 370) photoArray:photoArray titleArray:titleArray detailTitleArray:detailTitleArray];
    designView.delegate = self;
    [self.view addSubview:designView];
    if (!self.userModel) {
        self.userModel = [[UserModel alloc] getMyProfile];
    }

}
#pragma mark - ZGYSupplyMarketViewDelegate

- (void)supplyMarketView:(ZGYSupplyMarketView *)supplyMarketView supplyMarketButtonTag:(NSInteger)supplyMarketButtonTag {
    switch (supplyMarketButtonTag) {
        case 0:{
//            PopularMessageController *popularVC = [[PopularMessageController alloc] init];
//            [self.navigationController pushViewController:popularVC animated:YES];
            PopularNews_VC *popularNewsVC = [[PopularNews_VC alloc] init];
            [self.navigationController pushViewController:popularNewsVC animated:YES];

        }
            break;
        case 1:{
            AllDesignController *allDesignVC = [[AllDesignController alloc] initWithSelecteDataDictionary:[Tools returenSelectDataDictionaryWithIndex:1]];
            [self.navigationController pushViewController:allDesignVC animated:YES];
            
        }
            break;
        case 2:{
            DesignShop_VC *designShopVC = [[DesignShop_VC alloc] initWithSubrole:@"设计者" andSelecteDataDictionary:[Tools goodsSelectDataDictionaryWithIndex:4]];
            [self.navigationController pushViewController:designShopVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
