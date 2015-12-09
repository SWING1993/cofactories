//
//  WithdrawalViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/12/7.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "WithdrawalViewController.h"

static NSString *cellIdentifier = @"cellIdentifier";


@interface WithdrawalViewController ()<UITextFieldDelegate> {
    UIButton * lastButton;
    UITextField * priceTextField;
    UITextField * bankcardTextField;

}

@end

@implementation WithdrawalViewController

- (void)viewDidLoad {
        
    [self initView];
    
    [super viewDidLoad];
    
}

- (void)initView {
    
    self.tableView = [[UITableView alloc] initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;// 竖直滚动条不显示
    
    priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, 0, kScreenW - 100, 44)];
    priceTextField.placeholder = [NSString stringWithFormat:@"本次最多可提现%.2f元",[self.money floatValue]];
    priceTextField.font = kFont;
    priceTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    priceTextField.delegate = self;
    
    bankcardTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, 0, kScreenW - 100, 44)];
    bankcardTextField.placeholder = @"与认证银行卡号一致";
    bankcardTextField.font = kFont;
    bankcardTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    bankcardTextField.keyboardType = UIKeyboardTypeDecimalPad;
//    priceTextField.delegate = self;
    
    UIView * tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    
    lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lastButton.frame = CGRectMake(15,10,kScreenW-30,35);
    [lastButton setTitle:@"提现" forState:UIControlStateNormal];
    lastButton.titleLabel.font = [UIFont systemFontOfSize:15.5*kZGY];
    lastButton.layer.cornerRadius = 5;
    lastButton.clipsToBounds = YES;
    lastButton.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    [lastButton setTitleColor:[UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [lastButton addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    lastButton.userInteractionEnabled = NO;
    [tableFooterView addSubview:lastButton];
    self.tableView.tableFooterView = tableFooterView;
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenW - 30, 30)];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithRed:0.431 green:0.431 blue:0.439 alpha:1.000];
    label.numberOfLines = 1;
    label.text = [NSString stringWithFormat:@"可提现金额%.2f元",[self.money floatValue]];
    label.backgroundColor = [UIColor clearColor];
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
    [view addSubview:label];
    self.tableView.tableHeaderView = view;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoActionWithdrawal) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)infoActionWithdrawal {
    DLog(@"输入的金额：%@",priceTextField.text);
    if (priceTextField.text.length == 0) {
        lastButton.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        [lastButton setTitleColor:[UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        lastButton.userInteractionEnabled = NO;
    } else {
        if (([priceTextField.text floatValue]<[self.money floatValue] || [priceTextField.text floatValue]==[self.money floatValue]) && bankcardTextField.text.length>0) {
            lastButton.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:171.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
            [lastButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            lastButton.userInteractionEnabled = YES;

        }else {
            DLog(@"提现金额太大");
            lastButton.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
            [lastButton setTitleColor:[UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            lastButton.userInteractionEnabled = NO;
        }
    }
}
- (void)payAction {
    CGFloat money ;
    money = [priceTextField.text floatValue];
    
   
    
    if (0<money) {
        
        NSString * amountStr = [NSString stringWithFormat:@"%.2f",money];
        [HttpClient walletWithDrawWithFee:amountStr WithMethod:@"alipay" WithAccount:bankcardTextField.text andBlock:^(NSInteger statusCode) {
            if (statusCode == 200) {
                kTipAlert(@"申请提现成功，我们将在2个工作日内处理您的申请，请耐心等待。");
            }
            else {
                kTipAlert(@"申请提现失败,账户余额%@元。（错误码：%ld）",self.money,(long)statusCode);
            }
        }];

      
    }
    else {
        kTipAlert(@"你输入的%@无法识别，请重新输入！",priceTextField.text);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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
            cell.textLabel.text = @"提现金额";
            [cell addSubview:priceTextField];
        }
        else if (indexPath.section == 1 && indexPath.row ==0) {
            cell.textLabel.text = @"银行卡号";
            [cell addSubview:bankcardTextField];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 15;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
