//
//  UserProtocolViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/12/11.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "UserProtocolViewController.h"

@interface UserProtocolViewController ()

@end

@implementation UserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"聚工厂用户服务协议";
    UIWebView * webView = [[UIWebView alloc]initWithFrame:kScreenBounds];
    NSURL * url = [NSURL URLWithString:kUserProtocolUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    //返回Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = setButton;

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
