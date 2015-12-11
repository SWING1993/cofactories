//
//  MeDetailSupply_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/10.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MeDetailSupply_VC.h"
#import "MaterialAbstractCell.h"




static NSString *abstractCellIdentifier = @"abstractCell";
@interface MeDetailSupply_VC ()
@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSMutableArray *catergoryArray;

@end

@implementation MeDetailSupply_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"商品详情";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.tableView registerClass:[MaterialAbstractCell class] forCellReuseIdentifier:abstractCellIdentifier];//商品简介
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 3;
    } else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        MaterialAbstractCell *cell = [tableView dequeueReusableCellWithIdentifier:abstractCellIdentifier forIndexPath:indexPath];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (indexPath.section == 0) {
            cell.textLabel.text = @"商品名称";
            cell.detailTextLabel.text = @"太空棉布料面料";
        } else if (indexPath.section == 1) {
            
        } else if (indexPath.section == 2) {
            switch (indexPath.section) {
                case 0: {
                    cell.textLabel.text = @"售价";
                    cell.detailTextLabel.text = @"￥39.50";
                }
                    break;
                case 1: {
                    cell.textLabel.text = @"市场标价";
                    cell.detailTextLabel.text = @"￥36";
                }
                    break;
                case 2: {
                    cell.textLabel.text = @"库存";
                    cell.detailTextLabel.text = @"1000件";
                }
                    break;
                default:
                    break;
            }

        } else {
            
        }
        
        return cell;
    }
    
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 2) {
        return 40;
    } else if (indexPath.row == 1) {
        return 30;
    } else if (indexPath.row == 3) {
        return 30;
    } else {
        return 30;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
