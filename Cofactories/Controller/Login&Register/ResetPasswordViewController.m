//
//  ResetPasswordViewController.m
//  cofactory-1.1
//
//  Created by 宋国华 on 15/7/20.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "HttpClient.h"
#import "Tools.h"
#import "LoginButton.h"
#import "LoginTableHeaderView.h"
#import "ResetPasswordViewController.h"

static NSString * const CellIdentifier = @"CellIdentifier";

@interface ResetPasswordViewController () <UIAlertViewDelegate>

@end

@implementation ResetPasswordViewController
UITextField * _usernameTF;//账号
UITextField * _passwordTF;//密码
UITextField * _codeTF;//验证码
LoginButton * _codeBtn;
LoginButton * _nextBtn;

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetPasswordtextFieldCharge) name:UITextFieldTextDidChangeNotification object:nil];
    [self createViews];
}

- (void)createViews {
    
    
    self.title=@"找回密码";
    
    //返回Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.rightBarButtonItem = setButton;
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    LoginTableHeaderView*tableHeaderView = [[LoginTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kLogintTableHeaderView_height)];
    self.tableView.tableHeaderView = tableHeaderView;
    
    UIView*tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 70)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    _nextBtn = [[LoginButton alloc]initWithFrame:CGRectMake(20, 20, kScreenW-40, 35)];
    [_nextBtn setTitle:@"重置密码" forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn.userInteractionEnabled = NO;
    [_nextBtn changeState:_nextBtn.userInteractionEnabled];
    [tableFooterView addSubview:_nextBtn];
    self.tableView.tableFooterView = tableFooterView;
    
    

    if (!_usernameTF) {
        _usernameTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _usernameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _usernameTF.keyboardType = UIKeyboardTypeNumberPad;
        _usernameTF.placeholder=@"手机号";
    }

    if (!_passwordTF) {
        _passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _passwordTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _passwordTF.secureTextEntry=YES;
        _passwordTF.placeholder=@"新密码（6位及以上）";
    }

    if (!_codeTF) {
        _codeTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-118, 44)];
        _codeTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _codeTF.keyboardType = UIKeyboardTypeNumberPad;
        _codeTF.placeholder=@"验证码";
    }

    if (!_codeBtn) {
        _codeBtn=[[LoginButton alloc]initWithFrame:CGRectMake(kScreenW-100, 7, 90, 30)];
        _codeBtn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn addTarget:self action:@selector(sendCodeBtn) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)resetPasswordtextFieldCharge {
    if (_usernameTF.text.length == 0 || _passwordTF.text.length == 0 || _codeTF.text.length == 0) {
        _nextBtn.userInteractionEnabled = NO;
        [_nextBtn changeState:_nextBtn.userInteractionEnabled];
    } else {
        _nextBtn.userInteractionEnabled = YES;
        [_nextBtn changeState:_nextBtn.userInteractionEnabled];
    }

}

- (void)buttonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextBtn {
    [_nextBtn addShakeAnimation];
    
    if (_passwordTF.text.length<6) {
        kTipAlert(@"密码长度应该是6位及以上！");
    } else {
        [HttpClient postResetPasswordWithPhone:_usernameTF.text code:_codeTF.text password:_passwordTF.text andBlock:^(NSInteger statusCode) {
            switch (statusCode) {
                case 0: {
                    kTipAlert(@"您的网络状态不太顺畅哦");
                }
                    break;
                    
                    
                case 200: {
                    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"密码重置成功"
                                                                      message:nil
                                                                     delegate:self
                                                            cancelButtonTitle:nil
                                                            otherButtonTitles:@"确定", nil];
                    alertView.tag = 10086;
                    [alertView show];
                }
                    break;
                    
               
                case 403: {
                    kTipAlert(@"验证码错误");
                }
                    break;
                    
                    
                case 404: {
                    kTipAlert(@"没有这个用户");
                }
                    break;
                    
                default:
                    kTipAlert(@"重置密码失败 （%ld）",(long)statusCode);
                    break;
            }
        }];
    }
}

- (void)sendCodeBtn{
    [_codeBtn setEnabled:NO];
    [_codeBtn addShakeAnimation];
    if (_usernameTF.text.length==11) {
        MBProgressHUD *hud = [Tools createHUD];
        hud.labelText = @"验证码发送中...";
        [HttpClient postVerifyCodeWithPhone:_usernameTF.text andBlock:^(NSDictionary *responseDictionary) {
            NSInteger  statusCode = [[responseDictionary objectForKey:@"statusCode"] integerValue];
            NSString * message = [responseDictionary objectForKey:@"message"];
            if (statusCode == 200) {
                [hud hide:YES];
                kTipAlert(@"%@", message);
                [_codeBtn setEnabled:YES];
                
                [_codeBtn startWithTime:60 title:@"点击重新获取" countDownTitle:@"s"];
                
            }else{
                [hud hide:YES];
                kTipAlert(@"%@", message);
                [_codeBtn setEnabled:YES];
            }
        }];
 
    }else{
        kTipAlert(@"您输入的是一个无效的手机号码！");
        [_codeBtn setEnabled:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10086) {
        if (buttonIndex == 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
        if (indexPath.row == 2) {
            [cell addSubview:_codeTF];
            [cell addSubview:_codeBtn];
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
    self.tableView = nil;
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
