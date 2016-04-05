//
//  LoginViewController.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/9.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Input_OnlyText_Cell.h"
#import "Tools.h"
#import "HttpClient.h"
#import "LoginButton.h"
#import "LoginTableHeaderView.h"
#import "LoginViewController.h"
#import "ResetPasswordViewController.h"
#import "RegisterViewController.h"
#import "RootViewController.h"
#import "EaseInputTipsView.h"
#import "Login.h"

static NSString * const CellIdentifier = @"CellIdentifier";

@interface LoginViewController () <UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) Login *myLogin;
@property (strong, nonatomic) EaseInputTipsView *inputTipsView;
@property (strong, nonatomic) UIButton * enterpriseBtn;
@property (strong, nonatomic) UIButton * enterpriseBtn2;
@property (strong, nonatomic) LoginButton * loginBtn;
@property (assign, nonatomic) BOOL isEnterprise;

@end

@implementation LoginViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!_inputTipsView) {
        _inputTipsView = ({
            EaseInputTipsView *tipsView = [EaseInputTipsView tipsViewWithType:EaseInputTipsViewTypeLogin];
            tipsView.valueStr = nil;
            
            __weak typeof(self) weakSelf = self;
            tipsView.selectedStringBlock = ^(NSString *valueStr){
                [weakSelf.view endEditing:YES];
                weakSelf.myLogin.phone = valueStr;
                [weakSelf refreshIconUserImageWithKey:valueStr];
                [weakSelf.tableView reloadData];
            };
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
           
            [tipsView setY:CGRectGetMaxY(cell.frame) - 0.5];
            [self.tableView addSubview:tipsView];
            tipsView;
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.myLogin = [[Login alloc] init];
    self.myLogin.phone = [Login preUserPhone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoActionRecharge) name:UITextFieldTextDidChangeNotification object:nil];

    [self createViews];
}

- (void)createViews {
    
    self.title=@"登录";
    self.tableView = ({
        UITableView * tableView = [[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.backgroundColor = [UIColor whiteColor];
        [tableView registerClass:[Input_OnlyText_Cell class] forCellReuseIdentifier:kCellIdentifier_Input_OnlyText_Cell_Text];
        LoginTableHeaderView*tableHeaderView = [[LoginTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kLogintTableHeaderView_height)];
        tableView.tableHeaderView = tableHeaderView;
        tableView;
    });
    
    UIView * tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
    
    //企业账号
    self.enterpriseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.enterpriseBtn.frame = CGRectMake(kScreenW - 45, 10, 20, 20);
    self.enterpriseBtn.tag = 9;
    self.enterpriseBtn.selected = self.isEnterprise;
    [self.enterpriseBtn setImage:[UIImage imageNamed:@"leftBtn_Normal"] forState:UIControlStateNormal];
    [self.enterpriseBtn setImage:[UIImage imageNamed:@"leftBtn_Selected"] forState:UIControlStateSelected];
    
    [self.enterpriseBtn addTarget:self action:@selector(clickbBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:self.enterpriseBtn];
    
    self.enterpriseBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.enterpriseBtn2.frame = CGRectMake(kScreenW - 110, 10, 60, 20);
    self.enterpriseBtn2.tag = 9;
    self.enterpriseBtn2.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.enterpriseBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.enterpriseBtn2 setTitleColor:[UIColor redColor] forState:UIControlStateSelected];

    self.enterpriseBtn2.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.enterpriseBtn2 setTitle:@"企业账号" forState:UIControlStateNormal];
    [self.enterpriseBtn2 addTarget:self action:@selector(clickbBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:self.enterpriseBtn2];

//        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 110, 10, 60, 20)];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.text = @"企业账号";
//        label.textColor = [UIColor blackColor];
//        label.font = [UIFont boldSystemFontOfSize:14];
//        label;
    
    
    //登录 Button
    _loginBtn  = [[LoginButton alloc]init];
    _loginBtn.frame =  CGRectMake(20, 40, (kScreenW-40), 35);
    _loginBtn.userInteractionEnabled = NO;
    [_loginBtn changeState:_loginBtn.userInteractionEnabled];
    _loginBtn.tag=10;
    _loginBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16.5];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(clickbBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [tableFooterView addSubview:_loginBtn];
   
    //注册 button
    UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    registerBtn.frame =CGRectMake((kScreenW-40)/2+40, 75, (kScreenW-40)/2-20, 55);
    registerBtn.tag=11;
    registerBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [registerBtn setTitle:@"去注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(clickbBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:registerBtn];
    
    UIButton * forgetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    forgetBtn.frame = CGRectMake(20, 75, (kScreenW-40)/2-20, 55);
    forgetBtn.tag=12;
    forgetBtn.titleLabel.font=[UIFont boldSystemFontOfSize:14.5];
    forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(clickbBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:forgetBtn];
    
    self.tableView.tableFooterView = tableFooterView;
    [self refreshIconUserImageWithKey:self.myLogin.phone];
}


- (void)infoActionRecharge {
    if (self.myLogin.phone.length == 0 || self.myLogin.password.length == 0) {
        self.loginBtn.userInteractionEnabled = NO;
    } else {
        self.loginBtn.userInteractionEnabled = YES;
    }
    [self.loginBtn changeState:self.loginBtn.userInteractionEnabled];
}

- (void)clickbBtn:(UIButton*)sender{
    UIButton*button=(UIButton*)sender;
    switch (button.tag) {
        case 9:{
            self.isEnterprise = !self.isEnterprise;
            self.enterpriseBtn.selected = self.isEnterprise;
            self.enterpriseBtn2.selected = self.isEnterprise;
            if (self.isEnterprise) {
                [Tools showHudTipStr:@"企业账号登录"];
            }else {
                [Tools showHudTipStr:@"普通账号登录"];
            }
            DLog(@"企业账号:%d",self.isEnterprise);
        }
            break;
            
        case 10:{
            DLog(@"登录");
            [button setEnabled:NO];
            [button addShakeAnimation];                      
            MBProgressHUD *hud = [Tools createHUD];
            hud.labelText = @"登录中...";
            if (self.myLogin.phone.length == 0||self.myLogin.password.length == 0) {
                [button setEnabled:YES];
                [hud hide:YES];
                [Tools showErrorTipStr:@":）请您填写账号以及密码后登录"];
//                kTipAlert(@":）请您填写账号以及密码后登录");
            }else{
                [HttpClient loginWithUsername:self.myLogin.phone Password:self.myLogin.password Enterprise:self.isEnterprise andBlock:^(NSInteger statusCode) {
                    switch (statusCode) {
                        case 0:{
                            [hud hide:YES];
                            [button setEnabled:YES];
                            [Tools showErrorTipStr:@":）您的网络状态不太顺畅哦"];
//                            kTipAlert(@":）您的网络状态不太顺畅哦");
                        }
                            break;
                            
                        case 200:{
                            DLog(@"登录成功");
                            
                            [hud hide:YES];
                            [button setEnabled:YES];
                            [Login setPreUserPhone:self.myLogin.phone];//记住登录账号
                            [RootViewController setupTabarController];
                            double delayInSeconds = 7.0;
                            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                                [Login saveLoginData];
                            });
                            
                        }
                            break;
                            
                        case 401:{
                            [hud hide:YES];
                            [button setEnabled:YES];
                            [Tools showErrorTipStr:@":）用户名或密码错误"];
//                            kTipAlert(@":）用户名或密码错误");
                            
                        }
                            break;
                            
                        default:
                            [hud hide:YES];
                            [button setEnabled:YES];
                            kTipAlert(@"登录失败 (%ld)",(long)statusCode);
                            break;
                    }
                }];
            }
        }
            break;
            
        case 11:{
            DLog(@"注册账号");
            RegisterViewController*registerVC = [[RegisterViewController alloc]init];
            [self.navigationController pushViewController:registerVC animated:YES];
         
        }
            break;
       
        case 12:{
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
- (void)refreshIconUserImageWithKey:(NSString *)phone{
    if (phone.length == 0) {
        [LoginTableHeaderView changeImageWithUid:nil];
    }else {
        NSString * uid = [[Login readLoginDataList]objectForKey:phone];
        [LoginTableHeaderView changeImageWithUid:uid];
    }
}


/*
- (UIImageView *)bgBlurredView{
    if (!_bgBlurredView) {
        //背景图片
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:kScreenBounds];
        bgView.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *bgImage = [UIImage imageNamed:@"bgg"];
        bgView.image = bgImage;

        //黑色遮罩
        UIColor *blackColor = [UIColor blackColor];
        [bgView addGradientLayerWithColors:@[(id)[blackColor colorWithAlphaComponent:0.3].CGColor,
                                             (id)[blackColor colorWithAlphaComponent:0.3].CGColor]
                                 locations:nil
                                startPoint:CGPointMake(0.5, 0.0) endPoint:CGPointMake(0.5, 1.0)];
        _bgBlurredView = bgView;
    }
    return _bgBlurredView;
}
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Input_OnlyText_Cell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Input_OnlyText_Cell_Text forIndexPath:indexPath];
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [cell setPlaceholder:@" 手机号码" value:self.myLogin.phone];
        cell.textValueChangedBlock = ^(NSString *valueStr){
            weakSelf.inputTipsView.valueStr = valueStr;
            weakSelf.inputTipsView.active = YES;
            weakSelf.myLogin.phone = valueStr;
            [weakSelf refreshIconUserImageWithKey:valueStr];
        };
        cell.editDidBeginBlock = ^(NSString *valueStr){
            weakSelf.inputTipsView.valueStr = valueStr;
            weakSelf.inputTipsView.active = YES;
        };
        cell.editDidEndBlock = ^(NSString *textStr){
            weakSelf.inputTipsView.active = NO;
            [weakSelf refreshIconUserImageWithKey:textStr];

        };
    }else if (indexPath.row == 1){
        [cell setPlaceholder:@" 密码" value:self.myLogin.password];
        cell.textField.secureTextEntry = YES;
        cell.textValueChangedBlock = ^(NSString *valueStr){
            weakSelf.myLogin.password = valueStr;
        };
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
