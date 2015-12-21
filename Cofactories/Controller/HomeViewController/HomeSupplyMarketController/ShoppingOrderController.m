//
//  ShoppingOrderController.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/9.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "ShoppingOrderController.h"
#import "AuthenticationCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "AlipayHeader.h"
#import "MeHistoryOrderList_VC.h"
#import "MeOrderSelect_VC.h"
#import "FabricMarketModel.h"


#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

static NSString *OrderCellIdentifier = @"OrderCell";
@interface ShoppingOrderController ()<UIPickerViewDataSource,UIPickerViewDelegate, UIAlertViewDelegate> {
    UITextField *personNameTF, *phoneNumberTF, *youBianTF, *addressTF, *detailAddressTF;
    NSArray *titleArray;
    UIButton *lastButton;
    UIImageView *imageView1, *imageView2;
    NSString *selectPayStyle;
//    BOOL _wasKeyboardManagerEnabled;
}
@property (nonatomic,strong) UIPickerView *addressPicker;
@property (nonatomic,strong) UIToolbar *addressToolbar;
@property (nonatomic,retain)UserModel * MyProfile;

@end

@implementation ShoppingOrderController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
    self.MyProfile = [[UserModel alloc]getMyProfile];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"确认订单";
    
    self.tableView.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0];
    [self.tableView registerClass:[AuthenticationCell class] forCellReuseIdentifier:OrderCellIdentifier];
    titleArray = @[@"收货人", @"电话", @"邮编", @"省市区", @"详细地址"];
    selectPayStyle = @"账户余额";
    
    [self creatTableViewFooter];
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"Areas" ofType:@"plist"];
    areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    province = [[NSArray alloc] initWithArray: provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    
    NSString *selectedCity = [city objectAtIndex: 0];
    district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
    

    DLog(@"^^^^^^^^^^^^^^^%@", self.goodsDic);
}

