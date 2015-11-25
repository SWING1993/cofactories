//
//  RechargeViewController.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/24.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "RechargeViewController.h"
#import "ZhiFuBaoCell.h"

static NSString *zhiFuBaoCellIdentifier = @"zhiFuBaoCell";

@interface RechargeViewController ()<UITextFieldDelegate> {
    UIButton *lastButton;
    UITextField *priceTextField;
}

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
    [self creatUI];
}

- (void)creatUI {
    UILabel *firstTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*kZGY, 64, kScreenW - 40*kZGY, 30*kZGY)];
    firstTitleLabel.text = @"请选择充值方式";
    firstTitleLabel.font = [UIFont systemFontOfSize:13*kZGY];
    firstTitleLabel.textColor = [UIColor colorWithRed:156.0f/255.0f green:156.0f/255.0f blue:156.0f/255.0f alpha:1.0f];
    [self.view addSubview:firstTitleLabel];
    
    UIView *bigView1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(firstTitleLabel.frame), kScreenW, 70*kZGY)];
    bigView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bigView1];
    
    UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(20*kZGY, 10*kZGY, 120*kZGY, 50*kZGY)];
    photoView.image = [UIImage imageNamed:@"Wallet-支付宝"];
    [bigView1 addSubview:photoView];
    
    UILabel *secondTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*kZGY, CGRectGetMaxY(bigView1.frame), kScreenW - 40*kZGY, 45*kZGY)];
    secondTitleLabel.text = @"若金额较大，请联系客服线下充值。";
    secondTitleLabel.font = [UIFont systemFontOfSize:13*kZGY];
    secondTitleLabel.textColor = [UIColor colorWithRed:156.0f/255.0f green:156.0f/255.0f blue:156.0f/255.0f alpha:1.0f];
    [self.view addSubview:secondTitleLabel];
    
    UIView *bigView2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(secondTitleLabel.frame), kScreenW, 50*kZGY)];
    bigView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bigView2];

    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*kZGY, 0, 50*kZGY, 50*kZGY)];
    priceLabel.text = @"金额";
    priceLabel.font = [UIFont systemFontOfSize:16*kZGY];
    [bigView2 addSubview:priceLabel];
    
    priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, kScreenW - 80*kZGY, 50*kZGY)];
    priceTextField.placeholder = @"请输入金额";
    priceTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    priceTextField.delegate = self;
    [bigView2 addSubview:priceTextField];
    
    lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lastButton.frame = CGRectMake(20*kZGY, CGRectGetMaxY(bigView2.frame) + 30*kZGY, kScreenW - 40*kZGY, 38*kZGY);
    //30,171,235
    [lastButton setTitle:@"确认支付" forState:UIControlStateNormal];
    lastButton.titleLabel.font = [UIFont systemFontOfSize:15.5*kZGY];
    lastButton.layer.cornerRadius = 4*kZGY;
    lastButton.clipsToBounds = YES;
    lastButton.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    [lastButton setTitleColor:[UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    lastButton.userInteractionEnabled = NO;
    [lastButton addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lastButton];
    
    UIButton *bankButton = [UIButton buttonWithType:UIButtonTypeSystem];
    bankButton.frame = CGRectMake(20*kZGY, CGRectGetMaxY(lastButton.frame), 110*kZGY, 50*kZGY);
    [bankButton setTitle:@"使用线下支付充值" forState:UIControlStateNormal];
    [bankButton setTitleColor:[UIColor colorWithRed:0.0f/255.0f green:170.0f/255.0f blue:238.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    bankButton.titleLabel.font = [UIFont systemFontOfSize:13*kZGY];
    [bankButton addTarget:self action:@selector(bankPayAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bankButton];
    //235,235,240
    //210,210,210
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(changeValue:)
//                                                 name:@"changeValue" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoAction) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)infoAction {
    DLog(@"khdvkdfhvk");
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

- (void)payAction:(UIButton *)button {
    DLog(@"去支付");
}
- (void)bankPayAction:(UIButton *)button {
    DLog(@"使用线下支付");
}



//- (void)creatTableView {
//    self.rechargeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)style:UITableViewStyleGrouped];
//    self.rechargeTableView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
//    self.rechargeTableView.delegate = self;
//    self.rechargeTableView.dataSource = self;
//    self.automaticallyAdjustsScrollViewInsets = YES;// 自动调整视图关闭
//    self.rechargeTableView.showsVerticalScrollIndicator = NO;// 竖直滚动条不显示
//    [self.view addSubview:self.rechargeTableView];
//    [self.rechargeTableView registerClass:[ZhiFuBaoCell class] forCellReuseIdentifier:zhiFuBaoCellIdentifier];
//}
//
//
//#pragma mark - UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 2;
//    }
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (indexPath.section == 0) {
//        ZhiFuBaoCell *cell = [tableView dequeueReusableCellWithIdentifier:zhiFuBaoCellIdentifier forIndexPath:indexPath];
//        cell.photoView.image = [UIImage imageNamed:@"Wallet-支付宝"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    } else {
//        UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        }
//
//        return cell;
//    }
//    
//    
//}
//
//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return @"请选择充值方式";
//    } else if (section == 1) {
//        return @"小额充值推荐用支付宝, 大额充值最好去柜台办理";
//    } else {
//        return nil;
//    }
//}
//
//
//#pragma mark - UITableViewDelegate
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return 70;
//    }
//    return 40;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return 30;
//    } else if (section == 1) {
//        return 30;
//    }
//    return 1;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.1;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}



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
