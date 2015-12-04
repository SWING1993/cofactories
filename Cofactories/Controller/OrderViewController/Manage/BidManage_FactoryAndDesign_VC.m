//
//  BidManage_FactoryAndDesign_VC.m
//  Cofactories
//
//  Created by GTF on 15/12/4.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "BidManage_FactoryAndDesign_VC.h"
#import "BidManage_FD_TVC.h"

@interface BidManage_FactoryAndDesign_VC ()

@end
static NSString *const reuseIdentifier = @"reuseIdentifier";
@implementation BidManage_FactoryAndDesign_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"投标管理";
    [self.tableView registerClass:[BidManage_FD_TVC class] forCellReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BidManage_FD_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    return cell;
}
@end
