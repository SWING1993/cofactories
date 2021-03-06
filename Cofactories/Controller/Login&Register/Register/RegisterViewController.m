//
//  RegisterViewController.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/10.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Tools.h"
#import "HttpClient.h"
#import "LoginButton.h"
#import "LoginTableHeaderView.h"
#import "RegisterViewController.h"
#import "SecondRegisterViewController.h"
#import "UserProtocolViewController.h"

static NSString * const CellIdentifier = @"CellIdentifier";

@interface RegisterViewController () {

}

@property (nonatomic, copy) NSString * statusCode;
@property (nonatomic, assign) BOOL isSeletecd;
@property (strong, nonatomic) UITextField * usernameTF,* passwordTF,* codeTF;
@property (strong, nonatomic) LoginButton * authcodeBtn,* nextBtn ;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isSeletecd = YES;
    DLog(@"用户协议 = %d",self.isSeletecd);
    [self createViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldCharge) name:UITextFieldTextDidChangeNotification object:nil];

}

- (void)createViews {
    
    self.title=@"注册";
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.tableView = ({
        UITableView * tableView = [[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView;
    });

    
    LoginTableHeaderView*tableHeaderView = [[LoginTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kLogintTableHeaderView_height)];
    self.tableView.tableHeaderView = tableHeaderView;
    
    UIView * tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.selected = self.isSeletecd;
    [leftBtn setImage:[UIImage imageNamed:@"leftBtn_Normal"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"leftBtn_Selected"] forState:UIControlStateSelected];
    leftBtn.frame = CGRectMake(25, 15, 20, 20);
    [leftBtn addTarget:self action:@selector(clickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:leftBtn];
    
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(60, 10, kScreenW - 80, 30);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setTitle:@"同意《聚工厂用户服务协议》" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = kFont;
    [btn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:btn];
    
    if (!_nextBtn) {
        
        _nextBtn = [[LoginButton alloc]initWithFrame:CGRectMake(20, 50, kScreenW-40, 35)];;
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.userInteractionEnabled = NO;
        [_nextBtn changeState:_nextBtn.userInteractionEnabled];
        [tableFooterView addSubview:_nextBtn];
    }
    self.tableView.tableFooterView = tableFooterView;

    
    if (!_usernameTF) {
        _usernameTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _usernameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _usernameTF.keyboardType = UIKeyboardTypeNumberPad;
        _usernameTF.font = [UIFont systemFontOfSize:15];
        _usernameTF.placeholder = @" 手机号";
    }

    if (!_passwordTF) {
        _passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTF.placeholder = @" 密码(6位及以上)";
        _passwordTF.font = [UIFont systemFontOfSize:15];
        _passwordTF.secureTextEntry = YES;
    }

    if (!_codeTF) {
        _codeTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-118, 44)];
        _codeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeTF.keyboardType = UIKeyboardTypeNumberPad;
        _codeTF.font = [UIFont systemFontOfSize:15];
        _codeTF.placeholder = @" 验证码";
        
    }

    if (!_authcodeBtn) {
        _authcodeBtn=[[LoginButton alloc]initWithFrame:CGRectMake(kScreenW-105, 7, 85, 30)];
        _authcodeBtn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        [_authcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_authcodeBtn addTarget:self action:@selector(sendCodeBtn) forControlEvents:UIControlEventTouchUpInside];

    }
}

- (void)textFieldCharge {
    if (self.usernameTF.text.length == 0 || self.passwordTF.text.length == 0 || self.codeTF.text.length == 0) {
        _nextBtn.userInteractionEnabled = NO;
        [_nextBtn changeState:_nextBtn.userInteractionEnabled];
    } else {
        _nextBtn.userInteractionEnabled = YES;
        [_nextBtn changeState:_nextBtn.userInteractionEnabled];
    }
}

- (void)sendCodeBtn {
    [self.authcodeBtn setEnabled:NO];
    [self.authcodeBtn addShakeAnimation];
    if (_usernameTF.text.length==11) {
        MBProgressHUD *hud = [Tools createHUD];
        hud.labelText = @"验证码发送中...";
        [HttpClient postVerifyCodeWithPhone:self.usernameTF.text andBlock:^(NSDictionary *responseDictionary) {
            NSInteger  statusCode = [[responseDictionary objectForKey:@"statusCode"] integerValue];
            NSString * message = [responseDictionary objectForKey:@"message"];
            if (statusCode == 200) {
                [hud  hide:YES];
                kTipAlert(@"%@", message);
                [self.authcodeBtn setEnabled:YES];
                [self.authcodeBtn startWithTime:60 title:@"点击重新获取" countDownTitle:@"s"];
            }else{
                [hud hide:YES];
                kTipAlert(@"%@ （%ld）", message,(long)statusCode);
                [self.authcodeBtn setEnabled:YES];
            }
        }];
    }else{
        kTipAlert(@"您输入的是一个无效的手机号码");
        [self.authcodeBtn setEnabled:YES];
    }
}


- (void)registerBtnClick {
    [self.nextBtn addShakeAnimation];
    if (self.usernameTF.text.length==0 || self.passwordTF.text.length==0 || self.codeTF.text.length==0 ) {
        kTipAlert(@"注册信息不完整");
    }
    else if (!self.isSeletecd){
        kTipAlert(@"未同意注册用户协议");
    }
    else {
        if (_passwordTF.text.length<6) {
            kTipAlert(@"密码长度太短");
        }else{
            MBProgressHUD *hud = [Tools createHUD];
            hud.labelText = @"正在验证...";
            [HttpClient validateCodeWithPhone:self.usernameTF.text code:self.codeTF.text andBlock:^(NSInteger statusCode) {
                DLog(@"验证  验证码code==%ld",(long)statusCode);
                if (statusCode == 200) {
                    DLog(@"注册信息：%@、%@、%@",_usernameTF.text,_passwordTF.text,_codeTF.text);
                    hud.labelText = @"验证成功";
                    [hud hide:YES];
                    SecondRegisterViewController * registerVC = [[SecondRegisterViewController alloc]init];
                    registerVC.phone = self.usernameTF.text;
                    registerVC.password = self.passwordTF.text;
                    registerVC.code = self.codeTF.text;
                    [self.navigationController pushViewController:registerVC animated:YES];
                }
                else if (statusCode == 0) {
                    [hud hide:YES];
                    kTipAlert(@"您的网络状态不太顺畅哦");
                }
                else {
                    [hud hide:YES];
                    kTipAlert(@"验证码过期或者无效");
                }
            }];
        }
    }
}
- (void)clickLeftBtn:(UIButton *)btn {
    self.isSeletecd = !self.isSeletecd;
    btn.selected = self.isSeletecd;
}
- (void)clickRightBtn {
    UserProtocolViewController * protocolVC = [[UserProtocolViewController alloc]init];
    UINavigationController * protocolNav = [[UINavigationController alloc]initWithRootViewController:protocolVC];
    [self presentViewController:protocolNav animated:YES completion:^{
    }];
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
            [cell addSubview:self.usernameTF];
        }
        else if (indexPath.row == 1) {
            [cell addSubview:self.passwordTF];
        }
        else if (indexPath.row == 2) {
            [cell addSubview:self.codeTF];
            [cell addSubview:self.authcodeBtn];
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
    DLog(@"注册1dealloc");
    self.tableView = nil;
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
