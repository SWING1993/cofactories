//
//  PopularNewsDetails_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/18.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "PopularNewsDetails_VC.h"
#import "UMSocial.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"


@interface PopularNewsDetails_VC ()<UIWebViewDelegate, UMSocialUIDelegate> {
    NSString *urlString;
    UIWebView * webView;
    MBProgressHUD *hud;
    UIImage *shareImage;
}

@end

@implementation PopularNewsDetails_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"文章详情";
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"back"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(pressRightItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    webView = [[UIWebView alloc]initWithFrame:kScreenBounds];
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    //添加access_token
    NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
    NSString *serviceProviderIdentifier = [baseUrl host];
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:serviceProviderIdentifier];
    NSString*token = credential.accessToken;

    if (self.lijoString.length == 0) {
        urlString = [NSString stringWithFormat:@"%@%@%@?access_token=%@", kPopularBaseUrl, @"/details/", self.newsID, token];
    } else {
        urlString = [NSString stringWithFormat:@"%@?access_token=%@", self.lijoString, token];
    }
    DLog(@"______%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [self.view addSubview:webView];
    [webView loadRequest:request];
    
    NSArray *loadingTextArray = @[@"点击文章右上角分享到微信朋友圈", @"文章最下方可与其他用户评论交流" , @"每天12点和18点都会有最新鲜的流行资讯发布" , @"点击文章列表换一批可以刷新文章列表", @"个人资料完善二级身份可以获得更多关注"];
    hud = [Tools createHUDWithView:self.view];
    int x = arc4random() % 5;
    hud.detailsLabelText = loadingTextArray[x];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [hud hide:YES];
}

#pragma mark - 分享
- (void)pressRightItem {
    
    if ( [WXApi isWXAppInstalled] == NO &&[QQApiInterface isQQInstalled] == NO) {
        DLog(@"微信和QQ都没安装");
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:Appkey_Umeng
                                          shareText:[NSString stringWithFormat:@"%@, %@", self.popularNewsModel.newsTitle, urlString]
                                         shareImage:nil
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSms,nil]
                                           delegate:self];
    } else {
        DLog(@"^^^^^^^urlString = %@", urlString);
        NSString *title = @"";
        if (self.popularNewsModel.newsTitle.length == 0) {
            title = @"来自于聚工厂《流行资讯》的分享";
        } else {
            title = self.popularNewsModel.newsTitle;
        }
        NSString *discriptions = @"";
        if (self.popularNewsModel.discriptions.length == 0) {
            discriptions = @"来自于聚工厂《流行资讯》的分享";
        } else {
            discriptions = self.popularNewsModel.discriptions;
        }
        
        if (self.popularNewsModel.newsImage.length == 0) {
            shareImage = [UIImage imageNamed:@"Home-icon"];
        } else {
            shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kPopularBaseUrl, self.popularNewsModel.newsImage]]]];
        }
        //分享多个
        [UMSocialData defaultData].extConfig.wechatSessionData.url = urlString;//微信好友
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
        
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlString;//微信朋友圈
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
        
        [UMSocialData defaultData].extConfig.qqData.url = urlString;//QQ好友
        [UMSocialData defaultData].extConfig.qqData.title = title;
        
        [UMSocialData defaultData].extConfig.qzoneData.url = urlString;//QQ空间
        [UMSocialData defaultData].extConfig.qzoneData.title = title;
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:Appkey_Umeng
                                          shareText:discriptions
                                         shareImage:shareImage
                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone]
                                           delegate:self];
    }
}

- (void) back
{
//    if ([webView canGoBack]) {
//        [webView goBack];
//    }
//    else
//    {
        [self.navigationController popViewControllerAnimated:YES];
//    }
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
