//
//  PublishOrder_Factory_VC.m
//  Cofactories
//
//  Created by GTF on 15/11/27.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#define kPhotoWidth  ([UIScreen mainScreen].bounds.size.width - 50)/4.f


#import "PublishOrder_Factory_Restrict_VC.h"
#import "CustomeView.h"
#import "Publish_Three_TVC.h"
#import "Publish_AddPhoto_TVC.h"
#import "JKImagePickerTool.h"
#import "GTFLoadPhoto_VC.h"
#import "CalendarHomeViewController.h"
#import "UserModel.h"
#import "AuthenticationController.h"
#import "RechargeViewController.h"

@interface PublishOrder_Factory_Restrict_VC ()<UITableViewDataSource,UITableViewDelegate,JKImagePickerControllerDelegate,UIAlertViewDelegate>{
    UITextField    *_amountTF;
    UITextField    *_commentTF;
    NSString       *_typeString;
    NSString       *_amountString;
    NSString       *_timeString;
    NSString       *_commentString;
    NSString       *_moneyString;
    CustomeView    *_customeView;
    UIButton       *_addButton;
    UIScrollView     *_scrollView;
    CalendarHomeViewController *_calendar;
    
}
@property (nonatomic, strong) NSMutableArray   *imageArray;
@property (nonatomic, strong) JKImagePickerTool *tool;
@property (nonatomic,strong) UIButton  *timeButton;
@property (nonatomic,strong) UserModel *userModel;
@property (nonatomic,strong) UILabel   *typeLabel1;
@property (nonatomic,strong) UILabel   *typeLabel2;

@end

static NSString *const reuseIdentifier2 = @"reuseIdentifier2";

