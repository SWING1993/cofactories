//
//  MangerOrderVC.m
//  Cofactories
//
//  Created by GTF on 15/11/28.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MangerOrderVC.h"

@interface MangerOrderVC ()

@end

@implementation MangerOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"管理订单";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    // Do any additional setup after loading the view.
}

- (void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
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
