//
//  HomeViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/6.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MobClick.h"
#import "HttpClient.h"
#import "UserManagerCenter.h"
#import "HomeViewController.h"
#import "AuthenticationController.h"//认证1
#import "ZGYDesignMarkrtController.h"//设计市场
#import "SetViewController.h"//完善资料
#import "SupplyMarketViewController.h"//供应市场
#import "ProcessMarketController.h"//加工配套市场
#import "Business_Cloth_VC.h"
#import "MeShopController.h"
#import "WalletModel.h"
#import "Verified_VC.h"
#import "HomeActivity_VC.h"
#import "IndexModel.h"
#import "ActivityModel.h"

static NSString *marketCellIdentifier = @"marketCell";
static NSString *personalDataCellIdentifier = @"personalDataCell";
static NSString *activityCellIdentifier = @"activityCell";
@interface HomeViewController ()

@property (nonatomic,strong)NSMutableArray *firstViewImageArray;
@property (nonatomic,strong)NSMutableArray *bannerArray;
@property (nonatomic,strong)NSMutableArray *activityArray;
@property (nonatomic,retain)UserModel * MyProfile;
@property (nonatomic,retain)WalletModel * walletModel;

@end

@implementation HomeViewController {
    CGFloat wallet;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getPersonInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    //设置代理（融云）
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    //钱包余额
    [self getWalletMoney];
    wallet = 0;
    //连接融云服务器
    [self connectToRongClound];
    //轮播图
    [self getConfig];
    //活动列表
    [self getActivityList];
    
    [self creatTableView];
    [self creatTableHeaderView];
}

