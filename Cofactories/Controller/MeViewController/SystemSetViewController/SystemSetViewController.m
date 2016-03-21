//
//  SystemSetViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MBProgressHUD+Add.h"
#import "RootViewController.h"
#import "SystemSetViewController.h"
#import "RevisePasswordViewController.h"
#import "AboutController.h"

static NSString * const CellIdentifier = @"SetCellIdentifiers";

@interface SystemSetViewController ()<UIAlertViewDelegate>
@end

@implementation SystemSetViewController
UIAlertView * _inviteCodeAlert;
UIAlertView * _quitAlert;
LoginButton * _exitBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
}

- (void)initTableView {
    self.title=@"设置";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.rowHeight = 45;

    _inviteCodeAlert = [[UIAlertView alloc]initWithTitle:@"邀请码"
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                      otherButtonTitles:@"发送",nil];
    [_inviteCodeAlert setTag:123456];
    [_inviteCodeAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    UITextField * alertTextField = [_inviteCodeAlert textFieldAtIndex:0];
    alertTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    alertTextField.placeholder = @"邀请码";
    alertTextField.text = self.inviteCode;
    if (![self.inviteCode isEqualToString:@"尚未填写"]) {
        alertTextField.text = self.inviteCode;
    }
    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    _quitAlert = [[UIAlertView alloc]initWithTitle:@"确定退出" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    _quitAlert.tag = 404;
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
                        kTipAlert(@"邀请码提交成功 ");
                    }
                    else if (statusCode == 400) {
                        kTipAlert(@"不存在该邀请码 (400)");
                    }
                    else if (statusCode == 409) {
                        kTipAlert(@"该用户已存在邀请码 (409)");
                    }
                    else {
                        kTipAlert(@"邀请码提交失败，尝试重新提交 (%ld)",(long)statusCode);
                    }
                }];
            }else{
                kTipAlert(@"请您填写邀请码后再提交");
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
        return 1;
    }
    else if (section == 1) {
        return 2;
    }
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
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
                        cell.textLabel.text= @"修改密码";
                    }
                        break;
                        
                    case 1:{
                        cell.textLabel.text = @"关于聚工厂";
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
                break;

            case 3:{
                cell.accessoryType = UITableViewCellAccessoryNone;
                UILabel * exitLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 45)];
                exitLable.text = @"退出登录";
                exitLable.font = [UIFont boldSystemFontOfSize:16.f];
                exitLable.textColor = [UIColor redColor];
                exitLable.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:exitLable];
                
            }
                break;
                
            default:
                break;
        }

    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.textLabel.text = @"清理缓存";
        
        if (!isnan([self cacheFilePath]) && [self cacheFilePath] < 1000) {
            NSString * cacheSize = [NSString stringWithFormat:@"%.2fM",[self cacheFilePath]];
            cell.detailTextLabel.text = cacheSize;
        }
//        if (isnan([self cacheFilePath])) {
//            
//        }else {
//            if ([self cacheFilePath] < 1000) {
//                NSString * cacheSize = [NSString stringWithFormat:@"%.2fM",[self cacheFilePath]];
//                cell.detailTextLabel.text = cacheSize;
//            }
//        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    [_inviteCodeAlert show];
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
                    AboutController * aboutVC = [[AboutController alloc]init];
                    [self.navigationController pushViewController:aboutVC animated:YES];
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
            [_quitAlert show];
        }
            break;
            

            
        default:
            break;
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

-(double)cacheFilePath{
    NSString * cachePath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    return [ self folderSizeAtPath :cachePath];
}
-(double)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}
-(double)folderSizeAtPath:(NSString *)path{
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
    [Tools removeAllCached];
    [self performSelectorOnMainThread:@selector(reloadTable) withObject:nil waitUntilDone:YES];
   
}
- (void)reloadTable {
    [MBProgressHUD showSuccess:@"缓存清理成功" toView:self.view];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:2];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

@end
