//
//  IMChatViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/10/15.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "IMChatViewController.h"
#import "IQKeyboardManager.h"

@interface IMChatViewController () {
//    FactoryModel  *_userModel;
}

@end

@implementation IMChatViewController {
    BOOL _wasKeyboardManagerEnabled;

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:_wasKeyboardManagerEnabled];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.pluginBoardView removeItemAtIndex:2];
    [self notifyUpdateUnreadMessageCount];
    self.enableNewComingMessageIcon = YES;
}





//- (void)didTapCellPortrait:(NSString *)userId {
//    NSNumber *uid = (NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:@"selfuid"];
//    if ([[NSString stringWithFormat:@"%@", uid] isEqualToString:userId]) {
//        DLog(@"自己的uid = %@", userId);
//    } else {
//        DLog(@"对方的uid = %@", userId);
//        //解析工厂信息
//        [Tools showLoadString:@"获取资料中..."];
//        [HttpClient getUserProfileWithUid:[userId intValue] andBlock:^(NSDictionary *responseDictionary) {
//            _userModel = (FactoryModel *)responseDictionary[@"model"];
//            [Tools WSProgressHUDDismiss];
//            CooperationInfoViewController *vc = [CooperationInfoViewController new];
//            vc.factoryModel = _userModel;
//            vc.IMFlag = YES;
//            UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
//            backItem.title=@"返回";
//            self.navigationItem.backBarButtonItem = backItem;
//            [self.navigationController.navigationBar setHidden:NO];
//            [self.navigationController pushViewController:vc animated:YES];
//            
//        }];
//
//    }
//    
//}

/**
 *  更新左上角未读消息数
 */
- (void)notifyUpdateUnreadMessageCount {
    __weak typeof(&*self) __weakself = self;
    int count = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                @(ConversationType_PRIVATE),
                                                                @(ConversationType_DISCUSSION),
                                                                @(ConversationType_APPSERVICE),
                                                                @(ConversationType_PUBLICSERVICE),
                                                                @(ConversationType_GROUP)
                                                                ]];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *backString = nil;
        if (count > 0 && count < 1000) {
            backString = [NSString stringWithFormat:@"消息(%d)", count];
        } else if (count >= 1000) {
            backString = @"消息(...)";
        } else {
            backString = @"消息";
        }
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 6, 87, 23);
        UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigator_btn_back"]];
        backImg.frame = CGRectMake(-10, 0, 22, 22);
        [backBtn addSubview:backImg];
        UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 85, 22)];
        backText.text = backString;//NSLocalizedStringFromTable(@"Back", @"RongCloudKit", nil);
        backText.font = [UIFont systemFontOfSize:15];
        [backText setBackgroundColor:[UIColor clearColor]];
        [backText setTextColor:[UIColor whiteColor]];
        [backBtn addSubview:backText];
        [backBtn addTarget:__weakself action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        [__weakself.navigationItem setLeftBarButtonItem:leftButton];
    });
}


- (void)leftBarButtonItemPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
