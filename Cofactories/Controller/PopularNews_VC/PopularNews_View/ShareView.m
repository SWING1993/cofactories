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

#define kImageHeight 60*kZGY  //图片的大小
#define kTop 20//距上边的距离
#define kSpace (kScreenW - 3*kImageHeight)/18//间距

@implementation ShareView {
    NSArray *imageArray;
    NSArray *titleArray;
    UIButton *backgroundView;
    UIView *shareBackgroundView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatShareView];
    }
    return self;
}

- (void)creatShareView {
    
//    [self getShareArray];
    imageArray = @[@"share_weixinFriend", @"share_wexin", @"share_QQ", @"share_Qzone", @"share_post", @"share_message"];
    titleArray = @[@"微信朋友圈", @"微信好友", @"QQ", @"QQ空间", @"邮件", @"短信"];
    
    //按钮列数
    int cloumsNum = 3;
    //按钮行数
    unsigned long rowsNum = (titleArray.count + cloumsNum - 1) / cloumsNum;
    //所有分享按钮高度
    float btnsHeight = rowsNum*(kImageHeight + 30 + 10) + kTop;
    
    backgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
    backgroundView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    [backgroundView addTarget:self action:@selector(removeShareView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backgroundView];
    
    shareBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 44 + btnsHeight)];
    shareBackgroundView.backgroundColor = [UIColor whiteColor];
//    [self addSubview:shareBackgroundView];
    
    
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
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
            UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
            shareButton.frame = CGRectMake(shareX, shareY, kImageHeight, kImageHeight);
            [shareButton setImage:[UIImage imageNamed:imageArray[num]] forState:UIControlStateNormal];
            [shareButton setTitle:titleArray[num] forState:UIControlStateNormal];
            [shareButton addTarget:self action:@selector(didTapShareView:) forControlEvents:UIControlEventTouchUpInside];
            [shareBackgroundView addSubview:shareButton];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
            titleLabel.center = CGPointMake(shareButton.center.x, shareButton.center.y + kImageHeight/2 + 15);
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.text = titleArray[num];
            [shareBackgroundView addSubview:titleLabel];
        }
    }
    
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, btnsHeight, kScreenW, 0.4);
    line.backgroundColor = kLineGrayCorlor.CGColor;
    [shareBackgroundView.layer addSublayer:line];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(0, btnsHeight, kScreenW, 44);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancleButton addTarget:self action:@selector(removeShareView) forControlEvents:UIControlEventTouchUpInside];
    [shareBackgroundView addSubview:cancleButton];
    
    
//    [UIView animateWithDuration:0.2 animations:^{
//        shareMenuView.frame =CGRectMake(0,kScreenH - 170, kScreenW,170);
//        [Weakself addSubview:shareMenuView];
//        mainGrayBg.alpha = 0.3;
//    } completion:^(BOOL finished) {
//    }];
    __block ShareView *Weakself = self;
    [UIView animateWithDuration:0.4 animations:^{
        NSLog(@"hvdiruhnvrdiohnvodishnvdsjnv");
        [Weakself addSubview:shareBackgroundView];
        backgroundView.alpha = 0.4;
        shareBackgroundView.frame = CGRectMake(0, kScreenH - (44 + btnsHeight), kScreenW, 44 + btnsHeight);
        
    }];
    
}

- (void)getShareArray {
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


- (void)didTapShareView:(UIButton *)button {
    [self removeShareView];
    if ([button.titleLabel.text isEqualToString:@"微信朋友圈"]) {
        NSLog(@"微信朋友圈");
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.title;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.message image:self.pictureName location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            } else {
                NSLog(@"分享失败！");
            }
        }];
        
    } else if ([button.titleLabel.text isEqualToString:@"微信好友"]) {
        NSLog(@"微信好友");
        [UMSocialData defaultData].extConfig.wechatSessionData.title = self.title;
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.message image:self.pictureName location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            } else {
                NSLog(@"分享失败！");
            }
        }];
        
        
    } else if ([button.titleLabel.text isEqualToString:@"QQ"]) {
        NSLog(@"QQ");
        [UMSocialData defaultData].extConfig.qqData.url = self.shareUrl;
        [UMSocialData defaultData].extConfig.qqData.title = self.title;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.message image:self.pictureName location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
        
        
    } else if ([button.titleLabel.text isEqualToString:@"QQ空间"]) {
        NSLog(@"QQ空间");
        [UMSocialData defaultData].extConfig.qzoneData.url = self.shareUrl;
        [UMSocialData defaultData].extConfig.qzoneData.title = self.title;
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.message image:self.pictureName location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
        
    } else if ([button.titleLabel.text isEqualToString:@"邮件"]) {
        NSLog(@"邮件");
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToEmail] content:[NSString stringWithFormat:@"%@%@", self.title, self.shareUrl] image:nil location:nil urlResource:nil presentedController:self.myViewController completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
        
        
    } else if ([button.titleLabel.text isEqualToString:@"短信"]) {
        NSLog(@"短信");
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:[NSString stringWithFormat:@"%@%@", self.title, self.shareUrl] image:nil location:nil urlResource:nil presentedController:self.myViewController completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
}

- (void)removeShareView {

    [UIView animateWithDuration:0.3 animations:^{
        shareBackgroundView.frame =CGRectMake(0, kScreenH, kScreenH, 120);
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
