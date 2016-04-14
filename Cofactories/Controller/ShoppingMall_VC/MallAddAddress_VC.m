//
//  MallAddAddress_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/1/28.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallAddAddress_VC.h"
#import "AddressTextFieldCell.h"
#import "PlaceholderTextView.h"
#import "MallAddressModel.h"
#import "ShoppingMallDetail_VC.h"

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

static NSString *addCellIdentifier = @"addCell";
static NSString * CellIdentifier = @"CellIdentifier";
@interface MallAddAddress_VC ()<UIPickerViewDataSource,UIPickerViewDelegate, UIAlertViewDelegate> {
    UIPickerView *picker;
    UIButton *button;
    
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    NSString *addressString;
    NSString *selectedProvince;
    
    NSArray *placeHolderArray;
    UITextField *personNameTF, *phoneNumberTF, *postNumberTF, *addressTF;
    PlaceholderTextView *detailAddressTV;
    
}
@property (nonatomic,strong) UIPickerView *addressPicker;
@property (nonatomic,strong) UIToolbar *addressToolbar;
@end

@implementation MallAddAddress_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"新建收货地址";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"navigator_btn_back"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    placeHolderArray = @[@"收货人姓名", @"手机号码", @"邮政编码", @"省、市、区"];
    [self.tableView registerClass:[AddressTextFieldCell class] forCellReuseIdentifier:addCellIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    [self creatTableViewFooterView];
    
    detailAddressTV = [[PlaceholderTextView alloc] initWithFrame:CGRectMake(5*kZGY, 8*kZGY, kScreenW - 10*kZGY, 100*kZGY)];
    detailAddressTV.placeholder = @"详细地址";
    detailAddressTV.placeholderFont = [UIFont systemFontOfSize:14];
    
    
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
    for (int i = 0; i < sortedArray.count; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    province = [[NSArray alloc] initWithArray: provinceTmp];
    
    NSString *index = sortedArray[0];
    NSString *selected = province[0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: areaDic[index][selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: dic[cityArray[0]]];
    city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    NSString *selectedCity = [city objectAtIndex: 0];
    district = [[NSArray alloc] initWithArray: cityDic[selectedCity]];
    selectedProvince = selected;
}

- (void)creatTableViewFooterView {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 250*kZGY)];
    
    UIButton *doneButton = [Tools buttonWithFrame:CGRectMake(20, 200*kZGY, kScreenW - 40, 38) withTitle:@"保存"];
    [doneButton addTarget:self action:@selector(actionOfDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:doneButton];
    
    self.tableView.tableFooterView = footerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AddressTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:addCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.myTextField.placeholder = placeHolderArray[indexPath.row];
        switch (indexPath.row) {
            case 0:
                personNameTF = cell.myTextField;
                break;
            case 1:
                phoneNumberTF = cell.myTextField;
                phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;
                break;
            case 2:
                postNumberTF = cell.myTextField;
                postNumberTF.keyboardType = UIKeyboardTypeNumberPad;
                break;
            case 3:
                addressTF = cell.myTextField;
                addressTF.clearButtonMode = UITextFieldViewModeNever;
                addressTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"省、市、区" attributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
                addressTF.inputView = [self fecthAddressPicker];
                addressTF.inputAccessoryView = [self fecthAddressToolbar];
                break;
            default:
                break;
        }

        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:detailAddressTV];
        return cell;
    }
    
    
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50*kZGY;
    }
    return 116*kZGY;
}

- (CGFloat)tableView:( UITableView *)tableView heightForHeaderInSection:( NSInteger )section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
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
    
    NSString *provinceStr = province[provinceIndex];
    NSString *cityStr = city[cityIndex];
    NSString *districtStr = district[districtIndex];
    
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
        return province.count;
    }
    else if (component == CITY_COMPONENT) {
        return city.count;
    }
    else {
        return district.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == PROVINCE_COMPONENT) {
        return province[row];
    }
    else if (component == CITY_COMPONENT) {
        return city[row];
    }
    else {
        return district[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    DLog(@"- (void)pickerView:(UIPickerView *)");
    if (component == PROVINCE_COMPONENT) {
        selectedProvince = [province objectAtIndex: row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: areaDic[[NSString stringWithFormat:@"%ld", (long)row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: tmp[selectedProvince]];
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
        for (int i = 0; i < sortedArray.count; i++) {
            NSString *index = sortedArray[i];
            NSArray *temp = [dic[index] allKeys];
            [array addObject: temp[0]];
        }
        city = [[NSArray alloc] initWithArray: array];
        NSDictionary *cityDic = dic[sortedArray[0]];
        district = [[NSArray alloc] initWithArray: cityDic[city[0]]];
        [self.addressPicker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [self.addressPicker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
        [self.addressPicker reloadComponent: CITY_COMPONENT];
        [self.addressPicker reloadComponent: DISTRICT_COMPONENT];
        
    }
    else if (component == CITY_COMPONENT) {
        
        NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[province indexOfObject: selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: areaDic[provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: tmp[selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            } else if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            } else {
               return (NSComparisonResult)NSOrderedSame;
            }
        }];
            NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: dic[sortedArray[row]]];
            NSArray *cityKeyArray = [cityDic allKeys];
            district = [[NSArray alloc] initWithArray: cityDic[cityKeyArray[0]]];
            [self.addressPicker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
            [self.addressPicker reloadComponent: DISTRICT_COMPONENT];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
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

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
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

- (void)actionOfDoneButton:(UIButton *)button {
    [button addShakeAnimation];
    if ([Tools isBlankString:personNameTF.text] == YES || [Tools isBlankString:phoneNumberTF.text] == YES ||[Tools isBlankString:postNumberTF.text] == YES || addressTF.text.length == 0 ||[Tools isBlankString:detailAddressTV.text] == YES) {
        kTipAlert(@"信息填写不完整");
    } else {
        NSInteger provinceIndex = [self.addressPicker selectedRowInComponent: PROVINCE_COMPONENT];
        NSInteger cityIndex = [self.addressPicker selectedRowInComponent: CITY_COMPONENT];
        NSInteger districtIndex = [self.addressPicker selectedRowInComponent: DISTRICT_COMPONENT];
        
        NSString *provinceStr = [province objectAtIndex: provinceIndex];
        NSString *cityStr = [city objectAtIndex: cityIndex];
        NSString *districtStr = [district objectAtIndex:districtIndex];
        DLog(@"存储收货地址");
        MallAddressModel *addressModel = [[MallAddressModel alloc] init];
        addressModel.personName = personNameTF.text;
        addressModel.phoneNumber = phoneNumberTF.text;
        addressModel.postNumber = postNumberTF.text;
        addressModel.province = provinceStr;
        addressModel.city = cityStr;
        addressModel.district = districtStr;
        addressModel.detailAddress = detailAddressTV.text;
        
        UserModel * MyProfile = [[UserModel alloc]getMyProfile];
        NSString *storeKey = [NSString stringWithFormat:@"mallAddressArray%@", MyProfile.uid];
        //获取已经存储的数据
        NSMutableArray *addressArray = [NSMutableArray arrayWithCapacity:0];
        if ([[[StoreUserValue sharedInstance] valueWithKey:storeKey] count] > 0) {
            addressArray = [[StoreUserValue sharedInstance] valueWithKey:storeKey];
        }
        [addressArray addObject:addressModel];
        [[StoreUserValue sharedInstance] storeValue:addressArray withKey:storeKey];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)back {
    if (self.haveAddress) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[ShoppingMallDetail_VC class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}



@end
