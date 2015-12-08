//
//  WalletViewController.m
//  Cofactories
//
//  Created by GTF on 15/11/18.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "WalletViewController.h"
#import "AuthenticationController.h"
#import "HttpClient.h"
#import "RechargeViewController.h"
#import "WalletModel.h"
#import "WithdrawalViewController.h"

#define kHeaderHeight kScreenW*0.47


@interface WalletViewController () {
    UIButton * _leftBtn;
    UIButton * _rightBtn;
    UILabel  * _myLabel;
}
@property (nonatomic,retain)WalletModel * walletModel;
@property (nonatomic,retain)UserModel * MyProfile;

@end

@implementation WalletViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    UIColor * color = [UIColor clearColor];
    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    
    self.MyProfile = [[UserModel alloc]getMyProfile];
    [HttpClient getwalletWithBlock:^(NSDictionary *responseDictionary) {
        NSInteger statusCode = [[responseDictionary objectForKey:@"statusCode"]integerValue];
        if (statusCode == 200) {
            self.walletModel = [responseDictionary objectForKey:@"model"];
            _myLabel.text = [NSString stringWithFormat:@"账户余额\n\n%.2f元",self.walletModel.money];
        }
        else {
            NSString * message = [responseDictionary objectForKey:@"message"];
            kTipAlert(@"%@(错误码：%ld)",message,(long)statusCode);
        }
    }];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self creatTableView];
}


- (void)creatTableView {
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.tag = 1;
    _leftBtn.frame = CGRectMake(0, 0, kScreenW/2, 49);
    [_leftBtn setImage:[UIImage imageNamed:@"wallet_left"] forState:UIControlStateNormal];
    _leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_leftBtn addTarget:self action:@selector(clickHeaderBtnInSection:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.tag = 2;
    _rightBtn.frame = CGRectMake(kScreenW/2+1, 0, kScreenW/2, 49);
    [_rightBtn setImage:[UIImage imageNamed:@"wallet_right"] forState:UIControlStateNormal];
    _rightBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_rightBtn addTarget:self action:@selector(clickHeaderBtnInSection:) forControlEvents:UIControlEventTouchUpInside];
    
    _myLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenW*0.47/3, kScreenW, kScreenW*0.47/2)];
    _myLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _myLabel.numberOfLines = 3;
    _myLabel.textAlignment = NSTextAlignmentCenter;
    _myLabel.textColor = [UIColor whiteColor];

    
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW * 0.47)];
    image.image = [self imageFromColor:[UIColor colorWithRed:0.188 green:0.475 blue:0.839 alpha:1.000] forSize:CGSizeMake(kScreenW, kScreenW*0.47) withCornerRadius:0];
    [image addSubview:_myLabel];
    
    

    self.walletTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, kScreenW, kScreenH+64) style:UITableViewStyleGrouped];
    self.walletTableView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
    self.walletTableView.delegate = self;
    self.walletTableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = YES;// 自动调整视图关闭
    self.walletTableView.showsVerticalScrollIndicator = NO;// 竖直滚动条不显示
    
    self.walletTableView.tableHeaderView = image;
    [self.view addSubview:self.walletTableView];
    
}
- (void)clickHeaderBtnInSection:(UIButton *)btn {
    if (btn.tag == 1) {
        RechargeViewController * vc1 = [[RechargeViewController alloc]init];
        vc1.title = @"充值";
        vc1.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc1 animated:NO];
    }
    else if (btn.tag == 2) {
        WithdrawalViewController * vc2 = [[WithdrawalViewController alloc]init];
        vc2.title = @"提现";
        vc2.money = @"200";
        vc2.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc2 animated:NO];
    
    }
}

#pragma mark - UITableViewDataSource

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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.font=[UIFont systemFontOfSize:14.5];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"资金明细";
            }
            else if (indexPath.row == 1) {
                cell.textLabel.text = @"实名认证";
            }
        } else {
            cell.textLabel.text = @"关于钱包";
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 55;
    }
    return 5.0f;}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //资金明细
            
        } else if (indexPath.row == 1) {
            //实名认证
            if (self.MyProfile.status == 0) {
                AuthenticationController *authenticationVC = [[AuthenticationController alloc] initWithStyle:UITableViewStyleGrouped];
                authenticationVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:authenticationVC animated:YES];
                
            }else if (self.MyProfile.status == 1){
                kTipAlert(@"您的认证正在审核中！");
            }else{
                kTipAlert(@"您已实名认证！");
            }
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            DLog(@"关于钱包");
        }
    }
}


- (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContext(size);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return image;
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
