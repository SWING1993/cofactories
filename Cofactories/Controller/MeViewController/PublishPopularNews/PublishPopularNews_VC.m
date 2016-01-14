//
//  PublishPopularNews_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/30.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "PublishPopularNews_VC.h"

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
    NSString *mystring1 = @"欢迎各位设计师大大！\n      要发布流行资讯的话，只需把内容发送到我们公司的邮箱（";
    NSInteger from = mystring1.length;
    //修改行间距
    NSMutableParagraphStyle *paraStyle02 = [[NSMutableParagraphStyle alloc] init];
    paraStyle02.lineSpacing = 10*kZGY;
    NSDictionary *attrDict02 = @{ NSParagraphStyleAttributeName: paraStyle02,
                                  NSFontAttributeName: [UIFont systemFontOfSize: 17*kZGY] };
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: myString attributes: attrDict02];
    /*
     Heiti TC
     Gurmukhi MN
     Kohinoor Devanagari
     Sinhala Sangam MN
     Superclarendon
     Gujarati Sangam MN
     Avenir
     Optima
     */
    
    //设置字体样式
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName: @"Heiti TC" size: 17*kZGY] range:NSMakeRange(0, myString.length)];
    //修改某个范围内字体的颜色
    [attributedString addAttribute: NSForegroundColorAttributeName value: [UIColor blueColor] range: NSMakeRange(from, 22)];
    publishLabel.attributedText = attributedString;
    [self.view addSubview:publishLabel];
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