- (void)creatTableViewFooter {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 300)];
    footerView.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0];
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenW - 40, 50)];
    myLabel.text = @"请选择付款方式：";
    myLabel.textColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
    myLabel.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:myLabel];
    UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(myLabel.frame), kScreenW, 100)];
    bigView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:bigView];
    
    imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - 45, 12.5, 25, 25)];
    imageView1.image = [UIImage imageNamed:@"ShopCarIsSelect"];
    [bigView addSubview:imageView1];
    imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - 45, 62.5, 25, 25)];
    imageView2.image = [UIImage imageNamed:@"ShopCarNoSelect"];
    [bigView addSubview:imageView2];
    
    NSArray *titleArray1 = @[@"账户余额", @"支付宝"];
    for (int i = 0; i < 2; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, i*50, kScreenW - 40, 50)];
        label.font = [UIFont systemFontOfSize:14];
        label.text = titleArray1[i];
        [bigView addSubview:label];
        UIButton *mybutton = [UIButton buttonWithType:UIButtonTypeCustom];
        mybutton.frame = CGRectMake(0, i*50, kScreenW, 50);
        mybutton.tag = 222 + i;
        mybutton.selected = NO;
        [mybutton addTarget:self action:@selector(actionOfSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [bigView addSubview:mybutton];
    }
    
    lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lastButton.frame = CGRectMake(20, 220, kScreenW - 40, 38);
    [lastButton setTitle:@"提交订单" forState:UIControlStateNormal];
    lastButton.titleLabel.font = [UIFont systemFontOfSize:15.5];
    lastButton.layer.cornerRadius = 4;
    lastButton.clipsToBounds = YES;
    lastButton.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:171.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
    [lastButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lastButton addTarget:self action:@selector(actionOfShoppingOrder:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:lastButton];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreenW, 0.3)];
    lineView.backgroundColor = kLineGrayCorlor;
    [bigView addSubview:lineView];
    self.tableView.tableFooterView = footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AuthenticationCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.myLabel.text = titleArray[indexPath.row];
    cell.myTextField.textAlignment = NSTextAlignmentLeft;
    switch (indexPath.row) {
        case 0: {
            personNameTF = cell.myTextField;
        }
            break;
        case 1: {
            phoneNumberTF = cell.myTextField;
            phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case 2: {
            youBianTF = cell.myTextField;
            youBianTF.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case 3: {
            addressTF = cell.myTextField;
            addressTF.placeholder = @"省份|城市|地区|街道";
            addressTF.inputView = [self fecthAddressPicker];
            addressTF.inputAccessoryView = [self fecthAddressToolbar];
        }
        case 4: {
            detailAddressTF = cell.myTextField;
        }
            break;
        default:
            break;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


#pragma mark - Action
- (void)actionOfShoppingOrder:(UIButton *)button {
    DLog(@"提交订单^^^%@", selectPayStyle);
    //personNameTF, *phoneNumberTF, *youBianTF, *addressTF, *detailAddressTF
    if (personNameTF.text.length == 0 || phoneNumberTF.text.length == 0 || youBianTF.text.length == 0 || addressTF.text.length == 0 || detailAddressTF.text.length == 0) {
        DLog(@"信息不完整");
    } else {
        
        DLog(@"信息已完整");
        [HttpClient getFabricDetailWithId:self.goodsID WithCompletionBlock:^(NSDictionary *dictionary) {
            int statusCode = [dictionary[@"statusCode"] intValue];
            if (statusCode == 200) {
                FabricMarketModel *marketDetailModel = (FabricMarketModel *)dictionary[@"model"];
                if ([marketDetailModel.amount integerValue] < self.goodsNumber) {
                    kTipAlert(@"库存不够！订单生成失败！");
                } else {
                    NSInteger provinceIndex = [self.addressPicker selectedRowInComponent: PROVINCE_COMPONENT];
                    NSInteger cityIndex = [self.addressPicker selectedRowInComponent: CITY_COMPONENT];
                    NSInteger districtIndex = [self.addressPicker selectedRowInComponent: DISTRICT_COMPONENT];
                    
                    NSString *provinceStr = [province objectAtIndex: provinceIndex];
                    NSString *cityStr = [city objectAtIndex: cityIndex];
                    NSString *districtStr = [district objectAtIndex:districtIndex];
                    
                    DLog(@"provinceStr == %@,cityStr == %@,districtStr == %@",provinceStr,cityStr,districtStr);
                    
                    NSDictionary *addressDic = @{@"province":provinceStr, @"city":cityStr, @"district":districtStr, @"address":detailAddressTF.text, @"name":personNameTF.text, @"phone":phoneNumberTF.text, @"post":youBianTF.text};
                    [self.goodsDic setObject:addressDic forKey:@"address"];
                    
                    if ([selectPayStyle isEqualToString:@"账户余额"]) {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定付款" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        alert.tag = 222;
                        [alert show];
                    }
                    if ([selectPayStyle isEqualToString:@"支付宝"]) {
                        DLog(@"^^^^^^^^^^^^^^^^^^^^^");
                        [self.goodsDic setObject:@"alipay" forKey:@"payment"];
                        DLog(@"^^^^^^^^^^^^^^^%@", self.goodsDic);
                        NSData *myData = [self DataTOjsonString:self.goodsDic];
                        [HttpClient buyGoodsWithDictionary:myData WithBlock:^(NSDictionary *dictionary) {
                            NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
                            switch (statusCode) {
                                case 200: {
                                    DLog(@"#######%@", dictionary[@"statusCode"]);
                                    DLog(@"#############%@", dictionary[@"responseObject"]);
                                    
                                    NSString *tradeNO = dictionary[@"responseObject"][@"out_trade_no"];
                                    NSString *descriptionStr = dictionary[@"responseObject"][@"body"];
                                    NSString *subject = dictionary[@"responseObject"][@"subject"];
                                    NSString *amountStr = [NSString stringWithFormat:@"%@", dictionary[@"responseObject"][@"fee"]];
                                    DLog(@"amountPrice = %@", amountStr);
                                    if (tradeNO && descriptionStr && subject) {
                                        [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:tradeNO productName:subject productDescription:descriptionStr amount:amountStr notifyURL:kNotifyURL itBPay:@"30m"];
                                    } else {
                                        kTipAlert(@"生成订单信息失败");
                                    }
                                }
                                    break;
                                case 402:
                                    kTipAlert(@"付款失败，钱包余额不足，请去充值");
                                    break;
                                case 403:
                                    kTipAlert(@"付款失败，不能购买自己的商品");
                                    break;
                                case 404:
                                    kTipAlert(@"付款失败，该商品可能已下架或无货");
                                    break;
                                case 405:
                                    kTipAlert(@"付款失败，不能跨店铺购买");
                                    break;
                                case 401:
                                    kTipAlert(@"付款失败，请重新登录");
                                    break;
                                default:
                                    break;
                            }
                            
                        }];
                        
                    }
                }
            }

        }];
        
        
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 222) {
        if (buttonIndex == 1) {
            DLog(@"去付款");
            [self.goodsDic setObject:@"wallet" forKey:@"payment"];
            NSData *myData = [self DataTOjsonString:self.goodsDic];
            DLog(@"^^^^^^^^^^^^^^^%@", self.goodsDic);
            [HttpClient buyGoodsWithDictionary:myData WithBlock:^(NSDictionary *dictionary) {
                NSInteger statusCode = [dictionary[@"statusCode"] integerValue];
                switch (statusCode) {
                    case 200: {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"购买成功，是否查看订单" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                        alert.tag = 223;
                        [alert show];
                    }
                        break;
                    case 402:
                        kTipAlert(@"付款失败，钱包余额不足，请去充值");
                        break;
                    case 403:
                        kTipAlert(@"付款失败，不能购买自己的商品");
                        break;
                    case 404:
                        kTipAlert(@"付款失败，该商品可能已下架或无货");
                        break;
                    case 405:
                        kTipAlert(@"付款失败，不能跨店铺购买");
                        break;
                    case 401:
                        kTipAlert(@"付款失败，请重新登录");
                        break;
                    default:
                        break;
                }
            }];
        }
    } else if (alertView.tag == 223) {
        if (buttonIndex == 1) {
            if (self.MyProfile.UserType == UserType_designer || self.MyProfile.UserType == UserType_supplier) {
                MeOrderSelect_VC *meOrder_VC = [[MeOrderSelect_VC alloc] init];
                meOrder_VC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:meOrder_VC animated:YES];
            } else {
                MeHistoryOrderList_VC *historyVC = [[MeHistoryOrderList_VC alloc] init];
                historyVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:historyVC animated:YES];
            }

        }
    }
}


- (void)actionOfSelectButton:(UIButton *)btn {
    
    if (btn.tag == 222) {
        imageView1.image = [UIImage imageNamed:@"ShopCarIsSelect"];
        imageView2.image = [UIImage imageNamed:@"ShopCarNoSelect"];
        selectPayStyle = @"账户余额";
    }
    if (btn.tag == 223) {
        imageView1.image = [UIImage imageNamed:@"ShopCarNoSelect"];
        imageView2.image = [UIImage imageNamed:@"ShopCarIsSelect"];
        selectPayStyle = @"支付宝";
    }

}




//sizePicker
- (UIPickerView *)fecthAddressPicker{
    if (!self.addressPicker) {
        self.addressPicker = [[UIPickerView alloc] init];
        self.addressPicker.backgroundColor = [UIColor whiteColor];
        self.addressPicker.delegate = self;
        self.addressPicker.dataSource = self;
        [self.addressPicker selectRow:0 inComponent:0 animated:NO];
    }
    return self.addressPicker;
}
- (UIToolbar *)fecthAddressToolbar{
    if (!self.addressToolbar) {
        self.addressToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(addressCancel)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(addressEnsure)];
        self.addressToolbar.items = [NSArray arrayWithObjects:left,space,right,nil];
    }
    return self.addressToolbar;
}

