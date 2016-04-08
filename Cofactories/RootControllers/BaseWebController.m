//
//  WebController.m
//  Cofactories
//
//  Created by 宋国华 on 16/3/7.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "BaseWebController.h"

#import "MJPhoto.h"

#import "MJPhotoBrowser.h"

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
    
    AFOAuthCredential *credential=[HttpClient getToken];
    NSString * urlStr = [NSString stringWithFormat:@"%@?access_token=%@",self.requestUrl,credential.accessToken];
    NSURL * url = [NSURL URLWithString:urlStr];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    _hud = [Tools createHUDWithView:self.view];
    _hud.labelText = @"加载中...";
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_hud hide:YES];
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
    
    //注入自定义的js方法后别忘了调用 否则不会生效（不调用也一样生效了，，，不明白）
    NSString *resurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    //调用js方法
    //NSLog(@"---调用js方法--%@  %s  jsMehtods_result = %@",self.class,__func__,resurlt);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //将url转换为string
    NSString *requestString = [[request URL] absoluteString];
    //NSLog(@"requestString is %@",requestString);
    
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        
        //NSLog(@"image url------%@", imageUrl);
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:0];
        MJPhoto *photo = [[MJPhoto alloc] init];
        // photo.image = self.collectionImage[idx]; // 图片
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imageUrl]];
        [photos addObject:photo];
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = 0;
        browser.photos = photos;
        [browser show];
    }
    return YES;
}

@end
