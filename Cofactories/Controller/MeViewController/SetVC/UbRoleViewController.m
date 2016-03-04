//
//  UbRoleViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//
#import "Tools.h"
#import "HttpClient.h"
#import "UbRoleViewController.h"

#define PROVINCE_COMPONENT  0

static NSString * CellIdentifier = @"CellIdentifier";

@interface UbRoleViewController () <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UIPickerView *orderPicker;
@property (nonatomic,strong) UIToolbar    *pickerToolbar;

@end

@implementation UbRoleViewController {
    UILabel * label;
    UITextField * textField;
//    NSString *_tmpPickerName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"二级身份";
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.rowHeight = 40;

    
    label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreenW-40, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"二级身份:";
    label.font = kFont;
    
    textField =[[UITextField alloc]initWithFrame:CGRectMake(20, 0, kScreenW-40, 40)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.font = kFont;
    textField.text = self.placeholder;
    textField.clearButtonMode = YES;
    textField.placeholder = @"选择二级身份";
    textField.inputView = [self fecthPicker];
    textField.inputAccessoryView = [self fecthToolbar];
    textField.delegate =self;
    
    //设置Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.rightBarButtonItem = setButton;
}

- (void)buttonClicked{
    if ([textField.text isEqualToString:@""]) {
        kTipAlert(@"二级身份不能为空！");
    }else{
        MBProgressHUD *hud = [Tools createHUD];
        hud.labelText = @"正在修改!";
        
        NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc]initWithCapacity:1];
        [parametersDic setObject:textField.text forKey:@"subRole"];
        
        [HttpClient postMyProfileWithDic:parametersDic andBlock:^(NSInteger statusCode) {
            if (statusCode == 200) {
                hud.labelText = @"修改成功!";
                [hud hide:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [hud hide:YES];
                kTipAlert(@"修改失败!");
            }
        }];
    }
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        [cell addSubview:textField];
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * viewForHeaderInSection = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
    
    if (section == 0) {
        [viewForHeaderInSection addSubview:label];
    }
    return viewForHeaderInSection;
}

- (UIPickerView *)fecthPicker{
    if (!self.orderPicker) {
        self.orderPicker = [[UIPickerView alloc] init];
        self.orderPicker.delegate = self;
        self.orderPicker.dataSource = self;
        self.orderPicker.backgroundColor = [UIColor whiteColor];
        [self.orderPicker selectRow:0 inComponent:0 animated:NO];
    }
    return self.orderPicker;
}

- (UIToolbar *)fecthToolbar{
    
    if (!self.pickerToolbar) {
        self.pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ensure)];
        self.pickerToolbar.items = [NSArray arrayWithObjects:left,space,right,nil];
    }
    return self.pickerToolbar;
}
#pragma mark - UIPickerView datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.cellPickList.count;
}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.cellPickList objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenW, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text = [self.cellPickList objectAtIndex:row];
    myView.font = kFont;
    myView.backgroundColor = [UIColor clearColor];
    return myView;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    textField.text = [self pickerView:pickerView titleForRow:row forComponent:component];
//    textField.text = _tmpPickerName;

}
-(void)ensure{
    
    NSInteger provinceIndex = [self.orderPicker selectedRowInComponent: PROVINCE_COMPONENT];
    textField.text = [self.cellPickList objectAtIndex: provinceIndex];
//    textField.text = _tmpPickerName;
//    _tmpPickerName = nil;
    [textField endEditing:YES];
}
-(void)cancel{
    
//    _tmpPickerName = nil;
    [textField endEditing:YES];
}


@end
