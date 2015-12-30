//
//  ViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/3.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "HttpClient.h"
#import "RootViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "CYLTabBarControllerConfig.h"


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
    
    if ([HttpClient getToken]) {
        DLog(@"用户已登录，判断Token是否过期！");
        [HttpClient validateOAuthWithBlock:^(NSInteger statusCode) {
            if (statusCode == 200) {
                [RootViewController setupTabarController];
            }else {
                [RootViewController setupLoginViewController];
            }
        }];
    }else{
        DLog(@"用户未登录,去登录！");
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

#pragma mark - EAIntroView delegate

- (void)introDidFinish:(EAIntroView *)introView {
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"showEAIntroPage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self setupRootViewController];
    // 展示页面结束 加载登陆注册页面
}

- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
//    page1.title = @"面辅料商的福音！";
//    page1.desc = sampleDescription1;
    page1.bgImage = [UIImage imageNamed:@"01"];
    //    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
//    page2.title = @"服装设计师面对面！";
//    page2.desc = sampleDescription2;
    page2.bgImage = [UIImage imageNamed:@"02"];
    //    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    
    EAIntroPage *page3 = [EAIntroPage page];
//    page3.title = @"加工厂也可以发订单了？";
//    page3.desc = sampleDescription3;
    page3.bgImage = [UIImage imageNamed:@"03"];
    //    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    EAIntroPage *page4 = [EAIntroPage page];
//    page4.title = @"让交流更便捷！";
//    page4.desc = sampleDescription4;
    page4.bgImage = [UIImage imageNamed:@"04"];
    //    page4.titleIconView = [[UIImageView bgalloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    EAIntroPage *page5 = [EAIntroPage page];
//    page5.title = @"新版面新气象！";
//    page5.desc = sampleDescription4;
    page5.bgImage = [UIImage imageNamed:@"05"];
    //    page4.titleIconView = [[UIImageView bgalloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4,page5]];
    [intro setDelegate:self];
    
    
    intro.skipButton.alpha = 0.f;
    intro.skipButton.enabled = NO;

    
    page5.onPageDidAppear = ^{
        intro.skipButton.enabled = YES;
        [UIView animateWithDuration:0.2f animations:^{
            intro.skipButton.alpha = 1.f;
        }];
    };
    
    page5.onPageDidDisappear = ^{
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
