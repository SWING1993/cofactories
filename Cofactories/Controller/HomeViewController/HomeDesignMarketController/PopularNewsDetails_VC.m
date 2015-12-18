//
//  PopularNewsDetails_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/18.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "PopularNewsDetails_VC.h"
#define kPopularNewsDeatil @"http://lo.news.mxd.moe/details/"

@interface PopularNewsDetails_VC ()<UIWebViewDelegate> {
    NSURL *url;
    MBProgressHUD *hud;
}

@end

@implementation PopularNewsDetails_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    hud = [Tools createHUD];
    hud.labelText = @"加载中...";
    UIWebView * webView = [[UIWebView alloc]initWithFrame:kScreenBounds];
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    //添加access_token
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    NSString*token = credential.accessToken;

    if (self.lijoString.length == 0) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?access_token=%@", kPopularNewsDeatil, self.newsID, token]];
    } else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?access_token=%@", self.lijoString, token]];
    }
    DLog(@"______%@", url);
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.view addSubview:webView];
    [webView loadRequest:request];}


#pragma mark - UIWebViewDelegate
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
