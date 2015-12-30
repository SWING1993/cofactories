//
//  LoginViewController.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/9.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Tools.h"
#import "HttpClient.h"
#import "blueButton.h"
#import "tablleHeaderView.h"
#import "LoginViewController.h"
#import "ResetPasswordViewController.h"
#import "RegisterViewController.h"
#import "RootViewController.h"

static NSString * const CellIdentifier = @"CellIdentifier";

@interface LoginViewController () <UIAlertViewDelegate>{
    UITextField*_usernameTF;

    UITextField*_passwordTF;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //判断网络状态 给用户相应提示
    [Tools AFNetworkReachabilityStatusReachableVia];
    
    self.title=@"登录";
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor = [UIColor whiteColor];

    tablleHeaderView*tableHeaderView = [[tablleHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, tableHeaderView_height)];
    self.tableView.tableHeaderView = tableHeaderView;

    UIView * tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 80)];
    UIButton*loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame =  CGRectMake(20, 15, (kScreenW-40), 35);
    loginBtn.tag=0;
    loginBtn.layer.cornerRadius=5.0f;
    loginBtn.layer.masksToBounds=YES;
    loginBtn.layer.borderColor = [UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f].CGColor;
    loginBtn.layer.borderWidth = 1.0f;
    loginBtn.backgroundColor = [UIColor whiteColor];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(clickbBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:loginBtn];


    //注册 button
    UIButton*registerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
      registerBtn.frame =CGRectMake((kScreenW-40)/2+40, 60, (kScreenW-40)/2-20, 40);
//        registerBtn.backgroundColor = [UIColor redColor];
    registerBtn.tag=1;
    registerBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(clickbBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:registerBtn];

    UIButton*forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.frame = CGRectMake(20, 60, (kScreenW-40)/2-20, 40);
    forgetBtn.tag=2;
    forgetBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(clickbBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:forgetBtn];

    self.tableView.tableFooterView = tableFooterView;
    [self createUI];
}
- (void)createUI {
    if (!_usernameTF) {
        UIImageView*userTFView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 23)];
        userTFView.image = [UIImage imageNamed:@"login_user"];
        _usernameTF.font = [UIFont systemFontOfSize:15.0f];
        _usernameTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _usernameTF.leftView = userTFView;
        _usernameTF.leftViewMode = UITextFieldViewModeAlways;
        _usernameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _usernameTF.placeholder=@"手机号";
        _usernameTF.keyboardType = UIKeyboardTypeNumberPad;
    }

    if (!_passwordTF) {
        UIImageView*passTFView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 23)];
        passTFView.image = [UIImage imageNamed:@"login_key"];
        _passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _passwordTF.leftView = passTFView;
        _passwordTF.leftViewMode = UITextFieldViewModeAlways;
        _passwordTF.secureTextEntry=YES;
        _passwordTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _passwordTF.placeholder=@"密码";

    }
}

- (void)clickbBtn:(UIButton*)sender{
    UIButton*button=(UIButton*)sender;
    switch (button.tag) {
        case 0:{
            DLog(@"登录");
            MBProgressHUD *hud = [Tools createHUD];
            hud.labelText = @"登录中...";
            

            [button setEnabled:NO];
            if (_passwordTF.text.length == 0||_usernameTF.text.length == 0) {
                [button setEnabled:YES];
                [hud hide:YES];
                kTipAlert(@"请您填写账号以及密码后登录!");
            }else{
                [HttpClient loginWithUsername:_usernameTF.text password:_passwordTF.text andBlock:^(NSInteger statusCode) {
                    switch (statusCode) {
                        case 0:{
                            [hud hide:YES];
                            [button setEnabled:YES];
                            kTipAlert(@"您的网络状态不太顺畅哦！");
                        }
                            break;
                        case 200:{
                            [hud hide:YES];

                            DLog(@"登录成功");
                            [button setEnabled:YES];
                            [RootViewController setupTabarController];

                        }
                            break;
                        case 401:{
                            [hud hide:YES];

                            [button setEnabled:YES];
                            kTipAlert(@"用户名或密码错误！");
                        }
                            break;
                            
                        default:
                            [hud hide:YES];

                            [button setEnabled:YES];
                            kTipAlert(@"登录失败！(错误码：%ld)",(long)statusCode);
                            break;
                    }
                }];
            }
        }
            break;
        case 1:{
            DLog(@"注册账号");
            RegisterViewController*registerVC = [[RegisterViewController alloc]init];
            [self.navigationController pushViewController:registerVC animated:YES];
         
        }
            break;
       
        case 2:{
            DLog(@"忘记密码");
            ResetPasswordViewController*resetVC = [[ResetPasswordViewController alloc]init];
            UINavigationController*resetNav = [[UINavigationController alloc]initWithRootViewController:resetVC];
            resetNav.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:resetNav animated:YES completion:nil];
        }
            break;
        default:
            DLog(@"无该case");
            break;
    }
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (indexPath.row == 0) {
            [cell addSubview:_usernameTF];
        }
        if (indexPath.row == 1) {
            [cell addSubview:_passwordTF];
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)dealloc {
    DLog(@"登录dealloc");
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

@end
