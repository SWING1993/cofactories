//
//  AboutWalletViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/12/12.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "AboutWalletViewController.h"

@interface AboutWalletViewController () <UIWebViewDelegate>

@end

@implementation AboutWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于钱包";
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"back"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    UIWebView * webView = [[UIWebView alloc]initWithFrame:kScreenBounds];
    webView.delegate = self;
    NSString *walletString = [NSString stringWithFormat:@"%@%@", kH5BaseUrl, @"/info/wallet/"];
    NSURL * url = [NSURL URLWithString:walletString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.view addSubview:webView];
    [webView loadRequest:request];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    DLog(@"nmb");
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", kScreenW];
    [webView stringByEvaluatingJavaScriptFromString:meta];
}

- (void)back {
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
