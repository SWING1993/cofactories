//
//  PopularNews_Detail_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/3/23.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "PopularNews_Detail_VC.h"
#import "SDPhotoBrowser.h"
#import "ShareView.h"

@interface PopularNews_Detail_VC ()<UIWebViewDelegate,SDPhotoBrowserDelegate> {
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
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PopularNews-share"] style:UIBarButtonItemStylePlain target:self action:@selector(pressRightItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    urlString = [NSString stringWithFormat:@"%@%@%@", kPopularBaseUrl, @"/details/", self.popularNewsModel.newsID];
    
    //添加access_token
    AFOAuthCredential *credential=[HttpClient getToken];
    NSString*token = credential.accessToken;
    NSString *myUrlString = [NSString stringWithFormat:@"%@%@%@?access_token=%@", kPopularBaseUrl, @"/details/", self.popularNewsModel.newsID, token];
    NSURL *url = [NSURL URLWithString:myUrlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    newsWebView = [[UIWebView alloc]initWithFrame:kScreenBounds];
    newsWebView.delegate = self;
    newsWebView.backgroundColor = [UIColor whiteColor];
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
    
    ShareView *shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    shareView.title = self.popularNewsModel.newsTitle;
    shareView.message = self.popularNewsModel.discriptions;
    shareView.pictureName =  self.popularNewsModel.newsImage;
    shareView.shareUrl = urlString;
    shareView.myViewController = self;
    [shareView showShareView];
}

@end
