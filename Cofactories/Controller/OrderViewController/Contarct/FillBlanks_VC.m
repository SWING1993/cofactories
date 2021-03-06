//
//  FillBlanks_VC.m
//  Cofactories
//
//  Created by GTF on 16/1/12.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "FillBlanks_VC.h"
#import "BlankFirst_TVC.h"
#import "BlankSecond_TVC.h"
#import "BlankThird_TVC.h"
#import "BlankFourth_TVC.h"
#import "CalendarHomeViewController.h"
#import "Contract_VC.h"

@interface FillBlanks_VC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,SignContractDelgate>{
    NSString *_name;
    NSString *_amount;
    NSString *_fee;
    NSString *_address;
    NSString *_payStartFee;
    NSString *_payEndDay;
    NSString *_delivery;
    NSString *_carriage;
    
}

@property (nonatomic,strong)UITableView  *tableView;
@property (nonatomic,copy)NSArray        *titleStringArray;
@property (nonatomic,copy)NSArray        *placeHolderArray;
@property (nonatomic,copy)NSArray        *dateArray;
@property (nonatomic,strong)NSMutableArray      *containerOne;
@property (nonatomic,strong)NSMutableArray      *containerTwo;
@property (nonatomic,strong)CalendarHomeViewController *calendar;
@property (nonatomic,strong)NSData       *imageData;
@property (nonatomic,copy)NSString *deadline;
@property (nonatomic,copy)NSString *payStartDate;
@property (nonatomic,copy)NSString *payEndDate;

@end
static NSString *const reuseIdentifier1 = @"reuseIdentifier1";
static NSString *const reuseIdentifier2 = @"reuseIdentifier2";
static NSString *const reuseIdentifier3 = @"reuseIdentifier3";
static NSString *const reuseIdentifier4 = @"reuseIdentifier4";

@implementation FillBlanks_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"担保协议";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(signConfirmClick)];
    _titleStringArray = @[@"品名",@"总数量(件)",@"总价(元)"];
    _placeHolderArray = @[@"请填写加工品名",@"请填写加工数量",@"请填写加工费用"];
    _dateArray = @[@"交货期限",@"首款期限",@"尾款期限"];
    _deadline = [NSString stringWithFormat:@"请点击选择%@",_dateArray[0]];
    _payStartDate = [NSString stringWithFormat:@"请点击选择%@",_dateArray[1]];
    _payEndDate = [NSString stringWithFormat:@"请点击选择%@",_dateArray[2]];
    _containerOne = [@[] mutableCopy];
    _containerTwo = [@[] mutableCopy];
    
    [self initTable];
}

