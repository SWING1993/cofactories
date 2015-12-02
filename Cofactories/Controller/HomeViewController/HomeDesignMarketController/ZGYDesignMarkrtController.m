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
#import "IMChatViewController.h"
@interface ZGYDesignMarkrtController ()<ZGYSupplyMarketViewDelegate>
@property(nonatomic,strong)UserModel *userModel;
@end

@implementation ZGYDesignMarkrtController

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设计市场";
    
    self.view.backgroundColor = [UIColor colorWithRed:251.0f/255.0f green:252.0f/255.0f blue:253.0f/255.0f alpha:1.0f];
    NSArray *photoArray = @[@"3.jpg", @"4.jpg", @"5.jpg"];
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
            IMChatViewController *conversationVC = [[IMChatViewController alloc]init];
            conversationVC.conversationType = ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
            conversationVC.targetId = @"4"; // 接收者的 targetId，这里为举例。
            conversationVC.userName = @"IVERSON"; // 接受者的 username，这里为举例。
            conversationVC.title = @"IVERSON"; // 会话的 title。
            conversationVC.hidesBottomBarWhenPushed=YES;
            // 把单聊视图控制器添加到导航栈。
//            UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
//            backItem.title=@"返回";
//            self.navigationItem.backBarButtonItem = backItem;
            [self.navigationController.navigationBar setHidden:NO];
            [self.navigationController pushViewController:conversationVC animated:YES];
        }
            break;
        case 1:{
            PopularMessageController *popularVC = [[PopularMessageController alloc] init];
            [self.navigationController pushViewController:popularVC animated:YES];
        }
            break;
        case 2:{
            
        }
            break;
        default:
            break;
    }
    DLog(@"第 %ld 个", supplyMarketButtonTag + 1);
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