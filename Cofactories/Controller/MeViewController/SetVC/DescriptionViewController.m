//
//  DescriptionViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/18.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Tools.h"
#import "HttpClient.h"
#import "DescriptionViewController.h"

@interface DescriptionViewController () {

    UITextView*descriptionTV;

}

@end

@implementation DescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"公司简介";
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;

    CGSize size = [Tools getSize:self.placeholder andFontOfSize:15.0f];
    descriptionTV=[[UITextView alloc]initWithFrame:CGRectMake(15, 0, kScreenW-30, size.height+40)];
    descriptionTV.font=kLargeFont;
    descriptionTV.text=self.placeholder;

    //设置Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.rightBarButtonItem = setButton;
}

- (void)buttonClicked{

    if ([descriptionTV.text isEqualToString:@""]) {
        kTipAlert(@"公司简介不能为空！");
    }else{
        MBProgressHUD *hud = [Tools createHUD];
        hud.labelText = @"正在修改姓名!";
        
        NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc]initWithCapacity:1];
        [parametersDic setObject:descriptionTV.text forKey:@"description"];
        
        [HttpClient postMyProfileWithDic:parametersDic andBlock:^(NSInteger statusCode) {
            if (statusCode == 200) {
                hud.labelText = @"公司简介修改成功!";
                [hud hide:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [hud hide:YES];
                kTipAlert(@"公司简介修改失败!");
            }
        }];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGSize size = [Tools getSize:self.placeholder andFontOfSize:15.0f];
    return size.height+40;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    [cell addSubview:descriptionTV];
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
