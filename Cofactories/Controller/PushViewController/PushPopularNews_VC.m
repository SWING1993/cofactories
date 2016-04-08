//
//  PushPopularNews_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/2/1.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "PushPopularNews_VC.h"
#import "UMSocial.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

@interface PushPopularNews_VC ()<UIWebViewDelegate, UMSocialUIDelegate> {
    NSString *urlString;
    UIWebView * newsWebView;
    MBProgressHUD *hud;
    UIImage *shareImage;
}

@end

@implementation PushPopularNews_VC

- (void)viewDidLoad {
    [super viewDidLoad];

    newsWebView = [[UIWebView alloc]initWithFrame:kScreenBounds];
    newsWebView.delegate = self;
    newsWebView.backgroundColor = [UIColor whiteColor];
    //添加access_token
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    NSString*token = credential.accessToken;
    
    urlString = [NSString stringWithFormat:@"%@%@%@ ", kPopularBaseUrl, @"/details/", self.id_flag];
    NSString *myString = [NSString stringWithFormat:@"%@%@%@?access_token=%@", kPopularBaseUrl, @"/details/", self.id_flag, token];
    DLog(@"______%@", myString);
    NSURL *url = [NSURL URLWithString:myString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.view addSubview:newsWebView];
    [newsWebView loadRequest:request];
    
    NSArray *loadingTextArray = @[@"点击文章右上角分享到微信朋友圈", @"文章最下方可与其他用户评论交流" , @"每天12点和18点都会有最新鲜的流行资讯发布" , @"点击文章列表换一批可以刷新文章列表", @"个人资料完善二级身份可以获得更多关注"];
    hud = [Tools createHUDWithView:self.view];
    int x = arc4random() % 5;
    hud.detailsLabelText = loadingTextArray[x];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [hud hide:YES];
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