@implementation PublishOrder_Factory_Restrict_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userModel = [[UserModel alloc] getMyProfile];
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageArray = [NSMutableArray arrayWithArray:@[]];
    
    [self initTableView];
    _typeString = @"针织/梭织";
    _amountString = nil;
    _timeString = @"请选择订单期限";
    _moneyString = @"1000";
    _commentString = nil;
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-44-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    [_tableView registerClass:[Publish_AddPhoto_TVC class] forCellReuseIdentifier:reuseIdentifier2];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Publish_AddPhoto_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier2 forIndexPath:indexPath];
    cell.imageArray = self.imageArray;
    
    cell.AddPhotoBlock = ^{
        if (_imageArray.count == 9) {
            kTipAlert(@"最多上传9张图片");
        }else{
            _tool = [[JKImagePickerTool alloc] init];
            _tool.assetsArray = self.imageArray;
            _tool.viewController = self;
        }
    };
    
    cell.BrowsePhotoBlock = ^(NSInteger selectedIndex){
        NSLog(@"%ld",(long)selectedIndex);
        GTFLoadPhoto_VC *vc = [[GTFLoadPhoto_VC alloc] init];
        vc.imagesArray = self.imageArray;
        vc.selectedIndex = selectedIndex;
        vc.ReloadBlock = ^{
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    cell.PublishBlock = ^{
        [self publishAction];
    };
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44*6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 0, kScreenW, 44*6+10);
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 15, 20)];
    imageView.image = [UIImage imageNamed:@"dd.png"];
    [headerView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 8, 120, 25)];
    label.textColor = MAIN_COLOR;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"订单信息";
    [headerView addSubview:label];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 70, 44)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:titleLabel];
    
    NSString *string = @"* 订单类型";
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
    titleLabel.attributedText = attributedTitle;
    
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45+44, 100, 44)];
    amountLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:amountLabel];
    
    NSString *string1 = @"* 订单数量(件)";
    NSMutableAttributedString *attributedTitle1 = [[NSMutableAttributedString alloc] initWithString:string1];
    [attributedTitle1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
    amountLabel.attributedText = attributedTitle1;
    
    _amountTF = [[UITextField alloc] initWithFrame:CGRectMake(115, 45+44+7, kScreenW - 120, 30)];
    _amountTF.font = [UIFont systemFontOfSize:12];
    _amountTF.textColor = [UIColor grayColor];
    _amountTF.keyboardType = UIKeyboardTypeNumberPad;
    _amountTF.placeholder = @"请填写订单数量";
    _amountTF.text = _amountString;
    [_amountTF addTarget:self action:@selector(amountTFChange) forControlEvents:    UIControlEventEditingChanged];
    [headerView addSubview:_amountTF];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45+44+44, 70, 44)];
    timeLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:timeLabel];
    
    NSString *string2 = @"* 订单期限";
    NSMutableAttributedString *attributedTitle2 = [[NSMutableAttributedString alloc] initWithString:string2];
    [attributedTitle2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
    timeLabel.attributedText = attributedTitle2;
    
    _timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _timeButton.frame = CGRectMake(115, 45+44+44+8, kScreenW-200, 30);
    _timeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_timeButton setTitleColor:GRAYCOLOR(190) forState:UIControlStateNormal];
    [_timeButton setTitle:_timeString forState:UIControlStateNormal];
    [_timeButton addTarget:self action:@selector(timeChangeClick) forControlEvents:UIControlEventTouchUpInside];
    _timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [headerView addSubview:_timeButton];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45+44+44+44, 70, 44)];
    moneyLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:moneyLabel];
    
    NSString *string3 = @"* 设保证金";
    NSMutableAttributedString *attributedTitle3 = [[NSMutableAttributedString alloc] initWithString:string3];
    [attributedTitle3 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
    moneyLabel.attributedText = attributedTitle3;
    
    _customeView = [[CustomeView alloc] initWithFrame:CGRectMake(115, 45+44+44+44+12, kScreenW-200, (kScreenW-200)/6.f)];
    _customeView.amount = [_moneyString integerValue];
    _customeView.MoneyBlock = ^(NSInteger integer){
        _moneyString = [NSString stringWithFormat:@"%ld",(long)integer];
    };
    [headerView addSubview:_customeView];
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45+44+44+44+44, 70, 44)];
    commentLabel.font = [UIFont systemFontOfSize:14];
    commentLabel.text = @"备注";
    [headerView addSubview:commentLabel];
    
    _commentTF = [[UITextField alloc] initWithFrame:CGRectMake(115, 45+44+44+44+44+7, kScreenW - 120, 30)];
    _commentTF.font = [UIFont systemFontOfSize:12];
    _commentTF.placeholder = @"特殊要求填写备注说明";
    _commentTF.text = _commentString;
    [_commentTF addTarget:self action:@selector(commentTFChange) forControlEvents:    UIControlEventEditingChanged];
    [headerView addSubview:_commentTF];
    
    
    _typeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(115, 45, 100, 44)];
    _typeLabel2.font = [UIFont systemFontOfSize:12];
    _typeLabel2.textColor = [UIColor grayColor];
    _typeLabel2.text = _typeString;
    _typeLabel2.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:_typeLabel2];
    
    __weak typeof(self) weakSelf = self;
    self.TypeStringChangeBlock2 = ^(NSString *string){
        _typeString = string;
        [weakSelf.tableView reloadData];
    };
    
    CALayer *linelayer = [CALayer layer];
    linelayer.frame = CGRectMake(0, 44*6, kScreenW, 10);
    linelayer.backgroundColor = GRAYCOLOR(235).CGColor;
    [headerView.layer addSublayer:linelayer];
    
    return headerView;
}

- (void)commentTFChange{
    _commentString = _commentTF.text;
    [self.tableView reloadData];
}

