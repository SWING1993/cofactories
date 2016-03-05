//
//  SecondRegisterViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/19.
//  Copyright © 2015年 宋国华. All rights reserved.
//
#define PROVINCE_COMPONENT  0
#import "HttpClient.h"
#import "Tools.h"
#import "UserModel.h"
#import "LoginButton.h"
#import "LoginTableHeaderView.h"
#import "SecondRegisterViewController.h"
#import "RootViewController.h"
#import "Login.h"
static NSString * const CellIdentifier = @"CellIdentifier";

@interface SecondRegisterViewController ()<UIAlertViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource> {

    UITextField * _UserNameTF;//工厂名称
    UITextField * _UserTypeTF;//公司类型
    NSString    * _UserTypeString;
    NSInteger selectedInt;
}

@property(nonatomic,retain) NSArray*UserTypeList;
@property(nonatomic,retain) NSArray*UserTypeArray;

@property (nonatomic,strong) UIPickerView *UserTypePicker;
@property (nonatomic,strong) UIToolbar*UserTypeToolbar;

@end

@implementation SecondRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"注册";
   
    UserModel * model = [[UserModel alloc]initWithArray];
    self.UserTypeList = model.UserTypeListArray;
    self.UserTypeArray = model.UserTypeArray;
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    LoginTableHeaderView*tableHeaderView = [[LoginTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kLogintTableHeaderView_height)];
    self.tableView.tableHeaderView = tableHeaderView;
    UIView * tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
    LoginButton*nextBtn=[[LoginButton alloc]initWithFrame:CGRectMake(20, 15, kScreenW-40, 35)];;
    [nextBtn setTitle:@"注册" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:nextBtn];
    self.tableView.tableFooterView = tableFooterView;
    [self createUI];
    //设置Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"返回登录" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.rightBarButtonItem = setButton;
}

- (void)buttonClicked{
     NSArray * viewControllers = self.navigationController.viewControllers;
    [self.navigationController popToViewController:[viewControllers firstObject] animated:YES];
}


- (void)createUI {
    if (!_UserNameTF) {
        _UserNameTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _UserNameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _UserNameTF.placeholder=@"工厂名称";
    }
    
    if (!_UserTypeTF) {
        _UserTypeTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _UserTypeTF.placeholder=@"工厂类型";
        _UserTypeTF.inputView = [self fecthPicker];
        _UserTypeTF.inputAccessoryView = [self fecthToolbar];
        _UserTypeTF.delegate =self;
        
    }
}

- (void)registerBtnClick {
    if (_UserTypeTF.text.length==0 || _UserNameTF.text.length==0 ) {
        kTipAlert(@":( 注册信息不完整");
    }else{
        DLog(@"注册信息：Username:%@ password:%@ UserRole:%@ code:%@ UserName:%@",self.phone,self.password,self.UserTypeArray[selectedInt],self.code,_UserNameTF.text);
        
        [HttpClient registerWithUsername:self.phone password:self.password UserRole:self.UserTypeArray[selectedInt] code:self.code UserName:_UserNameTF.text andBlock:^(NSDictionary *responseDictionary) {
            int statusCode =[responseDictionary[@"statusCode"]intValue];
            DLog(@"statusCode == %d",statusCode);
            if (statusCode == 200) {
                UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"注册成功" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"去登录", nil];
                alertView.tag = 200;
                [alertView show];
            }else{
                NSString*message = responseDictionary[@"message"];
                kTipAlert(@"%@(%ld)",message,(long)statusCode);
            }
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 200) {
//        [self login];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//注册成功 登录
/*
- (void)login{
    MBProgressHUD *hud = [Tools createHUD];
    hud.labelText = @"登录中...";
   [HttpClient loginWithUsername:self.phone Password:self.password Enterprise:NO andBlock:^(NSInteger statusCode) {
       switch (statusCode) {
           case 0:{
               [hud hide:YES];
               kTipAlert(@"您的网络状态不太顺畅哦");
           }
               break;
           case 200:{
               DLog(@"登录成功");
               [hud hide:YES];
               [RootViewController setupTabarController];
               double delayInSeconds = 7.0;
               dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
               dispatch_after(popTime, dispatch_get_main_queue(), ^{
                   [Login saveLoginData];
               });
           }
               break;
           case 401:{
               [hud hide:YES];
               kTipAlert(@"用户名或密码错误");
           }
               break;
               
           default:
               [hud hide:YES];
               kTipAlert(@"登录失败 (%ld)",(long)statusCode);
               break;
       }
   }];
}
*/

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
            [cell addSubview:_UserTypeTF];
        }
        else if (indexPath.row == 1) {
            [cell addSubview:_UserNameTF];
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
    if (!self.UserTypePicker) {
        self.UserTypePicker = [[UIPickerView alloc] init];
        self.UserTypePicker.backgroundColor = [UIColor whiteColor];
        self.UserTypePicker.delegate = self;
        self.UserTypePicker.dataSource = self;
        [self.UserTypePicker selectRow:0 inComponent:0 animated:NO];
    }
    return self.UserTypePicker;
}

- (UIToolbar *)fecthToolbar {
    if (!self.UserTypeToolbar) {
        self.UserTypeToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ensure)];
        self.UserTypeToolbar.items = [NSArray arrayWithObjects:left,space,right,nil];
    }
    return self.UserTypeToolbar;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.UserTypeList.count;
}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.UserTypeList objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenW, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text = [self.UserTypeList objectAtIndex:row];
    myView.font = kFont;
    myView.backgroundColor = [UIColor clearColor];
    return myView;
}

-(void)ensure{
    NSInteger provinceIndex = [self.UserTypePicker selectedRowInComponent: PROVINCE_COMPONENT];
    _UserTypeString = [self.UserTypeList objectAtIndex: provinceIndex];
    kTipAlert(@"您选择的身份为%@",_UserTypeString);
    selectedInt = provinceIndex;
    
    _UserTypeTF.text = _UserTypeString;
    _UserTypeString = nil;
    
    [_UserTypeTF endEditing:YES];
    DLog(@"factoryTypeInt == %ld",(long)selectedInt);
    
}
-(void)cancel{
    _UserTypeString = nil;
    _UserTypeTF.text = nil;
    [_UserTypeTF endEditing:YES];
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
