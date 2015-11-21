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


static NSString * const sampleDescription1 = @"面辅料商可在此板块发布产品，用户也可以自由发布求购信息。";
static NSString * const sampleDescription2 = @"新增的流行资讯板块可以为广大用户和设计师提供一个交流的平台。请记住！这里有更多更好更新鲜的流行资讯。";
static NSString * const sampleDescription3 = @"新增的加工厂订单外发板块，可以为加工厂解决订单外发的问题。";
static NSString * const sampleDescription4 = @"新增即时通讯功能，让沟通无处不在。";
static NSString * const sampleDescription5 = @"在美工师傅日夜加工的情况下，我们的新版面终于问世了，此处应有掌声。";

@interface RootViewController ()<EAIntroDelegate,UIApplicationDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if ([HttpClient getToken]) {
        DLog(@"用户已登录");
        [HttpClient validateOAuthWithBlock:^(int statusCode) {
            if (statusCode == 404) {
                [RootViewController goLogin];
            }else {
                [RootViewController goMain];
            }
        }];
    }else{
        DLog(@"用户未登录");
        //未登录 加载展示页面
        [self showIntroWithCrossDissolve];
        [RootViewController goLogin];
    }
   
    AFOAuthCredential *credential=[HttpClient getToken];
    
    DLog(@"\n accessToken = %@ \n refreshToken = %@ ",credential.accessToken,credential.refreshToken)
}

//注册界面
+ (void)goLogin {
    
    LoginViewController *loginView =[[LoginViewController alloc]init];
    UINavigationController *loginNav =[[UINavigationController alloc]initWithRootViewController:loginView];
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    app.window.rootViewController =loginNav;
    
}

//创建Tabbar
+(void)goMain {
    
    CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    app.window.rootViewController = tabBarControllerConfig.tabBarController;
}


- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"面辅料商的福音！";
    page1.desc = sampleDescription1;
    page1.bgImage = [UIImage imageNamed:@"01"];
    //    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"服装设计师面对面！";
    page2.desc = sampleDescription2;
    page2.bgImage = [UIImage imageNamed:@"02"];
    //    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"加工厂也可以发订单了？";
    page3.desc = sampleDescription3;
    page3.bgImage = [UIImage imageNamed:@"03"];
    //    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"让交流更便捷！";
    page4.desc = sampleDescription4;
    page4.bgImage = [UIImage imageNamed:@"04"];
    //    page4.titleIconView = [[UIImageView bgalloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    EAIntroPage *page5 = [EAIntroPage page];
    page5.title = @"新版面新气象！";
    page5.desc = sampleDescription4;
    page5.bgImage = [UIImage imageNamed:@"05"];
    //    page4.titleIconView = [[UIImageView bgalloc] initWithImage:[UIImage imageNamed:@"title4"]];
    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4,page5]];
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