- (void)creatTableView {
    self.homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 49) style:UITableViewStyleGrouped];
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
    
    UIImageView *placeHolderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW * 256 / 640)];
    placeHolderView.image = [UIImage imageNamed:@"bannerPlaceHolder"];
    self.homeTableView.tableHeaderView = placeHolderView;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return self.activityArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
         HomePersonalDataCell *cell = [tableView dequeueReusableCellWithIdentifier:personalDataCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//去掉选中背景色
        //用户头像
        [cell.personalDataLeftImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%@.png",PhotoAPI, self.MyProfile.uid]] placeholderImage:[UIImage imageNamed:@"headBtn"]];
        //用户名字
        if (self.MyProfile.name.length) {
            cell.personNameLabel.text = self.MyProfile.name;
        }
        //用户积分
        if (self.MyProfile.score.length) {
            cell.personScoreLabel.text = [NSString stringWithFormat:@"积分：%@", self.MyProfile.score];
        }
        //钱包余额
        cell.personWalletLeft.text = [NSString stringWithFormat:@"余额：%.2f元", wallet];
        //用户类型
        if ([self.MyProfile.verified isEqualToString:@"0"] || [self.MyProfile.verified isEqualToString:@"暂无"]) {
            cell.personStatusImage.image = [UIImage imageNamed:@"注"];
        } else if ([self.MyProfile.verified isEqualToString:@"1"] && [self.MyProfile.enterprise isEqualToString:@"非企业用户"]) {
            cell.personStatusImage.image = [UIImage imageNamed:@"证"];
        } else if (![self.MyProfile.enterprise isEqualToString:@"非企业用户"]) {
            cell.personStatusImage.image = [UIImage imageNamed:@"企"];
        } else {
            cell.personStatusImage.image = [UIImage imageNamed:@""];
        }
        
        //用户身份
        switch (self.MyProfile.UserType) {
            case UserType_designer:
                cell.personalDataMiddleImage.image = [UIImage imageNamed:@"Home-设计者"];
                break;
            case UserType_clothing:
                cell.personalDataMiddleImage.image = [UIImage imageNamed:@"Home-服装企业"];
                break;
            case UserType_processing:
                cell.personalDataMiddleImage.image = [UIImage imageNamed:@"Home-加工企业"];
                break;
            case UserType_supplier:
                cell.personalDataMiddleImage.image = [UIImage imageNamed:@"Home-供应商"];
                break;
            case UserType_facilitator:
                cell.personalDataMiddleImage.image = [UIImage imageNamed:@"Home-服务商"];
                break;
            default:
                cell.personalDataMiddleImage.image = [UIImage imageNamed:@""];
                break;
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
        switch (self.MyProfile.verify_status) {
            case 0:
                cell.authenticationLabel.text = @"前往认证";
                break;
            case 1:
                cell.authenticationLabel.text = @"正在审核";
                break;
            case 2:
                cell.authenticationLabel.text = @"已认证";
                break;
            default:
                break;
        }
        return cell;
    } else if (indexPath.section == 1) {
        HomeMarketCell *cell = [tableView dequeueReusableCellWithIdentifier:marketCellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    } else {
        HomeActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:activityCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ActivityModel *activityModel = self.activityArray[indexPath.row];
        if (activityModel.banner.length == 0) {
            cell.activityPhoto.image = [UIImage imageNamed:@"bannerPlaceHolder"];
        } else {
            [cell.activityPhoto sd_setImageWithURL:[NSURL URLWithString:activityModel.banner] placeholderImage:[UIImage imageNamed:@"HomeActivityHolder"]];
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100*kZGY;
    } else if (indexPath.section == 1) {
        return 160*kZGY;
    } else {
        return 0.4*kScreenW;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //活动点击事件
    if (indexPath.section == 2) {
        HomeActivity_VC *activityVC = [[HomeActivity_VC alloc] init];
        ActivityModel *activityModel = self.activityArray[indexPath.row];
        activityVC.urlString = activityModel.url;
        activityVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:activityVC animated:YES];
    }
}

#pragma mark - HomeMarketCellDelegate
- (void)homeMarketCell:(HomeMarketCell *)homeMarket marketButtonTag:(NSInteger)marketButtonTag {
    NSLog(@"第%ld个市场", (long)marketButtonTag);
    switch (marketButtonTag) {
        case 1:{
            //设计市场
            [MobClick event:@"sjsc"];

            ZGYDesignMarkrtController *designVC = [[ZGYDesignMarkrtController alloc] init];
            designVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:designVC animated:YES];
        }
            break;
        case 2:{
            //服装市场
            [MobClick event:@"fzqy"];

            Business_Cloth_VC *vc = [[Business_Cloth_VC alloc] initWithSelecteDataDictionary:[Tools returenSelectDataDictionaryWithIndex:2]];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            //供应市场
            [MobClick event:@"gysc"];

            SupplyMarketViewController *supplyMarketVC = [[SupplyMarketViewController alloc] init];
            supplyMarketVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:supplyMarketVC animated:YES];
        }
            break;
        case 4:{
            //加工配套市场
            [MobClick event:@"jgpt"];

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
    //点击了第几张轮播图
    
    IndexModel *bannerModel = self.bannerArray[tag - 1];
    if ([bannerModel.action isEqualToString:@"url"]) {
        HomeActivity_VC *activityVC = [[HomeActivity_VC alloc] init];
        activityVC.urlString = bannerModel.url;
        activityVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:activityVC animated:YES];
    } else {
        DLog(@"无链接，点不进去");
    }
}

#pragma mark - Action认证
- (void)authenticationAction:(UIButton *)button {
    DLog(@"前往认证");
    //未认证
    if (self.MyProfile.verify_status == 0) {
        AuthenticationController *authenticationVC = [[AuthenticationController alloc] initWithStyle:UITableViewStyleGrouped];
        authenticationVC.homeEnter = YES;
        authenticationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:authenticationVC animated:YES];
    }
    if (self.MyProfile.verify_status == 1) {
        Verified_VC *verifiedVC = [[Verified_VC alloc] init];
        verifiedVC.verifiedModel = self.MyProfile;
        verifiedVC.status = @"正在审核";
        verifiedVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:verifiedVC animated:YES];
    }
    if (self.MyProfile.verify_status == 2) {
        Verified_VC *verifiedVC = [[Verified_VC alloc] init];
        verifiedVC.verifiedModel = self.MyProfile;
        verifiedVC.status = @"认证成功";
        verifiedVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:verifiedVC animated:YES];
    }
}

#pragma mark - 地址没有，去完善资料
- (void)actionOfEdit:(UIButton *)button {
    if ([self.MyProfile.address isEqualToString:@"暂无"] || self.MyProfile.address.length == 0) {
        SetViewController *setVC = [[SetViewController alloc] init];
        setVC.title = @"个人资料";
        setVC.type  = self.MyProfile.UserType;
        setVC.uid = self.MyProfile.uid;
        setVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setVC animated:YES];
    } else {
        DLog(@"有地址");
    }
}

