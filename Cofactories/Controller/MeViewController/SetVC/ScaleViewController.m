//
//  ScaleViewController.m
//  Cofactories
//
//  Created by 宋国华 on 15/11/27.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "Tools.h"
#import "HttpClient.h"
#import "ScaleViewController.h"

#define PROVINCE_COMPONENT  0


@interface ScaleViewController () <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    UITextField*SizeTF;
    NSString *_tmpPickerName;
    
}

@property (nonatomic,strong) UIPickerView * orderPicker;
@property (nonatomic,strong) UIToolbar    * pickerToolbar;
@property (nonatomic,retain) NSArray      * cellPickList;
@property (nonatomic,retain) NSString     * seletectStr;

@end

@implementation ScaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"公司规模";
    
    
    //确定Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.rightBarButtonItem = setButton;
    
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO; 
    self.tableView.rowHeight = 40;
    
    if (self.userType == UserType_clothing) {
        DLog(@"11");
        self.cellPickList = @[@"0万件-10万件",@"10万件-40万件", @"40万件-100万件", @"100万件--200万件", @"200万件以上"];
    }
    else if (self.userType == UserType_processing) {
        DLog(@"22");
    self.cellPickList = @[@"0人-2人",@"2人-10人",  @"10人-20人", @"20人以上"];
    }
    
    SizeTF=[[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-30, 40)];
    SizeTF.font = kFont;
    SizeTF.text=self.placeholder;
    SizeTF.clearButtonMode=YES;
    SizeTF.inputView = [self fecthPicker];
    SizeTF.inputAccessoryView = [self fecthToolbar];
    SizeTF.placeholder=@"选择公司规模";
    SizeTF.delegate =self;
}
- (void)buttonClicked {
    if ([SizeTF.text isEqualToString:@""]) {
        UIAlertView*alertView =[[UIAlertView alloc]initWithTitle:@"公司规模不能为空" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
        MBProgressHUD *hud = [Tools createHUD];
        hud.labelText = @"正在修改";
        
        NSMutableDictionary * parametersDic = [[NSMutableDictionary alloc]initWithCapacity:1];
        [parametersDic setObject:self.seletectStr forKey:@"scale"];
        
        [HttpClient postMyProfileWithDic:parametersDic andBlock:^(NSInteger statusCode) {
            if (statusCode == 200) {
                hud.labelText = @"修改成功";
                [hud hide:YES];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                hud.labelText = @"修改失败";
                [hud hide:YES];
            }
        }];
    }
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    [cell addSubview:SizeTF];
    return cell;
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
    _tmpPickerName = [self pickerView:pickerView titleForRow:row forComponent:component];
}
-(void)ensure{
    
    NSInteger provinceIndex = [self.orderPicker selectedRowInComponent: PROVINCE_COMPONENT];
    self.seletectStr = [NSString stringWithFormat:@"%ld",(long)provinceIndex];
    _tmpPickerName = [self.cellPickList objectAtIndex: provinceIndex];
    SizeTF.text = _tmpPickerName;
    _tmpPickerName = nil;
    [SizeTF endEditing:YES];
}
-(void)cancel{
    
    _tmpPickerName = nil;
    [SizeTF endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
