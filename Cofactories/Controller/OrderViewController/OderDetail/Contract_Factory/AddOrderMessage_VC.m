//
//  AddOrderMessage_VC.m
//  Cofactories
//
//  Created by GTF on 16/1/14.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "AddOrderMessage_VC.h"

@interface AddOrderMessage_VC ()<UIAlertViewDelegate>{
    UIView *_bgVIew;
    UITextField *_textField;
}

@end

@implementation AddOrderMessage_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    _bgVIew = [[UIView alloc] init];
    _bgVIew.center = CGPointMake(self.view.center.x, self.view.center.y - 120);
    _bgVIew.bounds = CGRectMake(0, 0, kScreenW-30, kScreenW/2.f);
    _bgVIew.layer.masksToBounds = YES;
    _bgVIew.layer.cornerRadius = 5;
    _bgVIew.backgroundColor = [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:0.5];
    [self.view addSubview:_bgVIew];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(_bgVIew.frame.size.width - 30, 0, 30, 30)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"删除图片.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(goBackClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgVIew addSubview:backButton];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, _bgVIew.frame.size.width-40, 30)];
    _textField.layer.masksToBounds = YES;
    _textField.layer.borderWidth = 1.f;
    _textField.layer.cornerRadius = 5;
    [_bgVIew addSubview:_textField];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake((_bgVIew.frame.size.width-100)/2.f, 120, 100, 30);
    confirmButton.backgroundColor = MAIN_COLOR;
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [confirmButton setTitle:@"发布更新" forState:UIControlStateNormal];
    confirmButton.layer.masksToBounds = YES;
    confirmButton.layer.cornerRadius = 5;
    [confirmButton addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [_bgVIew addSubview:confirmButton];
}

- (void)confirmClick{
    if (_textField.text.length == 0 || [Tools isBlankString:_textField.text]) {
        kTipAlert(@"请先输入需要发布的内容!");
    }else{
        [HttpClient addOrderMessageWithOrderID:_orderID message:_textField.text WithCompletionBlock:^(NSDictionary *dictionary) {
            if ([dictionary[@"statusCode"] isEqualToString:@"200"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"订单发布更新成功!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alert.tag = 100;
                [alert show];
                
            }
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)goBackClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
