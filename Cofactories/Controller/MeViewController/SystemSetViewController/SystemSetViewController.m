//
//  SystemSetViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "blueButton.h"
#import "UMSocial.h"
#import "UMFeedback.h"
#import "RootViewController.h"
#import "SystemSetViewController.h"
#import "AboutViewController.h"
#import "RevisePasswordViewController.h"



@interface SystemSetViewController ()<UIAlertViewDelegate,UMSocialUIDelegate>

@end

@implementation SystemSetViewController {
    UITextField*inviteCodeTF;
    UIButton*quitButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserModel * model = [[UserModel alloc]getMyProfile];
    
    self.title=@"设置";
    
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    
    inviteCodeTF=[[UITextField alloc]initWithFrame:CGRectMake(70, 7, 100, 30)];
    inviteCodeTF.font = kFont;
    inviteCodeTF.borderStyle=UITextBorderStyleRoundedRect;
    inviteCodeTF.keyboardType=UIKeyboardTypeNumberPad;
    inviteCodeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    inviteCodeTF.placeholder=@"邀请码";
    if (![model.inviteCode isEqualToString:@"尚未填写"]) {
        inviteCodeTF.text = model.inviteCode;
    }
    
    
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    
    quitButton=[[UIButton alloc]initWithFrame:CGRectMake(50, 7, kScreenW-100, 30)];
    quitButton.titleLabel.font = kFont;
    [quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [quitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //loginBtn.alpha=0.8f;
    [quitButton addTarget:self action:@selector(quitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)quitButtonClicked{
    
    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"确定退出" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==1) {
        [HttpClient deleteToken];
        [RootViewController setupLoginViewController];
    }
}

- (void)OKBtn {
    if (inviteCodeTF.text.length!=0) {
        [HttpClient registerWithInviteCode:inviteCodeTF.text andBlock:^(NSInteger statusCode) {
            if (statusCode == 200) {
                kTipAlert(@"邀请码提交成功!");
            }
            else if (statusCode == 409) {
                kTipAlert(@"该用户已存在邀请码！");
            }
            else {
                kTipAlert(@"邀请码提交失败，尝试重新提交。(错误码：%ld)",(long)statusCode);
            }
        }];
    }else{
        kTipAlert(@"请您填写邀请码后再提交!");
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.font=kFont;
        cell.detailTextLabel.textColor=[UIColor blackColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        switch (indexPath.section) {
            case 0:{
                cell.textLabel.text=@"修改密码";
                
            }
                break;
                
                
            case 1:{
                cell.textLabel.text=@"意见反馈";
                
            }
                
                break;
            case 2:{
                cell.textLabel.text=@"分享给好友";
            }
                break;
                
            case 3:{
                cell.textLabel.text=@"关于聚工厂";
                
            }
                break;
                
                
            case 4:{
                cell.textLabel.text=@"邀请码：";
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                
                [cell addSubview:inviteCodeTF];
                blueButton*OKBtn = [[blueButton alloc]initWithFrame:CGRectMake(kScreenW-70, 10, 60, 24)];
                [OKBtn setTitle:@"提交" forState:UIControlStateNormal];
                [OKBtn addTarget:self action:@selector(OKBtn) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:OKBtn];
                
            }
                break;
                
            case 5:{
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                [cell addSubview:quitButton];
            }
                break;
                
            default:
                break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.01f)];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            RevisePasswordViewController*reviseVC = [[RevisePasswordViewController alloc]init];
            UINavigationController*reviseNav = [[UINavigationController alloc]initWithRootViewController:reviseVC];
            reviseNav.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:reviseNav animated:YES completion:nil];
        }
            break;
            
        case 1:{
            // 模态弹出友盟反馈
            [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
            
            //蒲公英反馈
            //[self showFeedbackView];
            
        }
            break;
        case 2:{
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:UMENGAppKey
                                              shareText:@"推荐一款非常好用的app——聚工厂，大家快来试试。下载链接：https://itunes.apple.com/cn/app/ju-gong-chang/id1015359842?mt=8"
                                             shareImage:[UIImage imageNamed:@"icon.png"]
                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToRenren, UMShareToSina,UMShareToTencent,UMShareToEmail,UMShareToSms,nil]
                                               delegate:self];
        }
            break;
            
        case 3:{
            AboutViewController*aboutVC = [[AboutViewController alloc]init];
            UINavigationController*aboutNav = [[UINavigationController alloc]initWithRootViewController:aboutVC];
            aboutNav.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:aboutNav animated:YES completion:nil];
            
        }
            break;
            
            
            
        default:
            break;
    }
}

//友盟实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        DLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
