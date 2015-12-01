//
//  OrderBid_Supplier_VC.m
//  Cofactories
//
//  Created by GTF on 15/12/1.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "OrderBid_Supplier_VC.h"

@interface OrderBid_Supplier_VC ()

@end
static NSString *const reuseIdentifier = @"reuseIdentifier";
@implementation OrderBid_Supplier_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"投标";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return cell;
}


@end
