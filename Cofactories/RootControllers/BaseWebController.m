//
//  WebController.m
//  Cofactories
//
//  Created by 宋国华 on 16/3/7.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "BaseWebController.h"

@interface BaseWebController ()<UIWebViewDelegate>

@end

@implementation BaseWebController
UIWebView * _webView;
MBProgressHUD * _hud;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _webView = [[UIWebView alloc]initWithFrame:kScreenBounds];
    _webView.delegate = self;
    NSURL * url = [NSURL URLWithString:self.requestUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    _hud = [Tools createHUDWithView:self.view];
    _hud.labelText = @"加载中...";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_hud hide:YES];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
