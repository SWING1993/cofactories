//
//  WalletHistoryInfoViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/12/11.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "WalletHistoryInfoViewController.h"

@interface WalletHistoryInfoViewController ()

@end

@implementation WalletHistoryInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.tableView = [[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    }else
        return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = self.model.status;
                cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0f];
                cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14.5f];

                if (self.model.fee>0) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"+%.2f 元",self.model.fee];
                    cell.detailTextLabel.textColor = kGreen;
                }else {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f 元",self.model.fee];
                    cell.detailTextLabel.textColor = [UIColor redColor];
                }
            }
                break;
            case 1:
            {
               cell.textLabel.text = @"订单号";
                cell.detailTextLabel.text = self.model.Walletid;
                cell.textLabel.font = kFont;
                cell.detailTextLabel.font = kFont;
            }
                break;
            case 2:
            {
                cell.textLabel.text = @"交易类型";
                cell.detailTextLabel.text = self.model.type;
                cell.textLabel.font = kFont;
                cell.detailTextLabel.font = kFont;
            }
                break;
            case 3:
            {
                cell.textLabel.text = @"创建时间";
                cell.detailTextLabel.text = self.model.createdTime;
                cell.textLabel.font = kFont;
                cell.detailTextLabel.font = kFont;

            }
                break;
            case 4:
            {
                cell.textLabel.text = @"创建时间";
            }
                break;
                
            default:
                break;
        }
    }
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
