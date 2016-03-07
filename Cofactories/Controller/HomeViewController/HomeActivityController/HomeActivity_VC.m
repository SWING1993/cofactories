//
//  HomeActivity_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/18.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "HomeActivity_VC.h"
#import "PersonalMessage_Design_VC.h"
#import "PersonalMessage_Clothing_VC.h"
#import "PersonalMessage_Factory_VC.h"
#import "HomeKoreaShopList_VC.h"
#import "PopularMessageController.h"
#import "ShoppingMallDetail_VC.h"
#import <Bugly/JSExceptionReporter.h>

@interface HomeActivity_VC ()<UIWebViewDelegate> {
    UIWebView * webView;
    MBProgressHUD *hud;
}

@end

@implementation HomeActivity_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    webView = [[UIWebView alloc]initWithFrame:kScreenBounds];
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
//    self.urlString = @"http://h5.lo.cofactories.com/!)test/";
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.view addSubview:webView];
    [webView loadRequest:request];
    
    hud = [Tools createHUDWithView:self.view];
    hud.labelText = @"加载中...";
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[request URL] absoluteString];
    DLog(@"^^^^^^^^%@", requestString);
    
    [JSExceptionReporter startCaptureJSExceptionWithWebView:webView injectScript:YES];
    //判断是不是点击链接
    if ([requestString hasPrefix:@"cofactories:"]) {
        //判断是不是直接进入商城
        if ([requestString hasPrefix:@"cofactories:shop"]) {
            if ([requestString hasPrefix:@"cofactories:shop?"]) {
                //打开韩国版型购买商城，并按照时间搜索
                if ([requestString rangeOfString:@"time"].location != NSNotFound) {
                    NSArray *timeArray = [requestString componentsSeparatedByString:@"?"];
                    NSString *timeString = [[timeArray lastObject] substringFromIndex:5];
                    DLog(@"####%@###", timeString);
                    
                    HomeKoreaShopList_VC *designShopVC = [[HomeKoreaShopList_VC alloc] initWithSubrole:@"设计者" andSelecteDataDictionary:[Tools goodsSelectDataDictionaryWithIndex:5]];
                    designShopVC.timeString = timeString;
                    [self.navigationController pushViewController:designShopVC animated:YES];
                    
                }
                //打开某个商品的详情页
                if ([requestString rangeOfString:@"id"].location != NSNotFound) {
                    NSArray *goodsArray = [requestString componentsSeparatedByString:@"?"];
                    NSString *goodsString = [[goodsArray lastObject] substringFromIndex:3];
                    DLog(@"####%@###", goodsString);
                    
                    ShoppingMallDetail_VC *materialShopVC = [[ShoppingMallDetail_VC alloc] init];
                    materialShopVC.shopID = goodsString;
                    [self.navigationController pushViewController:materialShopVC animated:YES];
                }
                
            } else {
                //直接进入韩国版型购买商城
                HomeKoreaShopList_VC *designShopVC = [[HomeKoreaShopList_VC alloc] initWithSubrole:@"设计者" andSelecteDataDictionary:[Tools goodsSelectDataDictionaryWithIndex:5]];
                designShopVC.timeString = nil;
                [self.navigationController pushViewController:designShopVC animated:YES];
            }
        }
        
        //流行资讯
        if ([requestString rangeOfString:@"news"].location != NSNotFound) {
            PopularMessageController *popularVC = [[PopularMessageController alloc] init];
            popularVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:popularVC animated:YES];
        }
        
        //用户信息
        if ([requestString rangeOfString:@"userInfo"].location != NSNotFound) {
            NSArray *userInfoArray = [requestString componentsSeparatedByString:@"?"];
            NSString *uidString = [[userInfoArray lastObject] substringFromIndex:4];
            DLog(@"#######%@###", uidString);
            [HttpClient getOtherIndevidualsInformationWithUserID:uidString WithCompletionBlock:^(NSDictionary *dictionary) {
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
        
    } else {
        DLog(@"不需要的参数");
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [hud hide:YES];
}


@end
