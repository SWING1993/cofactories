//
//  Contract_VC.m
//  Cofactories
//
//  Created by GTF on 16/1/13.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "Contract_VC.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface Contract_VC ()<UIAlertViewDelegate>

@end

@implementation Contract_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"合同";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"签署合同" style:UIBarButtonItemStylePlain target:self action:@selector(signClick)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self loadImage];
    
}

- (void)loadImage{
    UIButton *image = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64)];
    if (_isClothing) {
        [image setBackgroundImage:[UIImage imageWithData:_imageData] forState:UIControlStateNormal];
    }else{
        [image sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@",kBaseUrl,@"/order/factory/contract/",_orderID,@"?access_token=",[HttpClient getToken].accessToken]] forState:UIControlStateNormal];
        DLog(@"%@",[NSString stringWithFormat:@"%@%@%@%@%@",kBaseUrl,@"/order/factory/contract/",_orderID,@"?access_token=",[HttpClient getToken].accessToken]);
    }
    
    [image addTarget:self action:@selector(bigClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:image];
}

- (void)signClick{
    if (_isClothing) {
        [self.signContractDelegate signContract];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"合同签署成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alert.tag = 100;
        [alert show];
    }else{
        [HttpClient factorySignContractWithOrderID:_orderID WithCompletionBlock:^(NSDictionary *dictionary) {
            NSString *statusCode = dictionary[@"statusCode"];
            if ([statusCode isEqualToString:@"200"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"合同签署成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alert.tag = 200;
                [alert show];
            }
        }];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }if (alertView.tag == 200) {
        if (buttonIndex == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)bigClick{
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.image = [UIImage imageWithData:_imageData];
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.photos = @[photo];
    [browser show];

}
@end
