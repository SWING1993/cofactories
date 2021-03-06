//
//  WithdrawalViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/12/7.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "WithdrawalViewController.h"

static NSString * const CellIdentifier = @"CellIdentifier";


@interface WithdrawalViewController ()<UITextFieldDelegate,UIAlertViewDelegate> {
    LoginButton * lastButton;
    UITextField * priceTextField;
    UITextField * bankcardTextField;

}

@end

@implementation WithdrawalViewController

- (void)viewDidLoad {
    [self initView];
    [super viewDidLoad];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"back"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoActionWithdrawal) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)initView {
    
    self.tableView = [[UITableView alloc] initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;// 竖直滚动条不显示
    
    priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, 0, kScreenW - 100, 44)];
    priceTextField.tag = 2;
    priceTextField.placeholder = [NSString stringWithFormat:@"本次最多可提现%.2f元",[self.money floatValue]];
    priceTextField.font = kFont;
    priceTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    priceTextField.delegate = self;
    
    bankcardTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, 0, kScreenW - 100, 44)];
    bankcardTextField.placeholder = @"开户人与账号认证姓名一致";
    bankcardTextField.font = kFont;
    bankcardTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    bankcardTextField.keyboardType = UIKeyboardTypeDecimalPad;
//    priceTextField.delegate = self;
    
    UIView * tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    
    lastButton = [[LoginButton alloc]initWithFrame:CGRectMake(15,10,kScreenW-30,35)];
    [lastButton setTitle:@"提现" forState:UIControlStateNormal];
    lastButton.userInteractionEnabled = NO;
    [lastButton changeState:lastButton.userInteractionEnabled];
    [lastButton addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
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
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)infoActionWithdrawal {
    DLog(@"输入的金额：%@",priceTextField.text);
    if (priceTextField.text.length == 0 || [priceTextField.text floatValue] == 0 ) {
        lastButton.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        [lastButton setTitleColor:[UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        lastButton.userInteractionEnabled = NO;
    }
    else {
        if (([priceTextField.text floatValue]<[self.money floatValue] || [priceTextField.text floatValue]==[self.money floatValue]) && bankcardTextField.text.length>12) {
            lastButton.userInteractionEnabled = YES;
            [lastButton changeState:lastButton.userInteractionEnabled];
        }
        else {
            DLog(@"提现金额太大");
            lastButton.userInteractionEnabled = NO;
            [lastButton changeState:lastButton.userInteractionEnabled];
        }
    }
}
- (void)payAction {
    [lastButton addShakeAnimation];

    CGFloat money ;
    money = [priceTextField.text floatValue];
    if (0<money) {
        
        NSString * amountStr = [NSString stringWithFormat:@"%.2f",money];
        [HttpClient walletWithDrawWithFee:amountStr WithMethod:@"alipay" WithAccount:bankcardTextField.text andBlock:^(NSInteger statusCode) {
            if (statusCode == 200) {
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"申请提现成功，我们将在2个工作日内处理您的申请，请耐心等待。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
                alertView.tag = 1009;
                [alertView show];                
            }
            else {
                kTipAlert(@"申请提现失败,账户余额%@元。（%ld）",self.money,(long)statusCode);
            }
        }];
    }
    else {
        kTipAlert(@"你输入的%@无法识别，请重新输入！",priceTextField.text);
    }
}

#pragma mark - AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1009 && buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:NO];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 2) {
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        NSInteger flag=0;
        const NSInteger limited = 2;//小数点后需要限制的个数
        for (NSInteger i = futureString.length-1; i>=0; i--) {
            if ([futureString characterAtIndex:i] == '.' ) {
                if (flag > limited) {
                    return NO;
                }
                break;
            }
            flag++;
        }
        return YES;
    }
    else
        return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
