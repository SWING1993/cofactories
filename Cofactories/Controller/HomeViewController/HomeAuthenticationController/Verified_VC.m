//
//  Verified_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/28.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "Verified_VC.h"
#import "MeTextLabelCell.h"
static NSString *myCellIdentifier = @"myCell";
@interface Verified_VC () {
    NSArray *titleArray;
    NSArray *verifiedArray;
}

@end

@implementation Verified_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"认证信息";
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"back"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    titleArray = @[@"企业名称", @"企业地址", @"个人姓名", @"身份证号", @"认证时间"];
    verifiedArray = @[self.verifiedModel.verify_enterpriseName, self.verifiedModel.verify_enterpriseAddress, self.verifiedModel.verify_personName, self.verifiedModel.verify_idCard, self.verifiedModel.verify_CreatedAt];
    DLog(@"++++++%@, ++++++%@, ++++++%@, ++++++%@, ++++++%@, ++++++%@", self.verifiedModel.verify_enterpriseName, self.verifiedModel.verify_enterpriseAddress, self.verifiedModel.verify_personName, self.verifiedModel.verify_idCard, self.verifiedModel.verify_CreatedAt, self.status);
    [self.tableView registerClass:[MeTextLabelCell class] forCellReuseIdentifier:myCellIdentifier];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeTextLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:myCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.shangPinTitle.font = [UIFont systemFontOfSize:14];
    cell.shangPinDetail.textColor = [UIColor grayColor];
    if (indexPath.section == 0) {
        cell.shangPinTitle.text = titleArray[indexPath.row];
        cell.shangPinDetail.text = verifiedArray[indexPath.row];
    } else {
        cell.shangPinTitle.text = @"认证状态";
        cell.shangPinDetail.text = self.status;
        if ([self.status isEqualToString:@"正在审核"]) {
            cell.shangPinDetail.textColor = [UIColor redColor];
            cell.shangPinDetail.font = [UIFont boldSystemFontOfSize:14];
        }
        if ([self.status isEqualToString:@"认证成功"]) {
            cell.shangPinDetail.textColor = kGreen;
            cell.shangPinDetail.font = [UIFont boldSystemFontOfSize:14];
        }
        
    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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
