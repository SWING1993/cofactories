//
//  PopularNewsDetail_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/16.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "PopularNewsDetail_VC.h"
#define kPopularNewsDeatil @"http://lo.news.mxd.moe/details/"

@interface PopularNewsDetail_VC ()<UIWebViewDelegate> {
    UIWebView *webView1;

}
@property (nonatomic,retain)UIWebView *webView;
@property (nonatomic, assign) NSString *userAgent;

@end

@implementation PopularNewsDetail_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资讯详情";
    self.view.backgroundColor = [UIColor whiteColor];
    //获取当前UA
    [self createHttpRequest];
    NSString *uaString = [self userAgentString];
    
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.frame = CGRectMake(0,0,kScreenW,15 * kScreenH);

    //添加access_token
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    NSString*token = credential.accessToken;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&access_token=%@", kPopularNewsDeatil, self.newsID, token]];
    DLog(@"^^^^^^^^^^^%@", url);
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_webView sizeToFit];
    //原来的ua+原来没有空格 加空格+CoFactories-iOS-版本号
    //修改ua
    NSString *ua = @"";
    //版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if ([uaString rangeOfString:@" CoFactories-iOS-"].location != NSNotFound) {
        ua = uaString;
    } else {
        ua = [[NSString alloc] initWithFormat:@"%@ CoFactories-iOS-%@", uaString, app_build];
        
    }
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:ua, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
    [_webView loadRequest:urlRequest];

    
    
}
#pragma mark - 获取当前UA
- (void)createHttpRequest {
    webView1 = [[UIWebView alloc] init];
    webView1.delegate = self;
    [webView1 loadRequest:[NSURLRequest requestWithURL:
                           [NSURL URLWithString:@"http://www.google.com"]]];
    NSLog(@"%@", [self userAgentString]);
}
-(NSString *)userAgentString
{
    while (self.userAgent == nil)
    {
        NSLog(@"%@", @"in while");
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return self.userAgent;
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (webView == webView1) {
        self.userAgent = [request valueForHTTPHeaderField:@"User-Agent"];
        // Return no, we don't care about executing an actual request.
        return NO;
    }
    //去除链接，点击没有反应
    if(navigationType==UIWebViewNavigationTypeLinkClicked)//判断是否是点击链接
    {
        return NO;
    }
    else
    {
        return YES;
    }
    
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
