//
//  IMChatListViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/10/14.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "IMChatListViewController.h"
#import "IMChatViewController.h"

@interface IMChatListViewController ()

@end

@implementation IMChatListViewController


//重载函数，onSelectedTableRow 是选择会话列表之后的事件，该接口开放是为了便于您自定义跳转事件。
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    IMChatViewController *conversationVC = [[IMChatViewController alloc]init];
    conversationVC.conversationType =model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.userName =model.conversationTitle;
    conversationVC.title = model.conversationTitle;
    
    conversationVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
    //self.emptyConversationView.userInteractionEnabled = YES;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.conversationListTableView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
    [self updateBadgeValueForTabBarItem];
}

/*
 * 如果原 TableView 和 SearchDisplayController 中的 TableView 的 delete 指向同一个对象
 * 需要在回调中区分出当前是哪个 TableView
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //设置tableView样式
    self.conversationListTableView.tableFooterView = [UIView new];
      
}
- (void)updateBadgeValueForTabBarItem
{
    __weak IMChatListViewController *IMSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
        if (count>0) {
            IMSelf.tabBarController.viewControllers[2].tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",count];
        } else {
            IMSelf.tabBarController.viewControllers[2].tabBarItem.badgeValue = nil;
        }
    });
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
