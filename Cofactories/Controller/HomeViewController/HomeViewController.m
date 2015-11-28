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
#import "VerifyModel.h"

static NSString *marketCellIdentifier = @"marketCell";
static NSString *personalDataCellIdentifier = @"personalDataCell";
static NSString *activityCellIdentifier = @"activityCell";
@interface HomeViewController () {
    NSArray *arr;
    CATransform3D leftTransform, middleTransform, rightTransform;
    VerifyModel *verifyModel;
}
@property (nonatomic,strong)NSMutableArray *firstViewImageArray;
@property (nonatomic,retain)UserModel * MyProfile;

@end

@implementation HomeViewController

- (void)viewDidAppear:(BOOL)animated {

    [HttpClient getMyProfileWithBlock:^(NSDictionary *responseDictionary) {
        
        NSInteger statusCode = [[responseDictionary objectForKey:@"statusCode"] integerValue];
        if (statusCode == 200) {
            self.MyProfile = [responseDictionary objectForKey:@"model"];
            DLog(@"photoArr = %@",self.MyProfile);
            if (self.MyProfile.verifyDic == [NSNull null]) {
                DLog(@"认证字典为空");
            } else {
                DLog(@"认证字典不为空");
                verifyModel = [[VerifyModel alloc] initWithVerifyModelDictionary:self.MyProfile.verifyDic];
                DLog(@"%@", verifyModel);
            }
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [self.homeTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            DLog(@"hcisdhcsidco");
        }
    }];

    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //个人信息
    [HttpClient getMyProfileWithBlock:^(NSDictionary *responseDictionary) {
    }];
    
    arr = @[@"男装新潮流", @"服装平台", @"童装设计潮流趋势", @"女装新潮流", ];
    [self creatTableView];
    [self creatTableHeaderView];
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
    WKFCircularSlidingView * firstView = [[WKFCircularSlidingView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW * 256 / 640)];
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
        cell.personalDataLeftImage.image = [UIImage imageNamed:@"2.jpg"];
        
        cell.personNameLabel.text = self.MyProfile.name;
      
        cell.personStatusLabel.text = @"注册用户";
        cell.personWalletLeft.text = @"余额：0元";
        cell.personAddressLabel.text = self.MyProfile.address;
        [cell.authenticationButton addTarget:self action:@selector(authenticationAction:) forControlEvents:UIControlEventTouchUpInside];
        if (verifyModel.status == 0) {
            cell.authenticationLabel.text = @"前往认证";
        }
        if (verifyModel.status == 1) {
            cell.authenticationLabel.text = @"认证中";
        }
        if (verifyModel.status == 2) {
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
    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(HomePersonalDataCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        leftTransform = CATransform3DIdentity;
        middleTransform = CATransform3DIdentity;
        rightTransform = CATransform3DIdentity;
        leftTransform = CATransform3DRotate(leftTransform,(M_PI/0*180), 0, 1, 0);
        middleTransform = CATransform3DRotate(middleTransform,(M_PI/0*180), 0, 1, 0);
        rightTransform = CATransform3DRotate(rightTransform,(M_PI/0*180), 0, 1, 0);
        cell.personalDataLeftImage.layer.transform = leftTransform;
        cell.personalDataMiddleImage.layer.transform = middleTransform;
        cell.personalDataRightImage.layer.transform = rightTransform;
        [UIView animateWithDuration:2 animations:^{
            leftTransform = CATransform3DRotate(leftTransform,(M_PI/180*180), 0, 1, 0);//旋转
            middleTransform = CATransform3DRotate(middleTransform,(M_PI/180*180), 0, 1, 0);
            rightTransform = CATransform3DRotate(rightTransform,(M_PI/180*180), 0, 1, 0);
            cell.personalDataLeftImage.layer.transform = leftTransform;
            cell.personalDataMiddleImage.layer.transform = middleTransform;
            cell.personalDataRightImage.layer.transform = rightTransform;
        } completion:^(BOOL finished){
            
        }];
    }
    if (indexPath.section == 2) {
        //xy方向缩放的初始值为0.95
        cell.layer.transform = CATransform3DMakeScale(0.95, 0.95, 1);
        //设置动画时间为0.25秒,xy方向缩放的最终值为1
        [UIView animateWithDuration:0.5 animations:^{
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
        }];
    }
}

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
        }
            break;
        case 3:{
            //供应市场
           
        
        }
            break;
        case 4:{
            //加工配套市场
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
    if (verifyModel.status == 0) {
//        AuthenticationPhotoController *photoVC = [[AuthenticationPhotoController alloc] initWithStyle:UITableViewStyleGrouped];
//        photoVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:photoVC animated:YES];
        AuthenticationController *authenticationVC = [[AuthenticationController alloc] initWithStyle:UITableViewStyleGrouped];
        authenticationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:authenticationVC animated:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
