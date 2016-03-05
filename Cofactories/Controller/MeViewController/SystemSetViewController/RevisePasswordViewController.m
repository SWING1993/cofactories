//
//  RevisePasswordViewController.m
//  cofactory-1.1
//
//  Created by 宋国华 on 15/7/16.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "HttpClient.h"
#import "LoginButton.h"
#import "RevisePasswordViewController.h"


static NSString * CellIdentifier = @"CellIdentifier";

@interface RevisePasswordViewController ()<UIAlertViewDelegate>

@end

@implementation RevisePasswordViewController
UITextField*oldPasswordTF;
UITextField*passwordTF;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"修改密码";
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.rowHeight = 40;

    oldPasswordTF=[[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-30, 40)];
    oldPasswordTF.clearButtonMode=YES;
    oldPasswordTF.secureTextEntry=YES;
    oldPasswordTF.font = kFont;
    oldPasswordTF.placeholder=@"输入旧密码";

    passwordTF=[[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-30, 40)];
    passwordTF.clearButtonMode=YES;
    passwordTF.secureTextEntry=YES;
    passwordTF.font = kFont;
    passwordTF.placeholder=@"6-16个字符，区分大小写";


    UIView*tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 70)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    LoginButton*nextBtn=[[LoginButton alloc]initWithFrame:CGRectMake(20, 20, kScreenW-40, 35)];
    [nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(RevisePasswordBtn) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:nextBtn];
    self.tableView.tableFooterView = tableFooterView;

    //设置Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.leftBarButtonItem = setButton;
}

- (void)buttonClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && alertView.tag == 200) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)RevisePasswordBtn {
    if (oldPasswordTF.text.length==0 && passwordTF.text.length==0) {
        kTipAlert(@"密码不能为空");
    }else if (passwordTF.text.length<6 || passwordTF.text.length>16) {
        kTipAlert(@"新密码长度应该在6—16个字符之间");
    }else{
        [HttpClient changePassword:oldPasswordTF.text newPassword:passwordTF.text andBlock:^(NSInteger statusCode) {
            switch (statusCode) {
                case 200:
                {
                    UIAlertView * successAlert = [[UIAlertView alloc]initWithTitle:@"密码修改成功"
                                                                           message:nil
                                                                          delegate:self
                                                                 cancelButtonTitle:@"取消"
                                                                 otherButtonTitles:@"知道了", nil];
                    successAlert.tag = 200;
                    [successAlert show];
                    
                }
                    break;
                case 403:
                {
                    kTipAlert(@"旧密码错误");
                }
                    break;
                    
                default:
                    kTipAlert(@"修改失败，尝试重新修改！(%ld)",(long)statusCode);
                    break;
            }
        }];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.section) {
        case 0:{
            [cell addSubview:oldPasswordTF];

        }
            break;
        case 1:{
            [cell addSubview:passwordTF];

        }
            break;

        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 20)];
    UILabel*titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 2.5, kScreenW-20, 20)];
    titleLabel.font=kFont;
    switch (section) {
        case 0:{
            titleLabel.text=@"旧密码";
        }
            break;
        case 1:{
            titleLabel.text=@"新密码";
        }
            break;

        default:
            break;
    }
    [view addSubview:titleLabel];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