- (void)amountTFChange{
    _amountString = _amountTF.text;
    [self.tableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 15+(kPhotoWidth+15)*(_imageArray.count/4+1) + 55;
}

- (void)timeChangeClick{
    if (!_calendar) {
        NSLog(@"22");
        
        _calendar = [[CalendarHomeViewController alloc]init];
        
        _calendar.calendartitle = @"空闲日期";
        
        [_calendar setAirPlaneToDay:365 ToDateforString:nil];//飞机初始化方法
        
    }
    
    __weak typeof(self) weakSelf = self;
    
    _calendar.calendarblock = ^(CalendarDayModel *model){
        
        _timeString = [model toString];
        [weakSelf.tableView reloadData];
        
    };
    [self presentViewController:_calendar animated:YES completion:nil];
}

- (void)publishAction{
    
    
    DLog(@"------------>>>>>%@,%@,%@,%ld,%@,%@",_typeLabel2.text,_amountTF.text,_timeButton.titleLabel.text,(long)_customeView.moneyAmount,_commentTF.text,_imageArray);
    
    if (_typeLabel2.text.length != 2 || _amountTF.text.length == 0 || [Tools isBlankString:_amountTF.text] == YES || [_timeButton.titleLabel.text isEqualToString:@"请选择订单期限"]) {
        kTipAlert(@"请填写必填信息，再发布订单!");
    }else{
        if (_imageArray.count == 0) {
            kTipAlert(@"限制订单发布,必须上传图片");
        }else{
            if ([_amountTF.text isEqualToString:@"0"]) {
                kTipAlert(@"订单数量不得为0!");
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认发布订单" delegate:self cancelButtonTitle:@"再看看" otherButtonTitles:@"确认发布", nil];
                alertView.tag = 200;
                [alertView show];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 10086) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    else if (alertView.tag == 200) {
        if (buttonIndex == 1) {
            DLog(@"%@,%@,%@,%ld,%@",_typeLabel2.text,_amountTF.text,_timeButton.titleLabel.text,(long)_customeView.moneyAmount,_commentTF.text);
            
            NSString *typeString = @"";
            if ([_typeLabel2.text isEqualToString:@"针织"]) {
                typeString = @"knit";
            }else{
                typeString = @"woven";
            }
            
            //  此处要修改
            [HttpClient publishFactoryOrderWithSubrole:@"加工厂"type:typeString amount:_amountTF.text deadline:_timeButton.titleLabel.text description:_commentTF.text credit:[NSString stringWithFormat:@"%ld",(long)_customeView.moneyAmount] WithCompletionBlock:^(NSDictionary *dictionary) {
                
                
                if ([dictionary[@"statusCode"] isEqualToString:@"200"]) {
                    if (_imageArray.count > 0) {
                        [Tools upLoadImagesWithArray:_imageArray policyString:dictionary[@"message"][@"data"][@"policy"] signatureString:dictionary[@"message"][@"data"][@"signature"]];
                    }else{
                        //用户为上传图片
                    }
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布订单成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    alertView.tag = 10086;
                    [alertView show];
                }else if ([dictionary[@"statusCode"] isEqualToString:@"404"]) {
                    kTipAlert(@"发布订单失败，请重新登录");
                }
                
                
                else if ([dictionary[@"statusCode"] isEqualToString:@"404"]) {
                    kTipAlert(@"发布订单失败，请重新登录");
                }else if ([dictionary[@"statusCode"] isEqualToString:@"402"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"钱包余额小于您设置的保证金额" message:@"请充值" delegate:self cancelButtonTitle:@"暂不充值" otherButtonTitles:@"立即充值", nil];
                    alert.tag = 402;
                    [alert show];
                }else if ([dictionary[@"statusCode"] isEqualToString:@"403"]) {
                    
                    if (_userModel.verify_status == 0) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未认证用户" message:nil delegate:self cancelButtonTitle:@"暂不认证" otherButtonTitles:@"立即认证", nil];
                        alert.tag = 403;
                        [alert show];
                    }else if (_userModel.verify_status == 1){
                        kTipAlert(@"您的认证正在处理，请耐心等待结果!");
                    }
                }
                
            }];
            
        }
        
    }
    
    else if (alertView.tag == 402) {
        if (buttonIndex == 1) {
            [self.navigationController pushViewController:[RechargeViewController new] animated:YES];
        }
    }
    
    else if (alertView.tag == 403) {
        if (buttonIndex == 1) {
            AuthenticationController *vc = [AuthenticationController new];
            vc.homeEnter = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source{
    
    [assets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.imageArray addObject:obj];
    }];
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadData];
    }];
}


@end
