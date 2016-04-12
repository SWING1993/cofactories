//
//  ShareView.m
//  Cofactories
//
//  Created by 赵广印 on 16/4/9.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "ShareView.h"
#import "UMSocial.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

#define kImageHeight 50*kZGY  //图片的大小
#define kTop 20//距上边的距离
#define kSpace (kScreenW - 3*kImageHeight)/18//间距（距两边的距离是4*kSpace，两个按钮之间的距离是5*kSpace）
#define kCancleHeight 50 //取消按钮的高度
#define kPopTime 0.3 //动画时间

@implementation ShareView {
    NSArray *imageArray;
    NSArray *titleArray;
    UIButton *backgroundView;
    UIView *shareBackgroundView;
    float btnsHeight;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatShareView];
        [[[UIApplication  sharedApplication]keyWindow ]addSubview :self];
    }
    return self;
}

- (void)creatShareView {
    
    [self getShareArray];
    
    //按钮列数
    int cloumsNum = 3;
    //按钮行数
    unsigned long rowsNum = (titleArray.count + cloumsNum - 1) / cloumsNum;
    //所有分享按钮高度
    btnsHeight = rowsNum*(kImageHeight + 30 + 10) + kTop;
    
    backgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    [backgroundView addTarget:self action:@selector(removeShareView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backgroundView];
    
    shareBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 44 + btnsHeight)];
    shareBackgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:shareBackgroundView];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 1.5)];
    lineView.image = [UIImage imageNamed:@"share_TopLine"];
    [shareBackgroundView addSubview:lineView];
    
    for(int i = 0; i < rowsNum; i++) {
        for(int j = 0; j<cloumsNum; j++) {
            int num = i * cloumsNum + j;
            if(num >= titleArray.count) {
                break;
            }
            float shareX = 4*kSpace + j*(5*kSpace + kImageHeight);
            float shareY = kTop + i*(kImageHeight + 30 + 10);
            
            UIImageView *shareImage = [[UIImageView alloc] initWithFrame:CGRectMake(shareX, shareY, kImageHeight, kImageHeight)];
            shareImage.image = [UIImage imageNamed:imageArray[num]];
            shareImage.userInteractionEnabled = YES;
            shareImage.tag = 222 + num;
            UITapGestureRecognizer *shareImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapShareView:)];
            [shareImage addGestureRecognizer:shareImageTap];
            [shareBackgroundView addSubview:shareImage];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
            titleLabel.center = CGPointMake(shareImage.center.x, shareImage.center.y + kImageHeight/2 + 15);
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor darkGrayColor];
            titleLabel.text = titleArray[num];
            [shareBackgroundView addSubview:titleLabel];
        }
    }
    
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, btnsHeight, kScreenW, 0.4);
    line.backgroundColor = kLineGrayCorlor.CGColor;
    [shareBackgroundView.layer addSublayer:line];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(0, btnsHeight, kScreenW, kCancleHeight);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancleButton addTarget:self action:@selector(removeShareView) forControlEvents:UIControlEventTouchUpInside];
    [shareBackgroundView addSubview:cancleButton];
    
}

- (void)getShareArray {
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
    if ( [WXApi isWXAppInstalled] == NO &&[QQApiInterface isQQInstalled] == NO) {
        //QQ和微信都没安装
        titleArray = @[@"邮件", @"短信"];
        imageArray = @[@"share_post", @"share_message"];
    } else if ([WXApi isWXAppInstalled] == NO &&[QQApiInterface isQQInstalled] == YES) {
        //微信未安装
        titleArray = @[@"QQ", @"QQ空间", @"邮件", @"短信"];
        imageArray = @[@"share_QQ", @"share_Qzone", @"share_post", @"share_message"];
    } else if ([WXApi isWXAppInstalled] == YES &&[QQApiInterface isQQInstalled] == NO) {
        //QQ未安装
        titleArray = @[@"微信朋友圈", @"微信好友", @"邮件", @"短信"];
        imageArray = @[@"share_weixinFriend", @"share_wexin", @"share_post", @"share_message"];
    } else if ([WXApi isWXAppInstalled] == YES &&[QQApiInterface isQQInstalled] == YES) {
        //QQ和微信都有安装
        titleArray = @[@"微信朋友圈", @"微信好友", @"QQ", @"QQ空间", @"邮件", @"短信"];
        imageArray = @[@"share_weixinFriend", @"share_wexin", @"share_QQ", @"share_Qzone", @"share_post", @"share_message"];
    }
}


