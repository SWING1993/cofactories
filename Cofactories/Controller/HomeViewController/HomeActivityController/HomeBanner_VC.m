//
//  HomeBanner_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/1/19.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "HomeBanner_VC.h"

@interface HomeBanner_VC ()<UIWebViewDelegate> {
    UIWebView * webView;
    MBProgressHUD *hud;
}


@end

@implementation HomeBanner_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    webView = [[UIWebView alloc]initWithFrame:kScreenBounds];
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    self.urlString = @"http://h5.lo.cofactories.com/activity/miaosha/";
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.view addSubview:webView];
    [webView loadRequest:request];
    
    hud = [Tools createHUDWithView:self.view];
    hud.labelText = @"加载中...";
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
