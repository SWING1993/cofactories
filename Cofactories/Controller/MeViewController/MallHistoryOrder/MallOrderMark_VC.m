//
//  MallOrderMark_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/2/18.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallOrderMark_VC.h"
#import "MallCommentCell.h"
#import "PlaceholderTextView.h"
#import "MallBuyHistory_VC.h"
#import "MallSellHistory_VC.h"


#define MARKBUTTON_INTERVAL (kScreenW-200-60)/4.f

@interface MallOrderMark_VC ()<UIAlertViewDelegate>

@property (nonatomic,strong)NSMutableArray *buttonArray;
@property (nonatomic,copy)NSString *markString;
@property (nonatomic,strong)PlaceholderTextView *commentTF;

@end

static NSString *const reuseIdentifier = @"reuseIdentifier";
@implementation MallOrderMark_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评分";
    self.tableView.rowHeight = 160;
    [self.tableView registerClass:[MallCommentCell class] forCellReuseIdentifier:reuseIdentifier];
    [self creatTableViewFooterView];
    
    _buttonArray = [@[] mutableCopy];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW/2.f)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    
    NSArray *markArray = @[@"-2",@"-1",@"0",@"1",@"2"];
    for (int i = 0; i<markArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(30+i*(40+MARKBUTTON_INTERVAL), ((kScreenW/2.f)-40)/2.f, 40, 40);
        button.backgroundColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
        [button setTitle:markArray[i] forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 20;
        button.tag = i;
        [button addTarget:self action:@selector(markClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
        
        if (i == 4) {
            button.backgroundColor = kLightBlue;
            [_buttonArray addObject:button];
            _markString = button.titleLabel.text;
        }
    }

}
- (void)creatTableViewFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 160)];
    UIButton *lastButton = [Tools buttonWithFrame:CGRectMake(20, 100, kScreenW - 40, 38) withTitle:@"提交评价"];
    [lastButton addTarget:self action:@selector(markClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:lastButton];
    self.tableView.tableFooterView = footerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MallCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.commentTitle.text = @"添加评价";
    _commentTF = cell.commentTextView;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)markClickAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    UIButton *lastButton = [_buttonArray firstObject];
    lastButton.backgroundColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
    
    button.backgroundColor = kLightBlue;
    [_buttonArray removeAllObjects];
    [_buttonArray addObject:button];
    _markString = button.titleLabel.text;
}
- (void)markClick:(UIButton *)button {
    button.userInteractionEnabled = NO;
    if ([Tools isBlankString:_commentTF.text] == YES) {
        kTipAlert(@"请输入评论内容");
        button.userInteractionEnabled = YES;
    } else {
        [HttpClient mallCommentWithPurchseId:self.purchaseId score:_markString comment:_commentTF.text WithBlock:^(NSDictionary *dictionary) {
            NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
            if (statusCode == 200) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"订单评价成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                [alert show];
                button.userInteractionEnabled = YES;
            } else {
                kTipAlert(@"%@",[dictionary objectForKey:@"message"]);
                button.userInteractionEnabled = YES;
            }
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (self.isBuyHistory) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[MallBuyHistory_VC class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        } else {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[MallSellHistory_VC class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        }
    }
}

@end