- (void)didTapShareView:(UITapGestureRecognizer *)tap {
    UIImage *newsImage = nil;
    if (self.pictureName) {
        newsImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kPopularBaseUrl, self.pictureName]]]];
    } else {
        newsImage = [UIImage imageNamed:@"Home-icon"];
    }
    
    NSInteger number = tap.view.tag - 222;
    [self removeShareView];
    if ([titleArray[number] isEqualToString:@"微信朋友圈"]) {
        NSLog(@"微信朋友圈");
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareUrl;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.title;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.message image:newsImage location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [Tools showHudTipStr:@"分享成功！"];
            } else {
                [Tools showErrorTipStr:@"分享失败！"];
            }
        }];
        
    } else if ([titleArray[number] isEqualToString:@"微信好友"]) {
        NSLog(@"微信好友");
        [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareUrl;
        [UMSocialData defaultData].extConfig.wechatSessionData.title = self.title;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.message image:newsImage location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [Tools showHudTipStr:@"分享成功！"];
            } else {
                [Tools showErrorTipStr:@"分享失败！"];
            }
        }];
        
        
    } else if ([titleArray[number] isEqualToString:@"QQ"]) {
        NSLog(@"QQ");
        [UMSocialData defaultData].extConfig.qqData.url = self.shareUrl;
        [UMSocialData defaultData].extConfig.qqData.title = self.title;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.message image:newsImage location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [Tools showHudTipStr:@"分享成功！"];
            } else {
                [Tools showErrorTipStr:@"分享失败！"];
            }
        }];
        
        
    } else if ([titleArray[number] isEqualToString:@"QQ空间"]) {
        NSLog(@"QQ空间");
        [UMSocialData defaultData].extConfig.qzoneData.url = self.shareUrl;
        [UMSocialData defaultData].extConfig.qzoneData.title = self.title;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.message image:newsImage location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [Tools showHudTipStr:@"分享成功！"];
            } else {
                [Tools showErrorTipStr:@"分享失败！"];
            }
        }];
        
    } else if ([titleArray[number] isEqualToString:@"邮件"]) {
        NSLog(@"邮件");
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToEmail] content:[NSString stringWithFormat:@"%@%@", self.title, self.shareUrl] image:nil location:nil urlResource:nil presentedController:self.myViewController completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                [Tools showHudTipStr:@"发送邮件成功！"];
            } else {
                [Tools showErrorTipStr:@"发送邮件失败！"];
            }
        }];
        
        
    } else if ([titleArray[number] isEqualToString:@"短信"]) {
        NSLog(@"短信");
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:[NSString stringWithFormat:@"%@%@", self.title, self.shareUrl] image:nil location:nil urlResource:nil presentedController:self.myViewController completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                [Tools showHudTipStr:@"发送短信成功！"];
            } else {
                [Tools showErrorTipStr:@"发送短信失败！"];
            }
        }];
    }
}


- (void)showShareView {
    [UIView animateWithDuration:kPopTime animations:^{
        backgroundView.alpha = 0.4;
        shareBackgroundView.frame = CGRectMake(0, kScreenH - (kCancleHeight + btnsHeight), kScreenW, kCancleHeight + btnsHeight);
    } completion:^(BOOL finished) {
        //在这里可以加动画效果
    }];
}

- (void)removeShareView {

    [UIView animateWithDuration:kPopTime animations:^{
        shareBackgroundView.frame =CGRectMake(0, kScreenH, kScreenH, kCancleHeight + btnsHeight);
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
