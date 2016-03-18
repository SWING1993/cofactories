//
//  SelectAddress_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/1/26.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallSelectAddress_VC.h"
#import "MallAddressCell.h"
#import "MallAddAddress_VC.h"
#import "MallAddressModel.h"
#import "MallOrderPay_VC.h"

static NSString *addressCellIdentifier = @"addressCell";
@interface MallSelectAddress_VC ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *addressArray;
@end

@implementation MallSelectAddress_VC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DLog(@"mallOrderDic=%@", self.mallOrderDic);
    UserModel * MyProfile = [[UserModel alloc]getMyProfile];
    NSString *storeKey = [NSString stringWithFormat:@"mallAddressArray%@", MyProfile.uid];
    //获取已经存储的数据
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
    self.addressArray = [NSMutableArray arrayWithCapacity:0];
    if ([[[StoreUserValue sharedInstance] valueWithKey:storeKey] count] > 0) {
        dataArray = [[StoreUserValue sharedInstance] valueWithKey:storeKey];
        dataArray = (NSMutableArray *)[[dataArray reverseObjectEnumerator] allObjects];
        for (int i = 0; i < dataArray.count; i++) {
            MallAddressModel *addressModel = dataArray[i];
            if (i == 0) {
                addressModel.isSelect = YES;
            } else {
                addressModel.isSelect = NO;
            }
            [self.addressArray addObject:addressModel];
        }
        [self.tableView reloadData];

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有设置收货地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"确认订单";
    [self creatTableViewHeaderView];
    [self creatTableViewFooterView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MallAddressCell class] forCellReuseIdentifier:addressCellIdentifier];
    }

- (void)creatTableViewHeaderView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 25)];
//    headerView.backgroundColor = [UIColor redColor];
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenW - 20, 25)];
    addressLabel.text = @"请选择收货地址";
    addressLabel.font = [UIFont systemFontOfSize:12];
    addressLabel.textColor = GRAYCOLOR(135.0);
    [headerView addSubview:addressLabel];
    self.tableView.tableHeaderView = headerView;
}

