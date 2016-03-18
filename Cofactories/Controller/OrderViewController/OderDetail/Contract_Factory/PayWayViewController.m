//
//  PayWayViewController.m
//  Cofactories
//
//  Created by GTF on 16/3/17.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "PayWayViewController.h"
#import "PayWaySelectTableViewCell.h"
#import "PayWayModel.h"

@interface PayWayViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton    *payBtn;
@property (nonatomic,strong)FactoryOrderMOdel *model;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,copy)NSString  *payWayString;

@end

@implementation PayWayViewController

- (id)initWithFacModel:(FactoryOrderMOdel *)model{
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单支付";
    _dataArray = [@[] mutableCopy];
    
    for (int i = 0; i<2; i++) {
        PayWayModel *payModel = [PayWayModel new];
        if (i==0) {
            payModel.imageString = @"qianbaopay";
            payModel.titleString = @"钱包支付";
            payModel.isSelected = YES;
        }else{
            payModel.imageString = @"qiyezhanghaopay";
            payModel.titleString = @"企业账号支付";
            payModel.isSelected = NO;
        }
        
        [_dataArray addObject:payModel];
    }
    
    [self setupTable];
}

- (void)setupTable{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[PayWaySelectTableViewCell class] forCellReuseIdentifier:@"cell1"];
    [self.view addSubview:_tableView];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 80)];
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.frame = CGRectMake(30, 40, kScreenW-60, 40);
    [_payBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    _payBtn.backgroundColor = [UIColor colorWithRed:30/255.f green:150/255.f blue:230/255.f alpha:1.f];
    _payBtn.layer.masksToBounds = YES;
    _payBtn.layer.cornerRadius = 5;
    [_payBtn addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:_payBtn];

    _tableView.tableFooterView = footer;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        PayWaySelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.payModel = _dataArray[indexPath.row];
        __weak typeof(self) weakSelf = self;
        cell.ReloadBlock = ^{
            [weakSelf.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                PayWayModel *payModel = obj;
                payModel.isSelected = !payModel.isSelected;
            }];
            [weakSelf.tableView reloadData];
        };
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"类型: %@",_model.type];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"数量: %@",_model.amount];
            break;
            
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"下单时间: %@",_model.createdAt];
            break;
            
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"交货日期: %@",_model.deadline];
            break;
            
        case 4:
            cell.textLabel.text = [NSString stringWithFormat:@"担保金额: %@",_model.creditMoney];
            break;
            
        case 5:
            cell.textLabel.text = [NSString stringWithFormat:@"首款金额: %@",_model.fistPayCount];
            break;

        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        UIView *headerOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 25)];
        UIImageView *images = [[UIImageView alloc] initWithFrame:CGRectMake(15, 2.5, 20, 20)];
        images.image = [UIImage imageNamed:@"dingdanfuben"];
        [headerOne addSubview:images];
        
        UILabel *lb =[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 60, 25)];
        lb.text = @"订单信息";
        lb.font = [UIFont systemFontOfSize:12];
        [headerOne addSubview:lb];
        
        UILabel *numLB = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-140, 0, 120, 25)];
        numLB.textAlignment = NSTextAlignmentRight;
        numLB.font = [UIFont systemFontOfSize:12];
        numLB.text = [NSString stringWithFormat:@"订单编号:%@",_model.ID];
        [headerOne addSubview:numLB];
        return headerOne;
    }
    
    UIView *headerTwo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 25)];
    
    UILabel *lb =[[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 25)];
    lb.text = @"请选择一种支付方式";
    lb.font = [UIFont systemFontOfSize:12];
    [headerTwo addSubview:lb];

    return headerTwo;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return 40;
    }
    return 30;
}

- (void)payClick{
    [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PayWayModel *payModel = obj;
        if ([payModel.titleString isEqualToString:@"钱包支付"] && payModel.isSelected == YES) {
            _payWayString = @"wallet";
        }else if ([payModel.titleString isEqualToString:@"企业账号支付"] && payModel.isSelected == YES){
            _payWayString = @"enterprise";
        }
    }];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"该订单的首款为%@,确认支付首款?",_model.fistPayCount] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 200;
    [alert show];
    
    DLog(@"-----%@-----%@",_model.fistPayCount,_payWayString);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 200) {
        if (buttonIndex == 1) {
            [HttpClient payFirstWithOrderID:_model.ID payWay:_payWayString WithCompletionBlock:^(NSDictionary *dictionary){
                NSString *statusCode = dictionary[@"statusCode"];
                DLog(@"---------statuscode%@------------",statusCode);
                if ([statusCode isEqualToString:@"200"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"首笔付款成功" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
                    alert.tag = 100;
                    [alert show];
                    kTipAlert(@"首笔付款成功");
                }else if ([statusCode isEqualToString:@"402"]){
                    kTipAlert(@"余额不够,请充值");
                }else if ([statusCode isEqualToString:@"409"]){
                    kTipAlert(@"首款已付,余款支付请自行联系加工厂!");
                }
            }];

        }
    }else if (alertView.tag == 100){
        if (buttonIndex == 0) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

@end
