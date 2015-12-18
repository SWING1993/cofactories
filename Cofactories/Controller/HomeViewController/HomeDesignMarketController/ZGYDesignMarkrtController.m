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


@interface ZGYDesignMarkrtController ()<ZGYSupplyMarketViewDelegate, UMSocialUIDelegate>
@property(nonatomic,strong)UserModel *userModel;
@end

@implementation ZGYDesignMarkrtController

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设计市场";
    
    self.view.backgroundColor = [UIColor colorWithRed:251.0f/255.0f green:252.0f/255.0f blue:253.0f/255.0f alpha:1.0f];
    NSArray *photoArray = @[@"Market-版型购买", @"Market-流行资讯", @"Market-设计者汇总"];
    NSArray *titleArray = @[@"版型购买", @"流行资讯", @"设计者汇总"];
    NSArray *detailTitleArray = @[@"最全版型聚集地", @"最全流行资讯聚集地", @"最全潮流设计师聚集地"];
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
//            DesignShop_VC *designShopVC = [[DesignShop_VC alloc] initWithSubrole:@"设计者" andSelecteDataDictionary:[Tools goodsSelectDataDictionaryWithIndex:4]];
//            [self.navigationController pushViewController:designShopVC animated:YES];
            
            //分享多个
            [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://baidu.com";//微信好友
            [UMSocialData defaultData].extConfig.wechatSessionData.title = @"微信好友title";
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://baidu.com";//微信朋友圈
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"微信朋友圈title";
            [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";//QQ好友
            [UMSocialData defaultData].extConfig.qqData.title = @"QQ分享title";
            
            [UMSocialData defaultData].extConfig.qzoneData.url = @"http://baidu.com";//QQ空间
            [UMSocialData defaultData].extConfig.qzoneData.title = @"Qzone分享title";
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"55e03514e0f55a390f003db7"
                                              shareText:@"来自聚工厂的分享"
                                             shareImage:[UIImage imageNamed:@"5.jpg"]
                                        shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone]
                                               delegate:self];
        }
            break;
        case 1:{
            PopularMessageController *popularVC = [[PopularMessageController alloc] init];
            [self.navigationController pushViewController:popularVC animated:YES];
        }
            break;
        case 2:{
            AllDesignController *allDesignVC = [[AllDesignController alloc] initWithSelecteDataDictionary:[Tools returenSelectDataDictionaryWithIndex:1]];
            [self.navigationController pushViewController:allDesignVC animated:YES];
        }
            break;
        default:
            break;
    }
    DLog(@"第 %d 个", supplyMarketButtonTag + 1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
