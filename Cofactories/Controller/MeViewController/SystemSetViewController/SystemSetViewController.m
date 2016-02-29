//
//  SystemSetViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MBProgressHUD+Add.h"
#import "UMSocial.h"
#import "UMFeedback.h"
#import "RootViewController.h"
#import "SystemSetViewController.h"
#import "RevisePasswordViewController.h"
#import "UserProtocolViewController.h"
#import "WelcomePageViewController.h"

static NSString * const CellIdentifier = @"CellIdentifiers";

@interface SystemSetViewController ()<UIAlertViewDelegate,UMSocialUIDelegate>
@end

@implementation SystemSetViewController
UIAlertView * inviteCodeAlert;
UIAlertView * quitAlert;


- (void)viewDidLoad {
    self.title=@"设置";
    [super viewDidLoad];
    [self initTableView];
    DLog(@"%f",[self cacheFilePath]);
//    kTipAlert(@"%f",[self cacheFilePath]);
}

- (void)initTableView {
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
    else if (alertView.tag == 123456) {
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
    
    else if (alertView.tag == 92){
        if (buttonIndex == 1) {
            [self clearCache];
        }
    }
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
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
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.font=kFont;
        cell.detailTextLabel.font = kFont;
        cell.detailTextLabel.textColor=[UIColor blackColor];
        
        switch (indexPath.section) {
            case 0:{
                switch (indexPath.row) {
                    case 0:{
                        cell.textLabel.text =@"欢迎页";
                        
                    }
                        break;
                        
                    case 1:{
                        cell.textLabel.text =@"去评分";
                        
                    }
                        break;
                    case 2:{
                        cell.textLabel.text =@"去分享";
                    }
                        break;
                    case 3:{
                        cell.textLabel.text =@"邀请码";
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
            /*
            case 2:{
                switch (indexPath.row) {
                    case 0:{
                        cell.textLabel.text = @"清理缓存";
                        NSString * cacheSize = [NSString stringWithFormat:@"%.2fM",[self cacheFilePath]];
                        cell.detailTextLabel.text = cacheSize ;
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
             */
                
            case 3:{
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"注销登录";
                cell.textLabel.font = [UIFont boldSystemFontOfSize:15.5f];
                cell.textLabel.textColor = [UIColor redColor];
                cell.textLabel.textAlignment = NSTextAlignmentRight;
                
            }
                break;
                
            default:
                break;
        }

    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.textLabel.text = @"清理缓存";
        NSString * cacheSize = [NSString stringWithFormat:@"%.2fM",[self cacheFilePath]];
        cell.detailTextLabel.text = cacheSize ;
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
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"确定要清除所有缓存文件吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去清理", nil];
            alertView.tag = 92;
            [alertView show];
        }
            break;
            
        case 3:{
            [quitAlert show];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Table view data source 友盟实现回调方法（可选）：
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
- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

#pragma mark - 清理缓存

-(CGFloat)cacheFilePath{
    NSString * cachePath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    return [ self folderSizeAtPath :cachePath];
}
-(CGFloat)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}
-(CGFloat)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    CGFloat folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
//        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

-(void)clearCache{
    NSString * path = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
    [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
   
}
- (void)reloadTable {
    [MBProgressHUD showSuccess:@"缓存清理成功" toView:self.view];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:2];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

@end