- (void)creatTableViewFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 170)];
    
    UIButton *creatAddress = [UIButton buttonWithType:UIButtonTypeCustom];
    creatAddress.frame = CGRectMake(10, 0, 60, 30);
    [creatAddress setTitle:@"新增地址" forState:UIControlStateNormal];
    [creatAddress setTitleColor:[UIColor colorWithRed:238.0/255.0 green:136.0/255.0 blue:23.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    creatAddress.titleLabel.font = [UIFont systemFontOfSize:14];
    [creatAddress addTarget:self action:@selector(actionOfAddAddress:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:creatAddress];
    
    UIButton *doneButton = [Tools buttonWithFrame:CGRectMake(20, 100, kScreenW - 40, 38) withTitle:@"立即拍下"];
    [doneButton addTarget:self action:@selector(actionOfDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:doneButton];
    self.tableView.tableFooterView = footerView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MallAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MallAddressModel *addressModel = self.addressArray[indexPath.row];
    cell.personNameLabel.text = addressModel.personName;
    cell.phoneNumberLabel.text = addressModel.phoneNumber;
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@", addressModel.province, addressModel.city, addressModel.district, addressModel.detailAddress];
    cell.addressLabel.text = address;
    CGSize size = [Tools getSize:address andFontOfSize:12 andWidthMake:kScreenW - 20];
    cell.addressLabel.frame = CGRectMake(10, CGRectGetMaxY(cell.personNameLabel.frame), kScreenW - 20, size.height);
    if (addressModel.isSelect) {
        cell.backgroundColor = [UIColor colorWithRed:75/255.0 green:87/255.0 blue:115/255.0 alpha:1.0];
        cell.personNameLabel.textColor = [UIColor whiteColor];
        cell.phoneNumberLabel.textColor = [UIColor whiteColor];
        cell.addressLabel.textColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.personNameLabel.textColor = [UIColor blackColor];
        cell.phoneNumberLabel.textColor = [UIColor blackColor];
        cell.addressLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MallAddressModel *addressModel = self.addressArray[indexPath.row];
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@", addressModel.province, addressModel.city, addressModel.district, addressModel.detailAddress];
    CGSize size = [Tools getSize:address andFontOfSize:12 andWidthMake:kScreenW - 20];
    return size.height + 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MallAddressModel *addressModel = self.addressArray[indexPath.row];
    if (addressModel.isSelect) {
        
    } else {
        for (MallAddressModel *mallAddressModel in self.addressArray) {
            mallAddressModel.isSelect = NO;
        }
        addressModel.isSelect = YES;
    }
    [self.tableView reloadData];
}

#pragma mark - 新增地址
- (void)actionOfAddAddress:(UIButton *)button {
    DLog(@"新增地址");
    MallAddAddress_VC *addAddressVC = [[MallAddAddress_VC alloc] initWithStyle:UITableViewStyleGrouped];
    addAddressVC.haveAddress = YES;
    [self.navigationController pushViewController:addAddressVC animated:YES];
}

#pragma mark - 拍下订单
- (void)actionOfDoneButton:(UIButton *)button {
    button.userInteractionEnabled = NO;
    DLog(@"拍下订单");
    for (int i = 0; i < self.addressArray.count; i++) {
        MallAddressModel *addressModel = self.addressArray[i];
        if (addressModel.isSelect) {
            [self.addressArray removeObject:addressModel];
            [self.addressArray addObject:addressModel];
        }
    }
    UserModel * MyProfile = [[UserModel alloc]getMyProfile];
    NSString *storeKey = [NSString stringWithFormat:@"mallAddressArray%@", MyProfile.uid];
    [[StoreUserValue sharedInstance] storeValue:self.addressArray withKey:storeKey];
    
    MallAddressModel *addressModel = [self.addressArray lastObject];
    NSMutableDictionary *addressDic = [NSMutableDictionary dictionaryWithCapacity:7];
    [addressDic setObject:addressModel.province forKey:@"province"];
    [addressDic setObject:addressModel.city forKey:@"city"];
    [addressDic setObject:addressModel.district forKey:@"district"];
    [addressDic setObject:addressModel.detailAddress forKey:@"address"];
    [addressDic setObject:addressModel.personName forKey:@"name"];
    [addressDic setObject:addressModel.phoneNumber forKey:@"phone"];
    [addressDic setObject:addressModel.postNumber forKey:@"post"];
    
    [self.mallOrderDic setObject:addressDic forKey:@"address"];
    NSData *mallOrderData = [self DataTOjsonString:self.mallOrderDic];
    [HttpClient getMallOrderWithDictionary:mallOrderData withBlock:^(NSDictionary *dictionary) {
        NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
        switch (statusCode) {
            case 200: {
                button.userInteractionEnabled = YES;
                NSString *mallPurchseId = [NSString stringWithFormat:@"%@", dictionary[@"data"][@"purchaseId"]];
                MallOrderPay_VC *orderPayVC = [[MallOrderPay_VC alloc] initWithStyle:UITableViewStyleGrouped];
                orderPayVC.mallPurchseId = mallPurchseId;
                [self.navigationController pushViewController:orderPayVC animated:YES];
            }
                break;
            default:
                kTipAlert(@"%@(错误码：%ld)",[dictionary objectForKey:@"message"],(long)statusCode);
                button.userInteractionEnabled = YES;
                break;
        }
    }];
}

#pragma mark - 没有地址去填写
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        DLog(@"确定");
        MallAddAddress_VC *addAddressVC = [[MallAddAddress_VC alloc] initWithStyle:UITableViewStyleGrouped];
        addAddressVC.haveAddress = NO;
        [self.navigationController pushViewController:addAddressVC animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (NSData*)DataTOjsonString:(id)object {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    }
    return jsonData;
}

@end
