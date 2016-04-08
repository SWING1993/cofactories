//
//  PublishPopularNews_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/30.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "PublishPopularNews_VC.h"
#import "ZGYAttributedStyle.h"

@interface PublishPopularNews_VC ()

@end

@implementation PublishPopularNews_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"流行资讯发布";
    UILabel *publishLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*kZGY, 64 + 20*kZGY, kScreenW - 20*kZGY, 200*kZGY)];
//    publishLabel.backgroundColor = [UIColor redColor];
    publishLabel.numberOfLines = 0;
    NSString *myString = @"欢迎各位设计师大大！\n      要发布流行资讯的话，只需把内容发送到我们公司的邮箱（design@cofactories.com）就可以了！我们会用最快的速度审核，审核通过就会帮您排版发布了。希望各位设计师大大多多投稿哟~";
    NSString *blueString = @"design@cofactories.com";
    
    NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc]initWithString:myString];
    NSRange colorRange = [[attributedString string] rangeOfString:blueString];
    
    publishLabel.attributedText = [myString creatAttributedStringWithStyles:@[fontStyle([UIFont fontWithName: @"Heiti TC" size: 17*kZGY], NSMakeRange(0, myString.length)), colorStyle([UIColor blueColor], colorRange), paragraphStyle(10*kZGY, NSMakeRange(0, myString.length))]];
    
    
    [self.view addSubview:publishLabel];
}


@end
