//
//  PublishOrder_VC.m
//  Cofactories
//
//  Created by GTF on 15/11/27.
//  Copyright © 2015年 宋国华. All rights reserved.
//
#define BUTTON_WIDETH   (kScreenW-4*40)/3.f

#import "SelectOrder_VC.h"
#import "PublishOrder_Common_VC.h"
#import "PublishOrder_Factory_VC.h"
#import "PublishOrder_Other_VC.h"
#import "PublishOrder_Factory_Other_VC.h"
#import "PublishOrder_Three_VC.h"
#import "PublishOrder_Design_VC.h"
@interface SelectOrder_VC ()
@property(nonatomic,strong)UserModel *userModel;

@end

@implementation SelectOrder_VC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.userModel = [[UserModel alloc] getMyProfile];
    DLog(@">>>>>++%ld",(long)_userModel.UserType);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, kScreenW, kScreenH/3)];
    titleLabel.text = @"请选择订单需求";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:titleLabel];
    
    NSArray *buttonImageArray = @[@"找面料",@"找辅料",@"找机械设备",@"找设计师",@"找加工厂",@"找其他生产配套"];
    for (int i = 0; i<6; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(40+(i%3)*(40+BUTTON_WIDETH), kScreenH/3.f+(i/3)*(40+BUTTON_WIDETH), BUTTON_WIDETH, BUTTON_WIDETH);
        [button setBackgroundImage:[UIImage imageNamed:buttonImageArray[i]] forState:UIControlStateNormal];
        button.tag = i+1;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y+BUTTON_WIDETH, BUTTON_WIDETH, 30)];
        label.textColor =[UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        if (iphone6_4_7) {
            label.font = [UIFont systemFontOfSize:12];
        }else{
            label.font = [UIFont systemFontOfSize:10];
        }
        label.text = buttonImageArray[i];
        [self.view addSubview:label];
        
        if (i==5) {
            label.frame = CGRectMake(button.frame.origin.x-8, button.frame.origin.y+BUTTON_WIDETH, BUTTON_WIDETH+20, 30);
        }
    }
}

- (void)buttonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    DLog(@"%ld",(long)button.tag);
    switch (button.tag) {
        case 4:
            [self.navigationController pushViewController:[PublishOrder_Design_VC new] animated:YES];
            break;
        case 5:
            if (_userModel.UserType == 1) {
                //服装厂可以发限制加工厂订单
                [self.navigationController pushViewController:[PublishOrder_Factory_VC new] animated:YES];
            }else{
                //其他身份发普通订单
                [self.navigationController pushViewController:[PublishOrder_Factory_Other_VC new] animated:YES];
            }
            break;
        case 6:
            [self.navigationController pushViewController:[PublishOrder_Other_VC new] animated:YES];
            break;
        default:
        {
            PublishOrder_Three_VC *vc = [[PublishOrder_Three_VC alloc] init];
            vc.orderType = button.tag-1;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
}

- (void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
