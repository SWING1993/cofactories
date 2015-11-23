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

@interface MeViewController ()

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.

    //退出账号 [HttpClient deleteToken];
    /*
    UserModel * model = [[UserModel alloc]getMyProfile];
    NSLog(@"model.uid = %@\n model.UserType = %ld",model.uid,(long)model.UserType);
    AFOAuthCredential *credential=[HttpClient getToken];
    DLog(@"\n accessToken = %@ \n refreshToken = %@ \n credential.expired = %d",credential.accessToken,credential.refreshToken,credential.expired)
     */

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
