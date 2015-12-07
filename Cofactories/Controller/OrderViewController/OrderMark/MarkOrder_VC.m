//
//  MarkOrder_TVC.m
//  Cofactories
//
//  Created by GTF on 15/12/5.
//  Copyright © 2015年 宋国华. All rights reserved.



#define MARKBUTTON_INTERVAL (kScreenW-200-60)/4.f
#import "MarkOrder_VC.h"
#import "Comment_TVC.h"

@interface MarkOrder_VC ()<UIAlertViewDelegate>
@property (nonatomic,strong)NSMutableArray *buttonArray;
@property (nonatomic,copy)NSString *markString;
@property (nonatomic,strong)UITextView *commentTF;
@end
static NSString *const reuseIdentifier = @"reuseIdentifier";
@implementation MarkOrder_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评分";
    self.tableView.rowHeight = 100;
    [self.tableView registerClass:[Comment_TVC class] forCellReuseIdentifier:reuseIdentifier];
    
    _buttonArray = [@[] mutableCopy];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW/2.f)];
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
            button.backgroundColor = MAIN_COLOR;
            [_buttonArray addObject:button];
            _markString = button.titleLabel.text;
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Comment_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.commentLB.text = @"添加评价";
    _commentTF = cell.commentTextView;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 80)];
    
    UIButton *markButton = [UIButton buttonWithType:UIButtonTypeCustom];
    markButton.frame = CGRectMake(20, 30, kScreenW-40, 35);
    markButton.backgroundColor = MAIN_COLOR;
    markButton.layer.masksToBounds = YES;
    markButton.layer.cornerRadius = 5;
    [markButton setTitle:@"提交评价" forState:UIControlStateNormal];
    markButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [markButton addTarget:self action:@selector(markClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:markButton];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)markClickAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    UIButton *lastButton = [_buttonArray firstObject];
    lastButton.backgroundColor = [UIColor colorWithRed:193/255.0 green:193/255.0 blue:193/255.0 alpha:1];
    
    button.backgroundColor = MAIN_COLOR;
    [_buttonArray removeAllObjects];
    [_buttonArray addObject:button];
    _markString = button.titleLabel.text;
}

- (void)markClick{
    
    DLog(@"%@,,,,%@",_markString,_commentTF.text);

    switch (_markOrderType) {
        case MarkOrderType_Supplier:{
            
            [HttpClient judgeSupplierOrderWithOrderID:self.orderID score:_markString comment:_commentTF.text WithCompletionBlock:^(NSDictionary *dictionary) {
                
                NSString *stateString = dictionary[@"statusCode"];
                if ([stateString isEqualToString:@"200"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"订单评价成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alert show];
                }
            }];
            
        }
            break;
        case MarkOrderType_Factory:{
            [HttpClient judgeFactoryOrderWithOrderID:self.orderID score:_markString comment:_commentTF.text WithCompletionBlock:^(NSDictionary *dictionary) {
                
                
                NSString *stateString = dictionary[@"statusCode"];
                if ([stateString isEqualToString:@"200"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"订单评价成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alert show];
                }
            }];
            
        }
            break;
        case MarkOrderType_Design:{
            [HttpClient judgeDesignOrderWithOrderID:self.orderID score:_markString comment:_commentTF.text WithCompletionBlock:^(NSDictionary *dictionary) {
                
                
                NSString *stateString = dictionary[@"statusCode"];
                if ([stateString isEqualToString:@"200"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"订单评价成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alert show];
                }
            }];

        }
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
