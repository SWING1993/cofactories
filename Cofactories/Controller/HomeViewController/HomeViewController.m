//
//  HomeViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/6.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "HttpClient.h"
#import "UserManagerCenter.h"
#import "HomeViewController.h"
#import "AuthenticationPhotoController.h"//认证2
#import "AuthenticationController.h"//认证1
#import "ZGYDesignMarkrtController.h"//设计市场
#import "SetViewController.h"//完善资料
#import "SupplyMarketViewController.h"//供应市场
#import "ProcessMarketController.h"//加工配套市场
#import "Business_Cloth_VC.h"
#import "DataBaseHandle.h"
#import "MeShopController.h"
#import "WalletModel.h"
#import "HomeActivityList_VC.h"

static NSString *marketCellIdentifier = @"marketCell";
static NSString *personalDataCellIdentifier = @"personalDataCell";
static NSString *activityCellIdentifier = @"activityCell";
@interface HomeViewController () {
    NSArray *arr;
}
@property (nonatomic,strong)NSMutableArray *firstViewImageArray;
@property (nonatomic,retain)UserModel * MyProfile;
@property (nonatomic,retain)WalletModel * walletModel;


@end

@implementation HomeViewController


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //设置代理（融云）
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    [HttpClient getwalletWithBlock:^(NSDictionary *responseDictionary) {
        NSInteger statusCode = [[responseDictionary objectForKey:@"statusCode"]integerValue];
        if (statusCode == 200) {
            self.walletModel = [responseDictionary objectForKey:@"model"];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [self.homeTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    [HttpClient getMyProfileWithBlock:^(NSDictionary *responseDictionary) {
        
        NSInteger statusCode = [[responseDictionary objectForKey:@"statusCode"] integerValue];
        if (statusCode == 200) {
            self.MyProfile = [responseDictionary objectForKey:@"model"];
            DLog(@"^^^^^%@", self.MyProfile);
        } else {
            self.MyProfile = [[UserModel alloc]getMyProfile];
        }
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [self.homeTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }];

}
#pragma mark - RCIMUserInfoDataSource

//获取IM用户信息
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    DLog(@"**************************");
    //解析工厂信息
    [HttpClient getOtherIndevidualsInformationWithUserID:userId WithCompletionBlock:^(NSDictionary *dictionary) {
        OthersUserModel *otherModel = (OthersUserModel *)dictionary[@"message"];
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = userId;
        user.name = otherModel.name;
        user.portraitUri = [NSString stringWithFormat:@"%@/factory/%@.png",PhotoAPI, userId];
        return completion(user);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //获取融云的token
    [HttpClient getIMTokenWithBlock:^(NSDictionary *responseDictionary) {
        NSInteger statusCode = [responseDictionary[@"statusCode"]integerValue];
        DLog(@"融云====%ld", (long)statusCode);
        if (statusCode == 200) {
            NSString *token = responseDictionary[@"IMToken"];
//            DLog(@"融云token====%@", token);
            
            // 快速集成第二步，连接融云服务器
            [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
                [self updateBadgeValueForTabBarItem];
                // Connect 成功
                DLog(@" Connect 成功");
            }
                                          error:^(RCConnectErrorCode status) {
                                              // Connect 失败
                                              DLog(@" Connect 失败")
                                          }
                                 tokenIncorrect:^() {
                                     // Token 失效的状态处理
                                      DLog(@" Connect Token失效")
                                 }];
        }
    }];

    arr = @[@"PopularNews-男装", @"PopularNews-女装", @"PopularNews-童装", @"PopularNews-面辅料"];
    [self creatTableView];
    [self creatTableHeaderView];
    [self creatShoppingCarTable];
}

- (void)creatTableView {
    self.homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 44) style:UITableViewStyleGrouped];
    self.automaticallyAdjustsScrollViewInsets = YES;// 自动调整视图关闭
    self.homeTableView.showsVerticalScrollIndicator = NO;// 竖直滚动条不显示
    self.homeTableView.delegate = self;
    self.homeTableView.dataSource = self;
    [self.view addSubview:self.homeTableView];
    
    [self.homeTableView registerClass:[HomeMarketCell class] forCellReuseIdentifier:marketCellIdentifier];
    [self.homeTableView registerClass:[HomePersonalDataCell class] forCellReuseIdentifier:personalDataCellIdentifier];
    [self.homeTableView registerClass:[HomeActivityCell class] forCellReuseIdentifier:activityCellIdentifier];
}

- (void)creatTableHeaderView {
    //第一个scrollView
    WKFCircularSlidingView * firstView = [[WKFCircularSlidingView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW * 256 / 640)isNetwork:NO];
    firstView.delegate=self;
    self.firstViewImageArray = [NSMutableArray arrayWithArray:arr];
    firstView.imagesArray = self.firstViewImageArray;
    self.homeTableView.tableHeaderView = firstView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
         HomePersonalDataCell *cell = [tableView dequeueReusableCellWithIdentifier:personalDataCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//去掉选中背景色
        [cell.personalDataLeftImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%@.png",PhotoAPI, self.MyProfile.uid]] placeholderImage:[UIImage imageNamed:@"headBtn"]];
        cell.personNameLabel.text = self.MyProfile.name;
        //用户类型
        if ([self.MyProfile.verified isEqualToString:@"0"] || [self.MyProfile.verified isEqualToString:@"暂无"]) {
            cell.personStatusImage.image = [UIImage imageNamed:@"注"];
        } else if ([self.MyProfile.verified isEqualToString:@"1"]) {
            cell.personStatusImage.image = [UIImage imageNamed:@"证"];
        }

        cell.personScoreLabel.text = [NSString stringWithFormat:@"积分：%@", self.MyProfile.score];
        //钱包余额
        cell.personWalletLeft.text = [NSString stringWithFormat:@"余额：%.2f元",self.walletModel.money];
        
        //用户身份
        if (self.MyProfile.UserType == UserType_designer) {
            cell.personalDataMiddleImage.image = [UIImage imageNamed:@"Home-设计者"];
        } else if (self.MyProfile.UserType == UserType_clothing) {
            cell.personalDataMiddleImage.image = [UIImage imageNamed:@"Home-服装企业"];
        } else if (self.MyProfile.UserType == UserType_processing) {
            cell.personalDataMiddleImage.image = [UIImage imageNamed:@"Home-加工企业"];
        } else if (self.MyProfile.UserType == UserType_supplier) {
            cell.personalDataMiddleImage.image = [UIImage imageNamed:@"Home-供应商"];
        } else if (self.MyProfile.UserType == UserType_facilitator) {
            cell.personalDataMiddleImage.image = [UIImage imageNamed:@"Home-服务商"];
        }
        //地址
        if ([self.MyProfile.address isEqualToString:@"暂无"] || self.MyProfile.address.length == 0) {
            [cell.personAddressButton setTitle:@"地址暂无，点击完善资料" forState: UIControlStateNormal];
            [cell.personAddressButton addTarget:self action:@selector(actionOfEdit:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [cell.personAddressButton setTitle:self.MyProfile.address forState: UIControlStateNormal];
        }
        
        [cell.authenticationButton addTarget:self action:@selector(authenticationAction:) forControlEvents:UIControlEventTouchUpInside];
        //认证状态
        if (self.MyProfile.verify_status == 0) {
            cell.authenticationLabel.text = @"前往认证";
        }
        if (self.MyProfile.verify_status == 1) {
            cell.authenticationLabel.text = @"认证中";
        }
        if (self.MyProfile.verify_status == 2) {
            cell.authenticationLabel.text = @"已认证";
        }
        return cell;
    } else if (indexPath.section == 1) {
        HomeMarketCell *cell = [tableView dequeueReusableCellWithIdentifier:marketCellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    } else {
        HomeActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:activityCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.activityPhoto.image = [UIImage imageNamed:arr[indexPath.row]];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 105*kZGY;
    } else if (indexPath.section == 1) {
        return 160*kZGY;
    }
    return 0.4*kScreenW;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        DLog(@"第%ld个活动", indexPath.row + 1);
        HomeActivityList_VC *activityListVC = [[HomeActivityList_VC alloc] init];
        activityListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:activityListVC animated:YES];
    }
}


//-(void)tableView:(UITableView *)tableView willDisplayCell:(HomePersonalDataCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0) {
//        [Tools rotate360DegreeWithImageView:cell.personalDataLeftImage];
//        [Tools rotate360DegreeWithImageView:cell.personalDataMiddleImage];
//        [Tools rotate360DegreeWithImageView:cell.personalDataRightImage];
//    }
//    if (indexPath.section == 2) {
//        //xy方向缩放的初始值为0.95
//        cell.layer.transform = CATransform3DMakeScale(0.95, 0.95, 1);
//        //设置动画时间为0.25秒,xy方向缩放的最终值为1
//        [UIView animateWithDuration:0.5 animations:^{
//            cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//        }];
//    }
//}

#pragma mark - HomeMarketCellDelegate
- (void)homeMarketCell:(HomeMarketCell *)homeMarket marketButtonTag:(NSInteger)marketButtonTag {
    NSLog(@"第%ld个市场", (long)marketButtonTag);
    switch (marketButtonTag) {
        case 1:{
            //设计市场
            ZGYDesignMarkrtController *designVC = [[ZGYDesignMarkrtController alloc] init];
            designVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:designVC animated:YES];
        }
            break;
        case 2:{
            //服装市场
            Business_Cloth_VC *vc = [[Business_Cloth_VC alloc] initWithSelecteDataDictionary:[Tools returenSelectDataDictionaryWithIndex:2]];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            //供应市场
            SupplyMarketViewController *supplyMarketVC = [[SupplyMarketViewController alloc] init];
            supplyMarketVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:supplyMarketVC animated:YES];
        }
            break;
        case 4:{
            //加工配套市场
            ProcessMarketController *processMarketVC = [[ProcessMarketController alloc] init];
            processMarketVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:processMarketVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark -WKFCircularSlidingViewDelegate
-(void)clickCircularSlidingView:(int)tag{
    DLog(@"点击了第  %d  张图", tag);
}
#pragma mark - Action认证
- (void)authenticationAction:(UIButton *)button {
    DLog(@"前往认证");
    //未认证
    if (self.MyProfile.verify_status == 0) {
        AuthenticationController *authenticationVC = [[AuthenticationController alloc] initWithStyle:UITableViewStyleGrouped];
        authenticationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:authenticationVC animated:YES];
    }
}

#pragma mark - 地址没有，去完善资料
- (void)actionOfEdit:(UIButton *)button {
    if ([self.MyProfile.address isEqualToString:@"暂无"] || self.MyProfile.address.length == 0) {
        SetViewController *setVC = [[SetViewController alloc] init];
        setVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setVC animated:YES];
    } else {
        DLog(@"有地址");
    }
    
}

#pragma mark - Action
- (void)updateBadgeValueForTabBarItem {
    __weak typeof(self) IMSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
        if (count>0) {
            IMSelf.tabBarController.viewControllers[2].tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",count];
        } else {
            IMSelf.tabBarController.viewControllers[2].tabBarItem.badgeValue = nil;
        }
        
    });
}
#pragma mark - RCIMReceiveMessageDelegate
//必须要写在这里，不能写在通话列表里
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    DLog(@"=============================");
    __weak typeof(self) IMSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        int messageCount = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
        if (messageCount>0) {
            IMSelf.tabBarController.viewControllers[2].tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",messageCount];
        } else {
            IMSelf.tabBarController.viewControllers[2].tabBarItem.badgeValue = nil;
        }
    });
    
}

- (void)creatShoppingCarTable {
    //创建购物车的表
    DataBaseHandle *dataBaseHandle = [DataBaseHandle mainDataBaseHandle];
    [dataBaseHandle createShoppingCarTable];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
