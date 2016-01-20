//
//  ViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/3.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "Login.h"
#import "HttpClient.h"
#import "RootViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "CYLTabBarControllerConfig.h"
#import "BaseNavigationController.h"

#import "EAIntroPage.h"
#import "EAIntroView.h"

/*
static NSString * const sampleDescription1 = @"全新界面 全新玩法";
static NSString * const sampleDescription2 = @"在线商城 在线交易";
static NSString * const sampleDescription3 = @"订单操作 快捷简单";
static NSString * const sampleDescription4 = @"活动多多 商机多多";
static NSString * const sampleDescription5 = @"四大专区 应有尽有";
 */

@interface RootViewController ()<EAIntroDelegate,UIApplicationDelegate>
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    /**
     *  判断是否展示过新版本特性页
     */
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"showEAIntroPage"] boolValue]) {
        [self setupRootViewController];
    }else {
        [self showIntroWithCrossDissolve];
    }
}

- (void)setupRootViewController {
    /*
    AFOAuthCredential *credential=[HttpClient getToken];
    DLog(@"\n accessToken = %@ \n refreshToken = %@ \n credential.expired = %d",credential.accessToken,credential.refreshToken,credential.expired);
     */
    
    if ([Login isLogin]) {
        [HttpClient validateOAuthWithBlock:^(NSInteger statusCode) {
            if (statusCode == 200) {
                [RootViewController setupTabarController];
            }else {
                [RootViewController setupLoginViewController];
            }
        }];
    }else{
        [RootViewController setupLoginViewController];
    }
}

//注册界面
+ (void)setupLoginViewController {
    LoginViewController *loginView =[[LoginViewController alloc]init];
    UINavigationController *loginNav =[[UINavigationController alloc]initWithRootViewController:loginView];
    AppDelegate *app =(AppDelegate*)[UIApplication sharedApplication].delegate;
    app.window.rootViewController =loginNav;
}

//创建Tabbar
+(void)setupTabarController {
    CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
    AppDelegate *app =(AppDelegate*)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = tabBarControllerConfig.tabBarController;
}

#pragma mark Notification
+ (void)handleNotificationInfo:(NSDictionary *)userInfo applicationState:(UIApplicationState)applicationState{
    if ([Login isLogin]) {
        //已登录
    }
    if (applicationState == UIApplicationStateInactive) {
        //If the application state was inactive, this means the user pressed an action button from a notification.
//        UserProtocolViewController * vc = [[UserProtocolViewController alloc]init];
//        [self presentVC:vc];
        
    }else if (applicationState == UIApplicationStateActive){
//        UserProtocolViewController * vc = [[UserProtocolViewController alloc]init];
//        [self presentVC:vc];
    }
}
+ (UIViewController *)presentingVC{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[CYLTabBarController class]]) {
        result = [(CYLTabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

+ (void)presentVC:(UIViewController *)viewController{
    if (!viewController) {
        return;
    }
    UINavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:viewController];
    if (!viewController.navigationItem.leftBarButtonItem) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:viewController action:@selector(dismissModalViewControllerAnimated:)];
    }
    [[self presentingVC] presentViewController:nav animated:YES completion:nil];
}


#pragma mark - EAIntroView delegate

- (void)introDidFinish:(EAIntroView *)introView {
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showEAIntroPage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setupRootViewController];
    // 展示页面结束 加载登陆注册页面
}

- (void)showIntroWithCrossDissolve {

    EAIntroPage *page1 = [EAIntroPage page];
    EAIntroPage *page2 = [EAIntroPage page];
    EAIntroPage *page3 = [EAIntroPage page];
    EAIntroPage *page4 = [EAIntroPage page];


    if (iphone4x_3_5) {
        DLog(@"4S");
        page1.bgImage = [UIImage imageNamed:@"4S_1"];
        page2.bgImage = [UIImage imageNamed:@"4S_2"];
        page3.bgImage = [UIImage imageNamed:@"4S_3"];
        page4.bgImage = [UIImage imageNamed:@"4S_4"];
    }else {
        page1.bgImage = [UIImage imageNamed:@"01"];
        page2.bgImage = [UIImage imageNamed:@"02"];
        page3.bgImage = [UIImage imageNamed:@"03"];
        page4.bgImage = [UIImage imageNamed:@"04"];
    }
    
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
    [intro setDelegate:self];
    
    
    intro.skipButton.alpha = 0.f;
    intro.skipButton.enabled = NO;

    
    page4.onPageDidAppear = ^{
        intro.skipButton.enabled = YES;
        [UIView animateWithDuration:0.2f animations:^{
            intro.skipButton.alpha = 1.f;
        }];
    };
    
    page4.onPageDidDisappear = ^{
        intro.skipButton.enabled = NO;
        [UIView animateWithDuration:0.3f animations:^{
            intro.skipButton.alpha = 0.f;
        }];
    };
    
    [intro showInView:self.view animateDuration:0.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
