//
//  RechargeViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/24.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "Order.h"

#import "RechargeViewController.h"
//#import "ZhiFuBaoCell.h"
#import <AlipaySDK/AlipaySDK.h>

#import "AlipayHeader.h"

static NSString * const CellIdentifier = @"CellIdentifier";

@interface RechargeViewController ()<UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate> {
    LoginButton *lastButton;
    UITextField *priceTextField;
}
@property (nonatomic,strong) UserModel * selfModel;

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selfModel = [UserModel User];
    [self initView];
}

- (void)initView {
    
    self.title = @"充值";

    self.tableView = [[UITableView alloc] initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;// 竖直滚动条不显示
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"back"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, kScreenW - 80, 44)];
    priceTextField.placeholder = @"输入充值金额";
    priceTextField.tag = 2;
    priceTextField.font = kFont;
    priceTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    priceTextField.delegate = self;
    
    UIView * tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    
    lastButton = [[LoginButton alloc]initWithFrame:CGRectMake(15,10,kScreenW-30,35)];
    [lastButton setTitle:@"充值" forState:UIControlStateNormal];
    lastButton.userInteractionEnabled = NO;
    [lastButton changeState:lastButton.userInteractionEnabled];
    [lastButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:lastButton];
    self.tableView.tableFooterView = tableFooterView;

    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenW - 30, 35)];
    label.font = [UIFont systemFontOfSize:11];
    label.textColor = [UIColor redColor];
    label.numberOfLines = 0;
    label.text = @"充值金额达5000元以上将自动转为线下充值，届时会由我们的客服联系您并告知具体操作步骤。";
    label.backgroundColor = [UIColor clearColor];
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 35)];
    view.backgroundColor = [UIColor colorWithRed:1.000 green:0.953 blue:0.498 alpha:1.000];
    [view addSubview:label];
    self.tableView.tableHeaderView = view;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoActionRecharge) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)infoActionRecharge {
    DLog(@"输入的金额：%@",priceTextField.text);
    if (priceTextField.text.length == 0 || priceTextField.text.length > 12) {
        lastButton.userInteractionEnabled = NO;
        [lastButton changeState:lastButton.userInteractionEnabled];
    } else {
        lastButton.userInteractionEnabled = YES;
        [lastButton changeState:lastButton.userInteractionEnabled];
    }
}


- (void)payAction:(UIButton*)Btn {
    [priceTextField resignFirstResponder];
    [Btn addShakeAnimation];
    if ([self.selfModel.enterprise isEqualToString:@"非企业用户"]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"线下充值", @"支付宝充值", nil];
        [actionSheet showInView:self.view];
    }else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"线下充值", @"支付宝充值", @"企业账号充值", nil];
        [actionSheet showInView:self.view];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSString *str = [NSString stringWithFormat:@"telprompt://%@", kCustomerServicePhone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else if (buttonIndex == 1) {
            MBProgressHUD *hud = [Tools createHUD];
            hud.labelText = @"正在生成订单";
            [priceTextField resignFirstResponder];
            CGFloat money ;
            money = [priceTextField.text floatValue];
            if (0<money && money<=5000) {
                NSString * amountStr = [NSString stringWithFormat:@"%.2f",money];
                [HttpClient walletWithFee:amountStr WihtCharge:^(NSDictionary *responseDictionary) {
                    NSInteger statusCode = [[responseDictionary objectForKey:@"statusCode"]integerValue];
                    if (statusCode == 200) {
                        NSDictionary * dataDic = [responseDictionary objectForKey:@"data"];
                        NSString * tradeNO = [dataDic objectForKey:@"_id"];
                        NSString * descriptionStr = [dataDic objectForKey:@"description"];
                        NSString * subject = [dataDic objectForKey:@"subject"];
        
                        if (tradeNO && descriptionStr && subject) {
                            [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:tradeNO productName:subject productDescription:descriptionStr amount:amountStr notifyURL:kNotifyURL itBPay:@"30m"];
                            [hud hide:YES];
                        }
                        else {
                            [hud hide:YES];
                            kTipAlert(@"生成订单失败");
                        }
                    }
                    else if (statusCode == 0) {
                        kTipAlert(@"网络暂无连接");
                    }
                    else {
                        [hud hide:YES];
                        kTipAlert(@"生成订单失败 (%ld)",(long)statusCode);
                    }
                }];
            }
            else if (5000<money ) {
                [hud hide:YES];
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"充值金额过大，请联系客服进行线下充值！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 5000;
                [alertView show];
                
            }
            else {
                [hud hide:YES];
                kTipAlert(@"你输入的%@无法识别，请重新输入！",priceTextField.text);
            }
    }else if (buttonIndex == 2) {
        DLog(@"%@",self.selfModel.enterprise);
        if ([self.selfModel.enterprise isEqualToString:@"非企业用户"]) {
            return;
        }else {
            CGFloat money ;
            money = [priceTextField.text floatValue];
            NSString * amountStr = [NSString stringWithFormat:@"%.2f",money];
            [HttpClient walletEnterpriseWithFee:amountStr wihtCharge:^(NSDictionary *responseDictionary) {
                NSInteger statusCode = [[responseDictionary objectForKey:@"statusCode"] integerValue];
                DLog(@"充值状态 %ld",(long)statusCode);
                switch (statusCode) {
                    case 200:{
                        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"申请成功，等待主账号审核" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        alertView.tag = 200;
                        [alertView show];
                    }
                        break;
                        
                    default:
                        kTipAlert(@"申请失败（%ld）",(long)statusCode);
                        break;
                }
            }];
        }
    }else if (buttonIndex == 3) {
        return;
    }
}

- (void)getPayDataWithBlock:(void (^)(NSDictionary *responseDictionary))block {
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1 && alertView.tag == 5000) {
        NSString *str = [NSString stringWithFormat:@"telprompt://%@", kCustomerServicePhone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else if (buttonIndex == 1 && alertView.tag == 200) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else {
        DLog(@"取消线下充值");
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = kFont;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryNone];

        if (indexPath.section == 0 && indexPath.row ==0) {
            cell.textLabel.text = @"金额";
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
