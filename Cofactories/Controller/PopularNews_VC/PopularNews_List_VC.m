//
//  PopularNews_List_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/3/8.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "PopularNews_List_VC.h"
#import "PopularNews_Cell.h"

static NSString *newsCellIdentifier = @"newsCell";
@interface PopularNews_List_VC ()

@end

@implementation PopularNews_List_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"%@文章", self.selectType];
    self.tableView.rowHeight = 135*kZGY;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[PopularNews_Cell class] forCellReuseIdentifier:newsCellIdentifier];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopularNews_Cell *cell = [tableView dequeueReusableCellWithIdentifier:newsCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userPhoto.image = [UIImage imageNamed:@"meinv.jpg"];
    cell.userName.text = @"燕子photo";
    cell.newsType.text = @"设计师";
    cell.newsPhoto.image = [UIImage imageNamed:@"1.jpg"];
    cell.newsTitle.text = @"好戏就要开场，你功课做足了吗？";
    NSString *string = @"我叫我今儿机会也很好斤斤计较尽快解决经济我开开开开开已已已已已已奇偶姐姐看看解决快乐老家临渴掘...";
    
    cell.newsDetail.attributedText = [PopularNews_List_VC getAttributedStringWithString:string];
    cell.readCount.text = @"153";
    cell.commentCount.text = @"121";
    return cell;
}


+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    return attributedString;
}

@end
