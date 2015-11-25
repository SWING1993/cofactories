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
#import "Cofactories-Swift.h"

@interface MeViewController ()

@property (nonatomic,strong)UserModel * MyProfile;

@end

@implementation MeViewController {
    UIImageView * _tableHeadView;
    UIImageView * _headView;

    UIButton * _leftBtn;
    UIButton * _rightBtn;
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
//
//    [HttpClient getMyProfileWithBlock:^(NSDictionary *responseDictionary) {
//    }];
//
//}
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
//}


- (void)viewDidLoad {
    [super viewDidLoad];

    [HttpClient deleteToken];

    self.navigationController.navigationBarHidden = YES;

    self.MyProfile = [[UserModel alloc]getMyProfile];
    DLog(@"type = %ld",self.MyProfile.UserType);
    
    _tableHeadView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW*0.47)];
    _tableHeadView.image = [UIImage imageNamed:@"Me_tableHeadView"];
    
    
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.tableHeaderView = _tableHeadView;

    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.tag = 1;
    _leftBtn.frame = CGRectMake(0, 0, kScreenW/2, 49);
    [_leftBtn setImage:[UIImage imageNamed:@"Me_leftBtn"] forState:UIControlStateNormal];
    _leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_leftBtn addTarget:self action:@selector(clickHeaderBtnInSection:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.tag = 2;
    _rightBtn.frame = CGRectMake(kScreenW/2+1, 0, kScreenW/2, 49);
    [_rightBtn setImage:[UIImage imageNamed:@"Me_RightBtn"] forState:UIControlStateNormal];
    _rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_rightBtn addTarget:self action:@selector(clickHeaderBtnInSection:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)clickHeaderBtnInSection:(UIButton *)Btn {
    if (Btn.tag == 1) {
        DLog(@"个人资料");
        SetViewController * SetVC = [[SetViewController alloc]init];
        SetVC.title = @"个人资料";
        SetVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:SetVC animated:YES];
    }
    if (Btn.tag == 2) {
        DLog(@"我的订单");
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    switch (self.MyProfile.UserType) {
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
        return 2;
    }else {
        return 1;
    }
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
                        cell.textLabel.text = @"我的店铺";
                        break;
                    case 1:
                        cell.textLabel.text = @"我的活动";
                        break;
                }
                break;
             
            case 1:
                cell.textLabel.text = @"购物车";
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
            case 0:
            switch (indexPath.row) {
                case 0:
                    DLog(@"我的店铺");
                    break;
                case 1:
                    DLog(@"我的活动");
                    break;
            }
            break;
            
            case 1:
            DLog("购物车");
            break;
            
            case 2:
            DLog(@"流行资讯发布");
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