- (void)initTable{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[BlankFirst_TVC class] forCellReuseIdentifier:reuseIdentifier1];
    [_tableView registerClass:[BlankSecond_TVC class] forCellReuseIdentifier:reuseIdentifier2];
    [_tableView registerClass:[BlankThird_TVC class] forCellReuseIdentifier:reuseIdentifier3];
    [_tableView registerClass:[BlankFourth_TVC class] forCellReuseIdentifier:reuseIdentifier4];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 8;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        BlankFirst_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1 forIndexPath:indexPath];
        
        [cell loadWithIndexPath:indexPath titleString:_titleStringArray[indexPath.row] placeHolderString:_placeHolderArray[indexPath.row]];
        switch (indexPath.row) {
            case 0:
                _name = cell.dataTF.text;
                break;
            case 1:
                _amount = cell.dataTF.text;
                break;
            case 2:
                _fee = cell.dataTF.text;
                break;
                
            default:
                break;
        }
        return cell;
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:{
                BlankSecond_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier2 forIndexPath:indexPath];
                [cell loadDataWithIndexpath:indexPath titleString:@"交货方式" selectArray:@[@"一次性交货",@"分批交货"]];
                return cell;
            }
                break;
            case 2:{
                BlankFirst_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1 forIndexPath:indexPath];
                [cell loadWithIndexPath:indexPath titleString:@"交货地点" placeHolderString:@"请填写详细的收货地址"];
                _address = cell.dataTF.text;
                return cell;
            }
                
                break;
            case 4:{
                BlankFirst_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1 forIndexPath:indexPath];
                [cell loadWithIndexPath:indexPath titleString:@"首款金额" placeHolderString:@"请填写首款金额"];
                _payStartFee = cell.dataTF.text;
                return cell;
            }
                break;
            case 5:{
                BlankFirst_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1 forIndexPath:indexPath];
                [cell loadWithIndexPath:indexPath titleString:@"完工付款期限(天)" placeHolderString:@"请填写完工付款期限"];
                _payEndDay = cell.dataTF.text;
                return cell;
            }
                break;
            case 7:{
                BlankFourth_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier4  forIndexPath:indexPath];
                [cell loadDataWithIndexpath:indexPath titleString:@"运费承担方" selectArray:@[@"甲方",@"乙方"]];
                return cell;
            }
                break;
            default:{
                BlankThird_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier3 forIndexPath:indexPath];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (indexPath.row == 1) {
                    [cell loadDateWithIndexpath:indexPath titleString:_dateArray[0]];
                    cell.dateLB.text = _deadline;
                }else if (indexPath.row == 3){
                    [cell loadDateWithIndexpath:indexPath titleString:_dateArray[1]];
                    cell.dateLB.text = _payStartDate;
                }else{
                    [cell loadDateWithIndexpath:indexPath titleString:_dateArray[2]];
                    cell.dateLB.text = _payEndDate;
                }
                return cell;
            }
                break;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 1:{
                if (!_calendar) {
                    _calendar = [[CalendarHomeViewController alloc]init];
                    _calendar.calendartitle = @"空闲日期";
                    [_calendar setAirPlaneToDay:365 ToDateforString:nil];//飞机初始化方法
                }
                __weak typeof(self) weakSelf = self;
                _calendar.calendarblock = ^(CalendarDayModel *model){
                    weakSelf.deadline = [model toString];
                    [weakSelf.tableView reloadData];
                };
                [self presentViewController:_calendar animated:YES completion:nil];
            }
                break;
            case 3:{
                if (!_calendar) {
                    _calendar = [[CalendarHomeViewController alloc]init];
                    _calendar.calendartitle = @"空闲日期";
                    [_calendar setAirPlaneToDay:365 ToDateforString:nil];//飞机初始化方法
                }
                __weak typeof(self) weakSelf = self;
                _calendar.calendarblock = ^(CalendarDayModel *model){
                    weakSelf.payStartDate = [model toString];
                    [weakSelf.tableView reloadData];
                };
                [self presentViewController:_calendar animated:YES completion:nil];
            }
                break;
            case 6:{
                if (!_calendar) {
                    _calendar = [[CalendarHomeViewController alloc]init];
                    _calendar.calendartitle = @"空闲日期";
                    [_calendar setAirPlaneToDay:365 ToDateforString:nil];//飞机初始化方法
                }
                __weak typeof(self) weakSelf = self;
                _calendar.calendarblock = ^(CalendarDayModel *model){
                    weakSelf.payEndDate = [model toString];
                    [weakSelf.tableView reloadData];
                };
                [self presentViewController:_calendar animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 25;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 25)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenW-15, 25)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor grayColor];
    if (section == 0) {
        label.text = @"委托加工项目";
    }else{
        label.text = @"交货及付款";
    }
    [view addSubview:label];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 25)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenW-5, 25)];
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor grayColor];
        label.text = @"运输方式由双方自行约定,因材质问题需要返厂时往返运费由乙方承担";
        [view addSubview:label];
        
        return view;
        
    }
    return nil;
}

- (void)signConfirmClick{
    
    _delivery = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndexOne"];
    _carriage = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndexTwo"];
    
    DLog("%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",_name,_amount,_fee,_delivery,_deadline,_address,_payStartDate,_payStartFee,_payEndDay,_payEndDate,_carriage);
    
    if (_name.length == 0 || _amount.length == 0 || _fee.length == 0 || [_deadline isEqualToString:@"请点击选择交货期限"] || _address.length == 0 || [_payStartDate isEqualToString:@"请点击选择首款期限"] || _payStartFee.length == 0 || _payEndDay.length == 0 || [_payStartDate isEqualToString:@"请点击选择尾款期限"]) {
        kTipAlert(@"请完善协议信息");
    }else{
        [HttpClient signContractWithName:_name fee:_fee amount:_amount delivery:_delivery deadline:_deadline address:_address carriage:_carriage payStartDate:_payStartDate payStartFee:_payStartFee payEndDate:_payEndDate payEndDay:_payEndDay orderID:_orderID preview:@"true" WithCompletionBlock:^(NSDictionary *dictionary) {
            if ([dictionary[@"statusCode"] isEqualToString:@"200"]) {
                _imageData = dictionary[@"message"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提交成功,确定信息无误后签署合同" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alert.tag = 100;
                [alert show];
            }else{
                kTipAlert(@"提交合同失败,请检查网络并重新提交");
            }
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            Contract_VC *vc = [[Contract_VC alloc] init];
            vc.orderID = _orderID;
            vc.imageData = _imageData;
            vc.isClothing = YES;
            vc.signContractDelegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)signContract{
    [HttpClient signContractWithName:_name fee:_fee amount:_amount delivery:_delivery deadline:_deadline address:_address carriage:_carriage payStartDate:_payStartDate payStartFee:_payStartFee payEndDate:_payEndDate payEndDay:_payEndDay orderID:_orderID preview:@"false" WithCompletionBlock:^(NSDictionary *dictionary) {
    }];

}
@end
