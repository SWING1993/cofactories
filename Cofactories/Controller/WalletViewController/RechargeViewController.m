//
//  RechargeViewController.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/24.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "Order.h"

#import "RechargeViewController.h"
#import "ZhiFuBaoCell.h"
#import <AlipaySDK/AlipaySDK.h>

#import "AlipayHeader.h"

//// partner:合作者身份(PID),以 2088 开头由 16 位纯数字组成的字符串。
//
//#define kPartnerID @"合作者身份PID"
//
////﻿  seller:支付宝收款账号,手机号码或邮箱格式。(支付宝登录账号)
//
//#define kSellerAccount @"收款账号"
//
//// private_key:商户方的私钥,pkcs8 格式。
//
//#define kPrivateKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALhEjUj0Gi/n1V8Eb+A1gEXXR2JXguE1/YJ6KEEmH5A2WP5h0XcUU9GdgIV6O4C/gzAf1jmaRhlwKweP+GawQ84vHmFF+zoEZDIiHOvHr3FJJ2SsB1zslYG3Ri0gpG023cLuMlCiy6AoxXJQn3LGfLgqeJfvLz+nhcz3vCB6EJrZAgMBAAECgYAvnNb88MYLdtX1VUorHufkI/o3+PDCjJbSrgnUu6sQMlrQcCoVoNT/prjcxHa3j8SwHKnX/Hr8e7VCoPrIXedG4Gc5u9PWukHzyYteByTuY29mJ2QmKhy1gzaCWGjkeF90kBST39oqwireWIaJZfi+sAjXAmu8crzg9s6dzB3ouQJBAPVJO557CFfSBjFbdrro+npE1p1erukhOHoIuPlTVkrQlGmZfVJKe+9IAi+36DgSzWvqDoonNblhIn0wtfYfaKcCQQDAUQSXbBRQfrrWvHHWVnNLm5G75qsTpaKlN85zpDj6UtQ+QMge+pYdaEQGWEIyOZdno2IR7ywmLc0pu5JDbNB/AkAS7j39sz0nmfwEXyzArC54tUtjBeW19Gxpbrbn9ziXuZVauQ/lA/6grwwMJsNzYHAePgg1PWV2EzsYMmQ4xJ/NAkBb2hYsUCV/sJeCGizwpweYE+xN50TMNG7zJC1JlCTWghr2xLAQA7UQxIzAzwSGwnTqveEIGchnT7bOeNTJuT33AkEA3PLB2aOV7rxnzDZisrhmxWp+KaaoM6UyY5lbMXR9SQe0yyckbJX+31b+pIGi39bnghBB5fgJFvzkqtbhDESqKg=="


static NSString *cellIdentifier = @"cellIdentifier";

@interface RechargeViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
    UIButton *lastButton;
    UITextField *priceTextField;
}

@property (nonatomic,strong)UITableView * rechargeTableView;

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值";
    
    [self initView];
}

- (void)initView {
    
    self.rechargeTableView = [[UITableView alloc] initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.rechargeTableView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
    self.rechargeTableView.delegate = self;
    self.rechargeTableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = YES;// 自动调整视图关闭
    self.rechargeTableView.showsVerticalScrollIndicator = NO;// 竖直滚动条不显示
    [self.view addSubview:self.rechargeTableView];
    
    priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, kScreenW - 100, 44)];
    priceTextField.placeholder = @"请输入金额";
    
    priceTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    priceTextField.delegate = self;
    
    UIView * tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    
    lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lastButton.frame = CGRectMake(15,10,kScreenW-30,35);
    [lastButton setTitle:@"下一步" forState:UIControlStateNormal];
    lastButton.titleLabel.font = [UIFont systemFontOfSize:15.5*kZGY];
    lastButton.layer.cornerRadius = 5;
    lastButton.clipsToBounds = YES;
    lastButton.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    [lastButton setTitleColor:[UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [lastButton addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    lastButton.userInteractionEnabled = NO;
    [tableFooterView addSubview:lastButton];
    self.rechargeTableView.tableFooterView = tableFooterView;

    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenW - 30, 35)];
    label.font = [UIFont systemFontOfSize:11];
    label.textColor = [UIColor redColor];
    label.numberOfLines = 0;
    label.text = @"充值金额达5000元以上将自动转为线下充值，届时会由我们的客服联系您并告知具体操作步骤。";
    label.backgroundColor = [UIColor clearColor];
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 35)];
    view.backgroundColor = [UIColor colorWithRed:1.000 green:0.953 blue:0.498 alpha:1.000];
    [view addSubview:label];
    self.rechargeTableView.tableHeaderView = view;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoAction) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)infoAction {
    DLog(@"输入的金额：%@",priceTextField.text);
    if (priceTextField.text.length == 0) {
        lastButton.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        [lastButton setTitleColor:[UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        lastButton.userInteractionEnabled = NO;
    } else {
        lastButton.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:171.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
        [lastButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        lastButton.userInteractionEnabled = YES;
    }
}

- (void)payAction {
    CGFloat money ;
    money = [priceTextField.text floatValue];
    if ((0<money && money<5000) || money == 5000 ) {
        kTipAlert(@"支付宝");
        
        NSString * amountStr = [NSString stringWithFormat:@"%.2f",money];
        [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:[AlipayToolKit genTradeNoWithTime] productName:@"邮票" productDescription:@"全真邮票" amount:amountStr notifyURL:kNotifyURL itBPay:@"30m"];
    }
    else if (5000<money ) {
        kTipAlert(@"使用线下支付");
    }
    else {
        kTipAlert(@"你输入的%@无法识别，请重新输入！",priceTextField.text);
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = kFont;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryNone];

        if (indexPath.section == 0 && indexPath.row ==0) {
            cell.textLabel.text = @"金额：";
            [cell addSubview:priceTextField];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