-(void)addressCancel{
    
    addressString = nil;
    addressTF.text = nil;
    [addressTF endEditing:YES];
}

-(void)addressEnsure{
    
    NSInteger provinceIndex = [self.addressPicker selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [self.addressPicker selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [self.addressPicker selectedRowInComponent: DISTRICT_COMPONENT];
    
    NSString *provinceStr = [province objectAtIndex: provinceIndex];
    NSString *cityStr = [city objectAtIndex: cityIndex];
    NSString *districtStr = [district objectAtIndex:districtIndex];
    
    
    addressString = [NSString stringWithFormat: @"%@%@%@", provinceStr, cityStr, districtStr];
    addressTF.text = addressString;
    addressString = nil;
    [addressTF endEditing:YES];
}



#pragma mark - UIPickerView datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == PROVINCE_COMPONENT) {
        return [province count];
    }
    else if (component == CITY_COMPONENT) {
        return [city count];
    }
    else {
        return [district count];
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province objectAtIndex: row];
    }
    else if (component == CITY_COMPONENT) {
        return [city objectAtIndex: row];
    }
    else {
        return [district objectAtIndex: row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    DLog(@"- (void)pickerView:(UIPickerView *)");
    
    if (component == PROVINCE_COMPONENT) {
        selectedProvince = [province objectAtIndex: row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%ld", (long)row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        city = [[NSArray alloc] initWithArray: array];
        NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [city objectAtIndex: 0]]];
        [self.addressPicker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [self.addressPicker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [self.addressPicker reloadComponent: CITY_COMPONENT];
        [self.addressPicker reloadComponent: DISTRICT_COMPONENT];
        
    }
    else if (component == CITY_COMPONENT) {
        NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[province indexOfObject: selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
        [self.addressPicker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [self.addressPicker reloadComponent: DISTRICT_COMPONENT];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return 80;
    }
    else if (component == CITY_COMPONENT) {
        return 100;
    }
    else {
        return 115;
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [province objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [city objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [district objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    return myView;
    
}


-(NSData*)DataTOjsonString:(id)object
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    }
    return jsonData;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
