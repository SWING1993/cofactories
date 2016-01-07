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
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.view addSubview:webView];
    [webView loadRequest:request];
    
    hud = [Tools createHUDWithView:self.view];
    hud.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    hud.labelText = @"加载中...";
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestString = [[request URL] absoluteString];
    DLog(@"^^^^^^^^%@", requestString);
    NSString *headerString = nil;
    if (requestString.length >11) {
        headerString = [requestString substringToIndex:12];
        DLog(@"#####%@", headerString);
    }
    
    //判断点的链接是不是电话
//    NSString *telString = [requestString substringToIndex:4];
//    if ([telString isEqualToString:@"tel:"]) {
//        NSString *phoneString = [requestString substringFromIndex:4];
//        DLog(@"phone = %@", phoneString);
//        NSString *str = [NSString stringWithFormat:@"telprompt://%@", phoneString];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//    }
    //判断是不是点击链接
    if ([headerString isEqualToString:@"cofactories:"]) {
        
        if ([requestString rangeOfString:@"shop"].location != NSNotFound) {
            HomeKoreaShopList_VC *designShopVC = [[HomeKoreaShopList_VC alloc] initWithSubrole:@"设计者" andSelecteDataDictionary:[Tools goodsSelectDataDictionaryWithIndex:5]];
            [self.navigationController pushViewController:designShopVC animated:YES];
        }
        if ([requestString rangeOfString:@"news"].location != NSNotFound) {
            PopularMessageController *popularVC = [[PopularMessageController alloc] init];
            popularVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:popularVC animated:YES];
        }
        if ([requestString rangeOfString:@"userInfo"].location != NSNotFound) {
            NSArray *userInfoArray = [requestString componentsSeparatedByString:@"?"];
            NSString *uidString = [[userInfoArray lastObject] substringFromIndex:4];
            DLog(@"#######uid=%@###", uidString);
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
//                    vc.userID = uidString;
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
    [hud hide:YES];
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
