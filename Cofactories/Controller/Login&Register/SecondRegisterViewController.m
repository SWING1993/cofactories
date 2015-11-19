//
//  SecondRegisterViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/19.
//  Copyright © 2015年 宋国华. All rights reserved.
//
#define PROVINCE_COMPONENT  0

#import "Tools.h"
#import "blueButton.h"
#import "tablleHeaderView.h"
#import "SecondRegisterViewController.h"

@interface SecondRegisterViewController ()<UIAlertViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource> {

    UITextField*_factoryNameTF;//工厂名称
    UITextField*_typeTF;//公司类型
    NSString *_factoryType;
    int factoryTypeInt;
}

@property(nonatomic,retain) NSArray*factoryTypeList;
@property (nonatomic,strong) UIPickerView *factoryTypePicker;
@property (nonatomic,strong) UIToolbar*factoryTypeToolbar;

@end

@implementation SecondRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"注册";
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-64, kScreenH) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    tablleHeaderView*tableHeaderView = [[tablleHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, tableHeaderView_height)];
    self.tableView.tableHeaderView = tableHeaderView;
    
    UIView * tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
    
    blueButton*nextBtn=[[blueButton alloc]initWithFrame:CGRectMake(20, 15, kScreenW-40, 35)];;
    [nextBtn setTitle:@"注册" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:nextBtn];
    self.tableView.tableFooterView = tableFooterView;
    [self createUI];

    self.factoryTypeList=@[@"服装厂",@"加工厂",@"代裁厂",@"锁眼钉扣厂",@"面辅料商"];


}

- (void)createUI {
    if (!_factoryNameTF) {
        _factoryNameTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _factoryNameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _factoryNameTF.placeholder=@"工厂名称";
    }
    
    if (!_typeTF) {
        _typeTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _typeTF.placeholder=@"工厂类型";
        _typeTF.inputView = [self fecthPicker];
        _typeTF.inputAccessoryView = [self fecthToolbar];
        _typeTF.delegate =self;
        
    }
}

- (void)registerBtnClick {
    if (_typeTF.text.length==0 || _factoryNameTF.text.length==0 ) {
        [Tools showErrorWithStatus:@"注册信息不完整!"];
    }else{
    
    }
}
//注册成功 登录
- (void)login{
    /*
     [HttpClient loginWithUsername:_usernameTF.text password:_passwordTF.text andBlock:^(int statusCode) {
     DLog(@"%d",statusCode);
     switch (statusCode) {
     case 200:{
     [HttpClient getUserProfileWithBlock:^(NSDictionary *responseDictionary) {
     UserModel*userModel=responseDictionary[@"model"];
     [[NSUserDefaults standardUserDefaults] setInteger:userModel.factoryType forKey:@"factoryType"];
     
     if ([[NSUserDefaults standardUserDefaults] synchronize] == YES) {
     [ViewController goMain];
     }
     else{
     [Tools showErrorWithStatus:@"获取用户身份失败，请尝试重新登录！"];
     }
     }];
     }
     break;
     
     default:
     [Tools showErrorWithStatus:@"登录失败,尝试重新登录！"];
     break;
     }
     }];
     */
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10086) {
        [self login];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            [cell addSubview:_typeTF];
        }
        else if (indexPath.row == 1) {
            [cell addSubview:_factoryNameTF];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

#pragma mark - UIPickerView datasource

- (UIPickerView *)fecthPicker {
    if (!self.factoryTypePicker) {
        self.factoryTypePicker = [[UIPickerView alloc] init];
        self.factoryTypePicker.backgroundColor = [UIColor whiteColor];
        self.factoryTypePicker.delegate = self;
        self.factoryTypePicker.dataSource = self;
        [self.factoryTypePicker selectRow:0 inComponent:0 animated:NO];
    }
    return self.factoryTypePicker;
}

- (UIToolbar *)fecthToolbar {
    if (!self.factoryTypeToolbar) {
        self.factoryTypeToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ensure)];
        self.factoryTypeToolbar.items = [NSArray arrayWithObjects:left,space,right,nil];
    }
    return self.factoryTypeToolbar;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.factoryTypeList.count;
}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.factoryTypeList objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenW, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text = [self.factoryTypeList objectAtIndex:row];
    myView.font = kFont;
    myView.backgroundColor = [UIColor clearColor];
    return myView;
}


//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    _factoryName = [self pickerView:pickerView titleForRow:row forComponent:PROVINCE_COMPONENT];
//}

-(void)ensure{
    NSInteger provinceIndex = [self.factoryTypePicker selectedRowInComponent: PROVINCE_COMPONENT];
    _factoryType = [self.factoryTypeList objectAtIndex: provinceIndex];
    [Tools showShimmeringString:[NSString stringWithFormat:@"您选择的身份为%@",_factoryType]];
    switch (provinceIndex) {
        case 0:
            factoryTypeInt = 0;
            break;
        case 1:
            factoryTypeInt = 1;
            break;
        case 2:
            factoryTypeInt = 2;
            break;
        case 3:
            factoryTypeInt = 3;
            break;
        case 4:
            factoryTypeInt = 5;
            break;
            
        default:
            break;
    }
    
    _typeTF.text = _factoryType;
    _factoryType = nil;
    
    [_typeTF endEditing:YES];
    DLog(@"factoryTypeInt == %d",factoryTypeInt);
    
}
-(void)cancel{
    _factoryType = nil;
    _typeTF.text = nil;
    [_typeTF endEditing:YES];
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
