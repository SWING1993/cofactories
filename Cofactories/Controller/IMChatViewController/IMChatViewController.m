//
//  IMChatViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/10/15.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "IMChatViewController.h"
#import "IQKeyboardManager.h"
#import "PersonalMessage_Design_VC.h"
#import "PersonalMessage_Clothing_VC.h"
#import "PersonalMessage_Factory_VC.h"

@interface IMChatViewController ()

@property(nonatomic,strong)UserModel *userModel;

@end

@implementation IMChatViewController {
    BOOL _wasKeyboardManagerEnabled;

}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:65.0f/255.0f green:145.0f/255.0f blue:228.0f/255.0f alpha:1.0f];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:15],
                                     NSForegroundColorAttributeName: [UIColor whiteColor],
                                     };
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
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
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
                                     NSForegroundColorAttributeName: [UIColor blackColor],
                                     };
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.pluginBoardView removeItemAtIndex:2];
    [self notifyUpdateUnreadMessageCount];
    self.enableNewComingMessageIcon = YES;
}





- (void)didTapCellPortrait:(NSString *)userId {
    if (!self.userModel) {
        self.userModel = [[UserModel alloc] getMyProfile];
    }

    if ([self.userModel.uid isEqualToString:userId]) {
        DLog(@"自己的uid = %@", userId);
    } else {
        DLog(@"对方的uid = %@", userId);
        //解析工厂信息
        DLog(@"看对方的资料");
        [HttpClient getOtherIndevidualsInformationWithUserID:userId WithCompletionBlock:^(NSDictionary *dictionary) {
            OthersUserModel *model = dictionary[@"message"];
            if ([model.role isEqualToString:@"设计者"] || [model.role isEqualToString:@"供应商"]) {
                PersonalMessage_Design_VC *vc = [PersonalMessage_Design_VC new];
                vc.userModel = model;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([model.role isEqualToString:@"服装企业"]) {
                PersonalMessage_Clothing_VC *vc = [PersonalMessage_Clothing_VC new];
                vc.userModel = model;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([model.role isEqualToString:@"加工配套"]) {
                PersonalMessage_Factory_VC *vc = [PersonalMessage_Factory_VC new];
                vc.userModel = model;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }];
    }
    
}

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
        UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IM-back"]];
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

@end
