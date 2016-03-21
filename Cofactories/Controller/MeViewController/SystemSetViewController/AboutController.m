//
//  AboutController.m
//  Cofactories
//
//  Created by 宋国华 on 16/3/18.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "AboutController.h"
#import "UMSocial.h"
#import "UMFeedback.h"
#import "WelcomePageViewController.h"
#import "UserProtocolViewController.h"

static NSString * const CellIdentifier = @"AboutCellIdentifiers";

@interface AboutController ()<UMSocialUIDelegate>


@end

@implementation AboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void)initViews {
    
    self.title=@"关于聚工厂";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:kScreenFrame style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.rowHeight = 45;
//    self.tableView.contentSize = CGSizeMake(kScreenW, kScreenH);
    
    UIView*tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
    tableHeaderView.backgroundColor=[UIColor whiteColor];
    
    UIImageView*logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2-40, 10, 80, 80)];
    logoImage.image=[UIImage imageNamed:@"login_logo"];
    logoImage.layer.cornerRadius = 15;
    logoImage.layer.masksToBounds = YES;
    [tableHeaderView addSubview:logoImage];
    
    UILabel*logoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, kScreenW, 20)];
    logoLabel.font = kLargeFont;
    logoLabel.numberOfLines = 1;
    logoLabel.text = @"聚工厂";
    logoLabel.textColor = kMainLightBlueColor;
    logoLabel.textAlignment = NSTextAlignmentCenter;
    [tableHeaderView addSubview:logoLabel];
    
    UILabel * logoLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, kScreenW, 20)];
    logoLabel1.font = kFont;
    logoLabel1.numberOfLines = 1;
    logoLabel1.text = [NSString stringWithFormat:@"版本 %@ (%@)",kVersion_Cofactories,kVersionBuild_Cofactories];
    logoLabel1.textAlignment = NSTextAlignmentCenter;
    logoLabel1.textColor = [UIColor grayColor];
    [tableHeaderView addSubview:logoLabel1];
    
    self.tableView.tableHeaderView = tableHeaderView;
    
    
    UIView * tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 420)];
    UIButton * protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    protocolBtn.frame = CGRectMake((kScreenW - 140)/2, kScreenH - 330 - 160, 140, 20);
       protocolBtn.titleLabel.font = kSmallFont;
    protocolBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [protocolBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [protocolBtn setTitle:@"聚工厂服务协议" forState:UIControlStateNormal];
    [protocolBtn addTarget:self action:@selector(clickProtocolBtn) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:protocolBtn];
    
    UILabel * copyrightLable = [[UILabel alloc]initWithFrame:CGRectMake(30, kScreenH - 330 - 140, kScreenW - 60, 40)];
    copyrightLable.text = @"Copyright © 2015-2016年 Cofactories. All rights reserved";
    copyrightLable.numberOfLines = 0;
    copyrightLable.textAlignment = NSTextAlignmentCenter;
    copyrightLable.textColor = [UIColor grayColor];
    copyrightLable.font = [UIFont systemFontOfSize:14];
    [tableFooterView addSubview:copyrightLable];
    
    self.tableView.tableFooterView = tableFooterView;
    
    DLog(@"%@ -- %@ -- %@",self.tableView,tableHeaderView,tableFooterView);
}

- (void)clickProtocolBtn {
    UserProtocolViewController * protocolVC = [[UserProtocolViewController alloc]init];
    UINavigationController * protocolNav = [[UINavigationController alloc]initWithRootViewController:protocolVC];
    [self presentViewController:protocolNav animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
                        cell.textLabel.text =@"意见反馈";
                    }
                        break;
                        
                    default:
                        break;
                }
                
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
                    [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
                }
                    break;
                    
                default:
                    break;
            }
            
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

@end
