//
//  PopularNews_Detail_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/3/23.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "PopularNews_Detail_VC.h"
#import "UMSocial.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

#import "SDPhotoBrowser.h"


@interface PopularNews_Detail_VC ()<UIWebViewDelegate, UMSocialUIDelegate,SDPhotoBrowserDelegate> {
    NSString *urlString;
    UIWebView * newsWebView;
    MBProgressHUD *hud;
    NSString *newsTitle;
    NSString *newsDiscriptions;
    UIImage *shareImage;
}

@property (nonatomic, strong) NSMutableArray *imageUrlArray;


@end

@implementation PopularNews_Detail_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(pressRightItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    newsWebView = [[UIWebView alloc]initWithFrame:kScreenBounds];
    newsWebView.delegate = self;
    newsWebView.backgroundColor = [UIColor whiteColor];
    
    //添加access_token
    AFOAuthCredential *credential=[HttpClient getToken];
    NSString*token = credential.accessToken;
    NSString *myUrlString = [NSString stringWithFormat:@"%@%@%@?access_token=%@", kPopularBaseUrl, @"/details/", self.popularNewsModel.newsID, token];
    
    urlString = [NSString stringWithFormat:@"%@%@%@", kPopularBaseUrl, @"/details/", self.popularNewsModel.newsID];
    DLog(@"______%@", myUrlString);
    NSURL *url = [NSURL URLWithString:myUrlString];
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
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    //js方法遍历图片添加点击事件 返回图片个数
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src;\
    };\
    };\
    return objs.length;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    
    NSString *resurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    NSLog(@"resurlt:%@",resurlt);
   
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[request URL] absoluteString];
    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        [self.imageUrlArray removeAllObjects];
        [self showImage:imageUrl];
        return NO;
    }
    return YES;
}

#pragma mark 显示大图片
- (void)showImage:(NSString *)imageUrl{
    self.imageUrlArray = [[NSMutableArray alloc]initWithCapacity:0];
    [self.imageUrlArray addObject:imageUrl];
    
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = 0;
    browser.imageCount = 1;
    
    browser.delegate = self;
    [browser show];
    
    /*
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:0];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imageUrl]];
    [photos addObject:photo];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0;
    browser.photos = photos;
    [browser show];
     */

}

#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *imageUrl = self.imageUrlArray[index];
    NSURL *url = [NSURL URLWithString:imageUrl];
    return url;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"placeHolderImage"];
    return imageView.image;
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
        if ([Tools isBlankString:self.popularNewsModel.newsTitle]) {
            newsTitle = @"来自于聚工厂《时尚资讯》的分享";
        } else {
            newsTitle = self.popularNewsModel.newsTitle;
        }
        if ([Tools isBlankString:self.popularNewsModel.discriptions]) {
            newsDiscriptions = @"来自于聚工厂《时尚资讯》的分享";
        } else {
            newsDiscriptions = self.popularNewsModel.discriptions;
        }
        
        if ([Tools isBlankString:self.popularNewsModel.newsImage]) {
            shareImage = [UIImage imageNamed:@"Home-icon"];
        } else {
            shareImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kPopularBaseUrl, self.popularNewsModel.newsImage]]]];
        }
        //分享多个
        [UMSocialData defaultData].extConfig.wechatSessionData.url = urlString;//微信好友
        [UMSocialData defaultData].extConfig.wechatSessionData.title = newsTitle;
        
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = urlString;//微信朋友圈
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = newsTitle;
        
        [UMSocialData defaultData].extConfig.qqData.url = urlString;//QQ好友
        [UMSocialData defaultData].extConfig.qqData.title = newsTitle;
        
        [UMSocialData defaultData].extConfig.qzoneData.url = urlString;//QQ空间
        [UMSocialData defaultData].extConfig.qzoneData.title = newsTitle;
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:Appkey_Umeng
                                          shareText:newsDiscriptions
                                         shareImage:shareImage
                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone]
                                           delegate:self];
    }
}

@end
