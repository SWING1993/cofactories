//
//  PersonalMessage_Design_VC.m
//  Cofactories
//
//  Created by GTF on 15/12/9.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "PersonalMessage_Design_VC.h"

@interface PersonalMessage_Design_VC ()

@end
static NSString *const reuseIdentifier = @"reuseIdentifier";
@implementation PersonalMessage_Design_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigator_btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackClick)];
    self.navigationItem.title = @"个人信息";
    
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void)goBackClick{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
