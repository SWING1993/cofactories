//
//  PublishOrder_Other_VC.m
//  Cofactories
//
//  Created by GTF on 16/3/2.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//
#define kPhotoWidth  ([UIScreen mainScreen].bounds.size.width - 50)/4.f

#import "PublishOrder_Other_VC.h"
#import "Publish_Three_TVC.h"
#import "Publish_AddPhoto_TVC.h"
#import "JKImagePickerTool.h"
#import "GTFLoadPhoto_VC.h"
#import "CalendarHomeViewController.h"

@interface PublishOrder_Other_VC ()<UITableViewDataSource,UITableViewDelegate,JKImagePickerControllerDelegate,UIAlertViewDelegate,ClickCanlendarDelegate>
@property (nonatomic, strong) NSMutableArray   *imageArray;
@property (nonatomic, strong) JKImagePickerTool *tool;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSArray *sectionOneTitleArray;
@property (nonatomic,copy)NSArray *placeHolderArray;
@property (nonatomic,strong)UITextField *amountTF;
@property (nonatomic,strong)UITextField *commentTF;
@property (nonatomic,copy)NSString *timeString;
@property (nonatomic,assign)BOOL isAblePublish;
@property (nonatomic,strong)CalendarHomeViewController *calendar;

@end
static NSString *const reuseIdentifier1 = @"reuseIdentifier1";
static NSString *const reuseIdentifier2 = @"reuseIdentifier2";
@implementation PublishOrder_Other_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"寻找其他生产配套";
    
    _sectionOneTitleArray = @[@"订单数量",@"订单期限",@"备注"];
    _placeHolderArray = @[@"请填写订单数量",
                          @"请选择订单期限",
                          @"特殊要求请备注说明"];
    self.imageArray = [NSMutableArray arrayWithArray:@[]];
    
    [self initTable];
}

- (void)initTable{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[Publish_Three_TVC class] forCellReuseIdentifier:reuseIdentifier1];
    [_tableView registerClass:[Publish_AddPhoto_TVC class] forCellReuseIdentifier:reuseIdentifier2];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _sectionOneTitleArray.count;
    }else{
        return 1;
    }
}

#pragma mark - table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        Publish_Three_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1 forIndexPath:indexPath];
        BOOL isLast = (indexPath.row+1 == _sectionOneTitleArray.count) ? YES:NO;
        [cell loadDataWithTitleString:_sectionOneTitleArray[indexPath.row]
                    placeHolderString:_placeHolderArray[indexPath.row]
                             isLast:isLast];
        switch (indexPath.row) {
            case 0:
                _amountTF = cell.cellTF;
                cell.isShowCanlendar = NO;
                break;
            case 1:
                cell.isShowCanlendar = YES;
                cell.delgate = self;
                break;
            case 2:
                _commentTF = cell.cellTF;
                cell.isShowCanlendar = NO;
                break;
            default:
                break;
        }
        return cell;
    }
    
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
    if (section == 0) {
        return 40;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 15;
    }else{
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        headView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 15, 20)];
        imageView.image = [UIImage imageNamed:@"dd.png"];
        [headView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 8, 120, 25)];
        label.textColor = MAIN_COLOR;
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"订单信息";
        [headView addSubview:label];
        
        return headView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }else{
        return 15+(kPhotoWidth+15)*(_imageArray.count/4+1) + 55;
        
    }
    
}

#pragma mark - calanderBtn
- (void)clickCanlendarButton:(UIButton *)button{
//    NSLog(@">>>>>-------------%@",button.titleLabel.text);
    if (!_calendar) {
        NSLog(@"22");
        
        _calendar = [[CalendarHomeViewController alloc]init];
        
        _calendar.calendartitle = @"空闲日期";
        
        [_calendar setAirPlaneToDay:365 ToDateforString:nil];//飞机初始化方法
        
    }

    _calendar.calendarblock = ^(CalendarDayModel *model){
        
        [button setTitle:[NSString stringWithFormat:@"%@",[model toString]] forState:UIControlStateNormal];
        _timeString = [model toString];
    };
    [self presentViewController:_calendar animated:YES completion:nil];
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

#pragma mark - privite
- (void)publishAction{
    if (_amountTF.text.length == 0 || [Tools isBlankString:_amountTF.text] == YES ||_timeString == nil) {
        kTipAlert(@"请填写必填信息，再发布订单!");
    }else{
        if ([_amountTF.text isEqualToString:@"0"]) {
            kTipAlert(@"订单数量不得为0!");
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认发布订单" delegate:self cancelButtonTitle:@"再看看" otherButtonTitles:@"确认发布", nil];
            alertView.tag = 100;
            [alertView show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            
            DLog(@"%@,%@,%@,%@",_amountTF.text,_timeString,_commentTF.text,_imageArray);
            
            [HttpClient publishFactoryOrderWithSubrole:@"其他" type:@"" amount:_amountTF.text deadline:_timeString description:_commentTF.text credit:@"-1" WithCompletionBlock:^(NSDictionary *dictionary) {
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
            }];
        }
    }
    
    if (alertView.tag == 10086) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end