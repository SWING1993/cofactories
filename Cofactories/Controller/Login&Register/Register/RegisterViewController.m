//
//  RegisterViewController.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/10.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Tools.h"
#import "HttpClient.h"
#import "blueButton.h"
#import "tablleHeaderView.h"
#import "RegisterViewController.h"
#import "SecondRegisterViewController.h"
#import "UserProtocolViewController.h"

static NSString * const CellIdentifier = @"CellIdentifier";

@interface RegisterViewController () {

}

@property (nonatomic,copy) NSString * statusCode;

@property (nonatomic,assign) BOOL isSeletecd;

@end

@implementation RegisterViewController{

    UITextField*_usernameTF;//账号
    UITextField*_passwordTF;//密码
   
    UITextField*_codeTF;//验证码
    
    NSTimer*timer;
    NSInteger seconds;
    UIButton*authcodeBtn;


}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"注册";
    
    self.isSeletecd = YES;
    DLog(@"isSeletecd = %d",self.isSeletecd);


    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor = [UIColor whiteColor];

    tablleHeaderView*tableHeaderView = [[tablleHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, tableHeaderView_height)];
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

    blueButton*nextBtn=[[blueButton alloc]initWithFrame:CGRectMake(20, 50, kScreenW-40, 35)];;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:nextBtn];
    self.tableView.tableFooterView = tableFooterView;
    [self createUI];
}

- (void)createUI {

    if (!_usernameTF) {
        _usernameTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _usernameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _usernameTF.keyboardType = UIKeyboardTypeNumberPad;
        _usernameTF.placeholder=@"手机号";
    }

    if (!_passwordTF) {
        _passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _passwordTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _passwordTF.placeholder=@"密码(6位及以上)";
        _passwordTF.secureTextEntry=YES;
    }

    if (!_codeTF) {
        _codeTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-118, 44)];
        _codeTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _codeTF.keyboardType = UIKeyboardTypeNumberPad;
        _codeTF.placeholder=@"验证码";
    }

    if (!authcodeBtn) {
        authcodeBtn=[[blueButton alloc]initWithFrame:CGRectMake(kScreenW-100, 7, 90, 30)];

        authcodeBtn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        [authcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [authcodeBtn addTarget:self action:@selector(sendCodeBtn) forControlEvents:UIControlEventTouchUpInside];

    }

}

//倒计时方法验证码实现倒计时60秒，60秒后按钮变换开始的样子
-(void)timerFireMethod:(NSTimer *)theTimer {
    if (seconds == 1) {
        [theTimer invalidate];
        seconds = 60;
        authcodeBtn.titleLabel.text = @"重新获取";
        [authcodeBtn setTitle:@"重新获取" forState: UIControlStateNormal];
        [authcodeBtn setEnabled:YES];
    }else{
        seconds--;
        [authcodeBtn setEnabled:NO];
        NSString *title = [NSString stringWithFormat:@"倒计时%lds",(long)seconds];
        authcodeBtn.titleLabel.text = title;
        [authcodeBtn setTitle:title forState:UIControlStateNormal];
        [authcodeBtn.titleLabel sizeToFit];

    }
}
//如果登陆成功，停止验证码的倒数，
- (void)releaseTImer {
    if (timer) {
        if ([timer respondsToSelector:@selector(isValid)]) {
            if ([timer isValid]) {
                [timer invalidate];
                seconds = 60;
            }
        }
    }
}

- (void)sendCodeBtn{
    [authcodeBtn setEnabled:NO];
    if (_usernameTF.text.length==11) {
        [HttpClient postVerifyCodeWithPhone:_usernameTF.text andBlock:^(NSDictionary *responseDictionary) {
            NSInteger  statusCode = [[responseDictionary objectForKey:@"statusCode"] integerValue];
            NSString * message = [responseDictionary objectForKey:@"message"];
            
            if (statusCode == 200) {
//                [Tools showSuccessWithStatus:message];
                kTipAlert(@"%@", message);
                [authcodeBtn setEnabled:NO];
                seconds = 60;
                timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];

            }else{
//                [Tools showErrorWithStatus:message];
                kTipAlert(@"%@ （错误码：%ld）", message,(long)statusCode);
                [authcodeBtn setEnabled:YES];
            }
        }];
    }else{
//                [Tools showErrorWithStatus:@"您输入的是一个无效的手机号码!"];
        kTipAlert(@"您输入的是一个无效的手机号码!");
        [authcodeBtn setEnabled:YES];
    }
}


- (void)registerBtnClick {
    if (_usernameTF.text.length==0 || _passwordTF.text.length==0 || _codeTF.text.length==0 ) {
        kTipAlert(@"注册信息不完整!");
    }
    else if (!self.isSeletecd){
        kTipAlert(@"未同意注册用户协议。");
    }
    else {
        if (_passwordTF.text.length<6) {
            kTipAlert(@"密码长度太短！");
        }else{
            
            MBProgressHUD *hud = [Tools createHUD];
            hud.labelText = @"正在验证...";
            [HttpClient validateCodeWithPhone:_usernameTF.text code:_codeTF.text andBlock:^(NSInteger statusCode) {
                DLog(@"验证  验证码code==%ld",(long)statusCode);
                if (statusCode == 200) {
                    hud.labelText = @"验证成功!";
                    [hud hide:YES];
                    DLog(@"注册信息：%@、%@、%@",_usernameTF.text,_passwordTF.text,_codeTF.text);
                    SecondRegisterViewController * registerVC = [[SecondRegisterViewController alloc]init];
                    registerVC.phone = _usernameTF.text;
                    registerVC.password = _passwordTF.text;
                    registerVC.code = _codeTF.text;
                    [self.navigationController pushViewController:registerVC animated:YES];
                }
                else if (statusCode == 0) {
                    [hud hide:YES];
                    kTipAlert(@"您的网络状态不太顺畅哦！");
                }
                
                else {
                    [hud hide:YES];
                    kTipAlert(@"验证码过期或者无效!");
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
            [cell addSubview:_usernameTF];
        }
        else if (indexPath.row == 1) {
            [cell addSubview:_passwordTF];
        }
        else if (indexPath.row == 2) {
            [cell addSubview:_codeTF];
            [cell addSubview:authcodeBtn];
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

    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

@end
