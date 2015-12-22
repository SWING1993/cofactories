//
//  HomeActivity_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/18.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "HomeActivity_VC.h"

@interface HomeActivity_VC ()<UIWebViewDelegate> {
    UIWebView * webView;
}


@end

@implementation HomeActivity_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    webView = [[UIWebView alloc]initWithFrame:kScreenBounds];
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    NSString *url = kActivityUrl;
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.view addSubview:webView];
    [webView loadRequest:request];

    [webView stringByEvaluatingJavaScriptFromString:@"myFunction();"];
    // 注入js
    
    NSString *p = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"js"];
    NSString *js = [NSString stringWithContentsOfFile:p encoding:NSUTF8StringEncoding error:nil];
    [webView stringByEvaluatingJavaScriptFromString:js];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *requestString = [[request URL] absoluteString];
    
    // 中文乱码转换
    NSLog(@"pre:%@",requestString);// pre:testapp:alert:%E4%BD%A0%E5%A5%BD%E5%90%97%EF%BC%9F
    requestString = [requestString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"cov:%@",requestString);// cov:testapp:alert:你好吗？
    
    
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:0] isEqualToString:@"cofactories"]) {
        if([(NSString *)[components objectAtIndex:1] isEqualToString:@"alert"])
        {
            DLog(@"^^^^^^^^^^ = %@", [components objectAtIndex:2]);
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"alert from html" message:[components objectAtIndex:2]
                                  delegate:self cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
            [alert show];
        }
        return NO;
    }
    return YES;
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
