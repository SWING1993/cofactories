//
//  PopularNewsList_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/18.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "PopularNewsList_VC.h"
#import "PopularNewsCell.h"
#import "PopularNewsModel.h"
#import "PopularNewsDetails_VC.h"


static NSString *popularNewsCellIdentifier = @"popularNewsCell";
@interface PopularNewsList_VC ()

@end

@implementation PopularNewsList_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"搜索结果";
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"back"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    [self.tableView registerClass:[PopularNewsCell class] forCellReuseIdentifier:popularNewsCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] init];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.popularNewsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopularNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:popularNewsCellIdentifier forIndexPath:indexPath];
    PopularNewsModel *popularNewsModel = self.popularNewsArray[indexPath.row];
    [cell.photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kPopularBaseUrl, popularNewsModel.newsImage]] placeholderImage:[UIImage imageNamed:@"默认图片"]];
    cell.newstitle.text = popularNewsModel.newsTitle;
    cell.newsDetail.text = popularNewsModel.newsAuthor;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PopularNewsModel *popularNewsModel = self.popularNewsArray[indexPath.row];
    PopularNewsDetails_VC *popularVC = [[PopularNewsDetails_VC alloc] init];
    popularVC.newsID = popularNewsModel.newsID;
    [self.navigationController pushViewController:popularVC animated:YES];

}

- (void) back {
    [self.navigationController popViewControllerAnimated:YES];
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
