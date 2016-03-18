//
//  MeViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/6.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "UserManagerCenter.h"
#import "HttpClient.h"
#import "MeViewController.h"
#import "SetViewController.h"
#import "SystemSetViewController/SystemSetViewController.h"
#import "MeShopController.h"//店铺
#import "PublishPopularNews_VC.h"
#import "PublicServiceViewController.h"
#import "MeShoppingCar_VC.h"//购物车
#import "MallBuyHistory_VC.h"//购买记录
#import "MallSellHistory_VC.h"//出售记录

static NSString * const CellIdentifier = @"CellIdentifier";

@interface MeViewController ()

@property (nonatomic,retain)UserModel * MyProfile;

@end

@implementation MeViewController {
    UIImageView * _tableHeadView;
    UIImageView * _headView;

    UIButton * _leftBtn;
    UIButton * _rightBtn;
    
    UILabel * myProfileLabel;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.MyProfile = [[UserModel alloc]getMyProfile];
    myProfileLabel.text = [NSString stringWithFormat:@"%@\n%@",self.MyProfile.name,[UserModel getRoleWith:self.MyProfile.UserType]];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self initView];
}

- (void)initView {
    
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    myProfileLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenW*0.47-50, kScreenW, 50)];
    myProfileLabel.font = kFont;
    myProfileLabel.numberOfLines = 2;
    myProfileLabel.textAlignment = NSTextAlignmentCenter;
    myProfileLabel.textColor = [UIColor whiteColor];
 
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.tag = 1;
    _leftBtn.frame = CGRectMake(0, 0, kScreenW/2, 49);
    [_leftBtn setImage:[UIImage imageNamed:@"Me_leftBtn"] forState:UIControlStateNormal];
    _leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_leftBtn addTarget:self action:@selector(clickHeaderBtnInSection:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.tag = 2;
    _rightBtn.frame = CGRectMake(kScreenW/2+1, 0, kScreenW/2, 49);
    [_rightBtn setImage:[UIImage imageNamed:@"Me_ShoppingCar"] forState:UIControlStateNormal];
    _rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_rightBtn addTarget:self action:@selector(clickHeaderBtnInSection:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*setButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"settingBtn_Nav"] style:UIBarButtonItemStylePlain target:self action:@selector(setButtonClicked)];
    self.navigationItem.rightBarButtonItem = setButton;
    
    _tableHeadView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW*0.47)];
    _tableHeadView.image = [UIImage imageNamed:@"Me_tableHeadView"];
    [_tableHeadView addSubview:myProfileLabel];
    
    self.tableView.tableHeaderView = _tableHeadView;
}

- (void)setButtonClicked {
    SystemSetViewController * systemSetVC = [[SystemSetViewController alloc]init];
    systemSetVC.title = @"系统";
    systemSetVC.inviteCode = self.MyProfile.inviteCode;
    systemSetVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:systemSetVC animated:YES];
}

- (void)clickHeaderBtnInSection:(UIButton *)Btn {
    if (Btn.tag == 1) {
        DLog(@"个人资料");
        SetViewController * SetVC = [[SetViewController alloc]init];
        SetVC.title = @"个人资料";
        SetVC.type  = self.MyProfile.UserType;
        SetVC.uid = self.MyProfile.uid;
        SetVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:SetVC animated:YES];
    }
    if (Btn.tag == 2) {
        DLog("购物车");
        MeShoppingCar_VC *shoppingCarVC = [[MeShoppingCar_VC alloc] init];
        shoppingCarVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:shoppingCarVC animated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (self.MyProfile.UserType) {
            DLog(@"^^^^^^^^^^%ld", (long)self.MyProfile.UserType);
        case UserType_designer:
            //设计者
            return 3;
            break;
            
        case UserType_supplier:
            //供应商
            return 2;
            break;
            
        default:
            return 1;
            break;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    else if (section == 2) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

        cell.textLabel.font = kFont;
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                    {
                        cell.textLabel.text = @"企业账号";
                    }
                        break;
                        
                    case 1:
                    {
                        cell.textLabel.text = @"联系客服";
                    }
                        break;
                        
                    case 2:
                    {
                        cell.textLabel.text = @"购买记录";
                    }
                        break;
                }
                break;
             
            case 1:
                switch (indexPath.row) {
                    case 0:
                    {
                        cell.textLabel.text = @"我的店铺";
                    }
                        break;
                    case 1:
                    {
                        cell.textLabel.text = @"出售记录";
                    }
                        break;
                }
                break;
                
            case 2:
                cell.textLabel.text = @"流行资讯发布";
                break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 55;
    }
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView * viewForHeaderInSection = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
        [viewForHeaderInSection addSubview:_leftBtn];
        [viewForHeaderInSection addSubview:_rightBtn];
        return viewForHeaderInSection;
    }
    else {
        return nil;
    }
   
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView * viewForHeaderInSection = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
//    [viewForHeaderInSection addSubview:_leftBtn];
//    [viewForHeaderInSection addSubview:_rightBtn];
//    return viewForHeaderInSection;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                    
                case 0:
                {
                    DLog("企业账号");
                    BaseWebController * enterpriseView = [[BaseWebController alloc] init];
                    enterpriseView.requestUrl = kEnterpriseUrl;
                    enterpriseView.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:enterpriseView animated:YES];
                }
                    break;

                case 1:
                {
                    DLog("客服聊天");
                    PublicServiceViewController *conversationVC = [[PublicServiceViewController alloc] init];
                    conversationVC.conversationType = ConversationType_APPSERVICE;
                    conversationVC.targetId = RONGCLOUD_IM_SERVICEID;
                    conversationVC.title = @"聚工厂客服";
                    conversationVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:conversationVC animated:YES];
                }
                    break;
                    
                case 2:
                {
                    DLog(@"购买记录");
                    MallBuyHistory_VC *mallBuyVC = [[MallBuyHistory_VC alloc] init];
                    ApplicationDelegate.mallStatus = @"0";
                    mallBuyVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:mallBuyVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 1: {
            switch (indexPath.row) {
                case 0:
                {
                    DLog(@"我的店铺");
                    if (self.MyProfile.UserType == UserType_designer) {
                        //设计者
                        MeShopController *meShopVC = [[MeShopController alloc] init];
                        meShopVC.myUserType = UserType_designer;
                        meShopVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:meShopVC animated:YES];
                        
                    } else if (self.MyProfile.UserType == UserType_supplier) {
                        //供应商
                        MeShopController *meShopVC = [[MeShopController alloc] init];
                        meShopVC.myUserType = UserType_supplier;
                        meShopVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:meShopVC animated:YES];
                    }
                }
                    break;
                case 1:
                {
                    DLog(@"出售记录");
                    MallSellHistory_VC *mallSellVC = [[MallSellHistory_VC alloc] init];
                    ApplicationDelegate.mallStatus = @"0";
                    mallSellVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:mallSellVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            
            break;
            
        case 2: {
            DLog(@"流行资讯发布");
            PublishPopularNews_VC *publishVC = [[PublishPopularNews_VC alloc] init];
            publishVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:publishVC animated:YES];
        }
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
