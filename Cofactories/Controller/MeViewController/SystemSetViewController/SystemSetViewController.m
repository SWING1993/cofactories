//
//  SystemSetViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "UMSocial.h"
#import "UMFeedback.h"
#import "RootViewController.h"
#import "SystemSetViewController.h"
#import "RevisePasswordViewController.h"
#import "UserProtocolViewController.h"
#import "WelcomePageViewController.h"

static NSString * const CellIdentifier = @"CellIdentifier";


@interface SystemSetViewController ()<UIAlertViewDelegate,UMSocialUIDelegate>

@end

@implementation SystemSetViewController {
    UIAlertView * inviteCodeAlert;
    UIAlertView * quitAlert;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"设置";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    
    UIView*tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 130)];
    tableHeaderView.backgroundColor=[UIColor whiteColor];
    
    UIImageView*logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2-40, 10, 80, 80)];
    logoImage.image=[UIImage imageNamed:@"login_logo"];
    logoImage.layer.cornerRadius = 15;
    logoImage.layer.masksToBounds = YES;
    [tableHeaderView addSubview:logoImage];
    
    UILabel*logoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, kScreenW, 20)];
    logoLabel.font = kLargeFont;
    logoLabel.text=[NSString stringWithFormat:@"聚工厂 cofactories %@",kVersion_Cofactories];
    logoLabel.textAlignment = NSTextAlignmentCenter;
    [tableHeaderView addSubview:logoLabel];
    
    self.tableView.tableHeaderView=tableHeaderView;

    
    inviteCodeAlert = [[UIAlertView alloc]initWithTitle:@"邀请码"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"发送",nil];
    [inviteCodeAlert setTag:123456];
    [inviteCodeAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    UITextField * alertTextField = [inviteCodeAlert textFieldAtIndex:0];
    alertTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    alertTextField.placeholder = @"邀请码";
    alertTextField.text = self.inviteCode;
    if (![self.inviteCode isEqualToString:@"尚未填写"]) {
        alertTextField.text = self.inviteCode;
    }
    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    quitAlert = [[UIAlertView alloc]initWithTitle:@"确定退出" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    quitAlert.tag = 404;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 404) {
        if (buttonIndex==1) {
            [HttpClient deleteToken];
            [RootViewController setupLoginViewController];
        }
    }
    if (alertView.tag == 123456) {
        UITextField * alertTextField = [alertView textFieldAtIndex:0];
        if (buttonIndex == 1) {
            if (alertTextField.text.length > 0) {
                [HttpClient registerWithInviteCode:alertTextField.text andBlock:^(NSInteger statusCode) {
                    if (statusCode == 200) {
                        kTipAlert(@"邀请码提交成功!");
                    }
                    else if (statusCode == 400) {
                        kTipAlert(@"不存在该邀请码。(错误码：400)");
                    }
                    else if (statusCode == 409) {
                        kTipAlert(@"该用户已存在邀请码。(错误码：409)");
                    }
                    else {
                        kTipAlert(@"邀请码提交失败，尝试重新提交。(错误码：%ld)",(long)statusCode);
                    }
                }];
            }else{
                kTipAlert(@"请您填写邀请码后再提交!");
            }
        }
    }
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    else if (section == 1) {
        return 3;
    }
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0001f;
    }
    return 7.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
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
                switch (indexPath.row) {
                    case 0:{
                        cell.textLabel.text=@"欢迎页";
                        
                    }
                        break;
                        
                    case 1:{
                        cell.textLabel.text=@"去评分";

                    }
                        break;
                    case 2:{
                        cell.textLabel.text = @"去分享";
                    }
                        break;
                    case 3:{
                        cell.textLabel.text=@"邀请码";
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
                break;
                
                
            case 1:{
                switch (indexPath.row) {
                    case 0:{
                        cell.textLabel.text=@"修改密码";
                    }
                        break;
                    case 1:{
                        cell.textLabel.text=@"意见反馈";
                    }
                        break;
                    case 2:{
                        cell.textLabel.text = @"服务协议";
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
                
                break;
            case 2:{
                cell.textLabel.text = @"注销登录";
            }
                break;

            default:
                break;
        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    WelcomePageViewController * vc = [[WelcomePageViewController alloc]init];
                    vc.modalPresentationStyle = UIModalPresentationCustom;                    
                    [self presentViewController:vc animated:NO completion:nil];
                }
                    break;

                case 1:{
                    NSString *str = kAppReviewURL;
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                }
                    break;
                case 2:{
                    [UMSocialSnsService presentSnsIconSheetView:self
                                                         appKey:Appkey_Umeng
                                                      shareText:@"推荐一款非常好用的app——聚工厂，大家快来试试。下载链接：https://itunes.apple.com/cn/app/ju-gong-chang/id1015359842?mt=8"
                                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToRenren, UMShareToSina,UMShareToTencent,UMShareToEmail,UMShareToSms,nil]
                                                       delegate:self];
                }
                    break;
                case 3:{
                    [inviteCodeAlert show];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
            
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    RevisePasswordViewController*reviseVC = [[RevisePasswordViewController alloc]init];
                    UINavigationController*reviseNav = [[UINavigationController alloc]initWithRootViewController:reviseVC];
                    reviseNav.modalPresentationStyle = UIModalPresentationCustom;
                    [self presentViewController:reviseNav animated:YES completion:nil];
                }
                    break;
                case 1:{
                    [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
                }
                    break;
                case 2:{
                    UserProtocolViewController * protocolVC = [[UserProtocolViewController alloc]init];
                    UINavigationController * protocolNav = [[UINavigationController alloc]initWithRootViewController:protocolVC];
                    [self presentViewController:protocolNav animated:YES completion:^{
                        
                    }];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            
            break;
        case 2:{

            [quitAlert show];
        }
            break;
            
        default:
            break;
    }

            /*
        case 4:{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"填写邀请码" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
                textField.placeholder = self.inviteCode;
                textField.keyboardType = UIKeyboardTypeNumberPad;
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                if (![self.inviteCode isEqualToString:@"尚未填写"]) {
                    textField.text = self.inviteCode;
                }
            }];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"提交" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                if (alertController.textFields.firstObject.text.length>0) {
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
                    
                    [HttpClient registerWithInviteCode:alertController.textFields.firstObject.text andBlock:^(NSInteger statusCode) {
                        if (statusCode == 200) {
                            kTipAlert(@"邀请码提交成功!");
                        }
                        else if (statusCode == 400) {
                            kTipAlert(@"不存在该邀请码。(错误码：400)");
                        }
                        else if (statusCode == 409) {
                            kTipAlert(@"该用户已存在邀请码。(错误码：409)");
                        }
                        else {
                            kTipAlert(@"邀请码提交失败，尝试重新提交。(错误码：%ld)",(long)statusCode);
                        }
                    }];
                }
                
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [alertController.textFields.firstObject resignFirstResponder];
                }];
            }];
            
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];

            [self presentViewController:alertController animated:YES completion:^{
                
            }];
        }
            break;
             */

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
