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
#import "HomeSupplyController.h"

static NSString *marketCellIdentifier = @"marketCell";
static NSString *personalDataCellIdentifier = @"personalDataCell";
static NSString *activityCellIdentifier = @"activityCell";
@interface HomeViewController () {
    NSArray *arr;
    CATransform3D leftTransform, middleTransform, rightTransform;
}
@property (nonatomic,strong)NSMutableArray *firstViewImageArray;

@end

@implementation HomeViewController

- (void)viewDidAppear:(BOOL)animated {
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.homeTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:30.0f/255.0f green:171.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
    
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
        
        cell.personNameLabel.text = @"蜻蜓队长";
        cell.personStatusLabel.text = @"注册用户";
        cell.personWalletLeft.text = @"余额：0元";
        cell.personAddressLabel.text = @"杭州市下沙街道天城118号";
        [cell.authenticationButton addTarget:self action:@selector(authenticationAction) forControlEvents:UIControlEventTouchUpInside];
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
        }
            break;
        case 2:{
            //服装市场
        }
            break;
        case 3:{
            //供应市场
            HomeSupplyController *homeSupplyVC = [[HomeSupplyController alloc] init];
            homeSupplyVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homeSupplyVC animated:YES];
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
#pragma mark - Action
- (void)authenticationAction {
    DLog(@"前往认证");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