- (void)getPersonInfo {
    //个人信息
    [HttpClient getMyProfileWithBlock:^(NSDictionary *responseDictionary) {
        NSInteger statusCode = [[responseDictionary objectForKey:@"statusCode"] integerValue];
        if (statusCode == 200) {
            self.MyProfile = [responseDictionary objectForKey:@"model"];
            self.walletModel = [[StoreUserValue sharedInstance] valueWithKey:@"walletModel"];
            wallet = self.walletModel.maxWithDraw;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [self.homeTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        } else {
            self.MyProfile = [[UserModel alloc]getMyProfile];
        }
    }];
}

- (void)getWalletMoney {
    //钱包余额
    [HttpClient getwalletWithBlock:^(NSDictionary *responseDictionary) {
        NSInteger statusCode = [[responseDictionary objectForKey:@"statusCode"]integerValue];
        if (statusCode == 200) {
            self.walletModel = [responseDictionary objectForKey:@"model"];
            wallet = self.walletModel.maxWithDraw;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [self.homeTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)getActivityList {
    //活动列表
    [HttpClient getActivityWithBlock:^(NSDictionary *responseDictionary) {
        int statusCode = [responseDictionary[@"statusCode"] intValue];
        DLog(@"statusCode = %d", statusCode);
        if (statusCode == 200) {
            NSArray *jsonArray = responseDictionary[@"responseArray"];
            self.activityArray = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dictionary in jsonArray) {
                ActivityModel *activityModel = [ActivityModel getActivityModelWithDictionary:dictionary];
                [self.activityArray addObject:activityModel];
            }
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
            [self.homeTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        } else if (statusCode == 0) {
            DLog(@"请求超时");
        }
    }];
}
- (void)getConfig {
    //轮播图
    [HttpClient getConfigWithType:@"index" WithBlock:^(NSDictionary *responseDictionary) {
        int statusCode = [responseDictionary[@"statusCode"] intValue];
        DLog(@"statusCode = %d", statusCode);
        if (statusCode == 200) {
            NSArray *jsonArray = (NSArray *)responseDictionary[@"responseArray"];
            self.firstViewImageArray = [NSMutableArray arrayWithCapacity:0];
            self.bannerArray = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dictionary in jsonArray) {
                IndexModel *bannerModel = [IndexModel getIndexModelWithDictionary:dictionary];
                [self.bannerArray addObject:bannerModel];
                [self.firstViewImageArray addObject:bannerModel.img];
            }
            //第一个scrollView
            WKFCircularSlidingView * firstView = [[WKFCircularSlidingView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW * 256 / 640)isNetwork:YES];
            firstView.delegate=self;
            firstView.imagesArray = self.firstViewImageArray;
            self.homeTableView.tableHeaderView = firstView;
        } else if (statusCode == 0) {
            DLog(@"请求超时");
        }
    }];
}

- (void)connectToRongClound {
    //获取融云的token
    [HttpClient getIMTokenWithBlock:^(NSDictionary *responseDictionary) {
        NSInteger statusCode = [responseDictionary[@"statusCode"]integerValue];
        DLog(@"融云====%ld", (long)statusCode);
        if (statusCode == 200) {
            NSString *token = responseDictionary[@"IMToken"];
            // 快速集成第二步，连接融云服务器
            [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
                [self updateBadgeValueForTabBarItem];
                    DLog(@" Connect 成功");
                } error:^(RCConnectErrorCode status) {
                    DLog(@" Connect 失败")
                } tokenIncorrect:^() {
                    // Token 失效的状态处理
                    DLog(@" Connect Token失效")
            }];
        }
    }];
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

#pragma mark - RCIMUserInfoDataSource
//获取IM用户信息
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
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


/*
#pragma mark - checkForUpdate
- (void)checkForUpdate {
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 7.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=1015359842"] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *jsonData = responseObject;
        NSArray *infoArray = [jsonData objectForKey:@"results"];
        NSDictionary *releaseInfo = [infoArray firstObject];
        NSString *latestVersion = [releaseInfo objectForKey:@"version"];
        NSString *releaseNotes = [releaseInfo objectForKey:@"releaseNotes"];
        DLog(@"appStore最新版本号：%@\n线下版本号：%@",latestVersion,kVersion_Cofactories);
        
        if (![latestVersion isEqualToString:kVersion_Cofactories] && [latestVersion compare:kVersion_Cofactories] != NSOrderedAscending) {
            //版本号不一致 说明有新版本在审核或上线 则 进一步判断 //判断版本号 如果AppStore线上版本号大于现app版本号 说明有更新 就去更新
            DLog(@"去更新");
            UIAlertView * upDataAlertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"发现新版本V%@",latestVersion] message:releaseNotes delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去更新", nil];
            upDataAlertView.tag = 200;
            [upDataAlertView show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    DLog(@"alert");
    if (alertView.tag == 200) {
        if (buttonIndex == 1) {
            NSString *str = kAppUrl;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
}
 */

@end
