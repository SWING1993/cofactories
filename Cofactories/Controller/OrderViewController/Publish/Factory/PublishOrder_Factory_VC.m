//
//  PublishOrder_Factory_VC.m
//  Cofactories
//
//  Created by GTF on 16/1/8.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "PublishOrder_Factory_VC.h"
#import "ZFPopupMenu.h"
#import "ZFPopupMenuItem.h"
#import "Publish_Three_TVC.h"
#import "Publish_AddPhoto_TVC.h"
#import"Publish_FactoryOrderType_TVC.h"
#import "JKImagePickerTool.h"
#import "GTFLoadPhoto_VC.h"
#import "CalendarHomeViewController.h"

#define kPhotoWidth  ([UIScreen mainScreen].bounds.size.width - 50)/4.f

@interface PublishOrder_Factory_VC ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,JKImagePickerControllerDelegate,UIAlertViewDelegate,ClickCanlendarDelegate>

@property (nonatomic, strong) UIScrollView   *scrollView;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UILabel        *lineLB;
@property (nonatomic, strong) UIView         *bgView;
@property (nonatomic, strong) UITableView    *tableOne;
@property (nonatomic, strong) UITableView    *tableTwo;
@property (nonatomic,copy)    NSString       *typeString;
@property (nonatomic,strong)  UITextField    *amountTF;
@property (nonatomic,copy)    NSString       *timeString;
@property (nonatomic,strong)  UITextField    *commentTF;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) JKImagePickerTool *tool;
@property (nonatomic,copy)    NSArray        *sectionOneTitleArray;
@property (nonatomic,copy)    NSArray        *placeHolderArray;
@property (nonatomic,strong)  CalendarHomeViewController *calendar;

@end
static NSString *const reuseIdentifier1 = @"reuseIdentifier1";
static NSString *const reuseIdentifier2 = @"reuseIdentifier2";
static NSString *const reuseIdentifier3 = @"reuseIdentifier3";
static NSString *const reuseIdentifier4 = @"reuseIdentifier4";
static NSString *const reuseIdentifier5 = @"reuseIdentifier5";
static NSString *const reuseIdentifier6 = @"reuseIdentifier6";
static NSString *const reuseIdentifier7 = @"reuseIdentifier7";
@implementation PublishOrder_Factory_VC

-(NSArray *)menuItems
{
    ZFPopupMenuItem *item1 = [ZFPopupMenuItem initWithMenuName:@"针织"
                                                         image:nil
                                                        action:@selector(test:)
                                                        target:self];
    item1.tag = 1;
    ZFPopupMenuItem *item2 = [ZFPopupMenuItem initWithMenuName:@"梭织"
                                                         image:nil
                                                        action:@selector(test:)
                                                        target:self];
    item2.tag = 2;
    return @[item1,item2];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"需求加工厂";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _buttonArray = [@[] mutableCopy];
    _sectionOneTitleArray = @[@"订单数量",@"订单期限",@"备注"];
    _placeHolderArray = @[@"请填写订单数量",
                          @"请选择订单期限",
                          @"特殊要求请备注说明"];
    self.imageArray = [NSMutableArray arrayWithArray:@[]];
    
    [self initBGView];
    [self initSelectButon];
    [self initScrollView];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kScreenW-30, 20, 30, 30);
    [button setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(typeAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)initBGView{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 44)];
    _bgView.backgroundColor = GRAYCOLOR(240);
    [self.view addSubview:_bgView];
}

- (void)initSelectButon{
    NSArray *array = @[@"普通订单",@"担保订单"];
    for (int i = 0; i<array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((kScreenW-200)/3.f+i*(80+(kScreenW-200)/3.f), 0, 100, 42);
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.tag = i+1;
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_bgView addSubview:button];
        
        if (i == 0) {
            [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            _lineLB = [UILabel new];
            _lineLB.frame = CGRectMake(button.frame.origin.x+15, 42, 70, 2);
            _lineLB.backgroundColor = MAIN_COLOR;
            [_bgView addSubview:_lineLB];
        }
        [_buttonArray addObject:button];
    }
}

- (void)initScrollView{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44+64, kScreenW, kScreenH-44-64)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(kScreenW*2, kScreenH-44-64);
    
    for (int i = 0; i<2; i++) {
        UITableView *vc = [[UITableView alloc] initWithFrame:CGRectMake(i*kScreenW, 0, kScreenW, kScreenH-44-64) style:UITableViewStyleGrouped];
        vc.tag = i+1;
        vc.delegate = self;
        vc.dataSource = self;
        if (i==0) {
            _tableOne = vc;
            [_tableOne registerClass:[Publish_Three_TVC class] forCellReuseIdentifier:reuseIdentifier1];
            [_tableOne registerClass:[Publish_AddPhoto_TVC class] forCellReuseIdentifier:reuseIdentifier2];
            [_tableOne registerClass:[Publish_FactoryOrderType_TVC class] forCellReuseIdentifier:reuseIdentifier3];
            
        }else{
            _tableTwo = vc;
            
            [_tableTwo registerClass:[Publish_Three_TVC class] forCellReuseIdentifier:reuseIdentifier4];
            [_tableTwo registerClass:[Publish_AddPhoto_TVC class] forCellReuseIdentifier:reuseIdentifier5];
            [_tableTwo registerClass:[Publish_FactoryOrderType_TVC class] forCellReuseIdentifier:reuseIdentifier6];
        }
        [_scrollView addSubview:vc];
    }
    
    [_tableOne registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    [_tableTwo registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell2"];
    
}

#pragma mark - table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 1) {
        return 2;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 1) {
        if (section == 0) {
            return 4;
        }
        return 1;
    }else{
        if (section == 0) {
            return 4;
        }
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 1) {
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                Publish_FactoryOrderType_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier3 forIndexPath:indexPath];
                cell.typeString = _typeString;
                return cell;
            }else if (indexPath.row > 0){
                Publish_Three_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1 forIndexPath:indexPath];
                cell.isShowCanlendar = NO;
                BOOL isLast = (indexPath.row == _sectionOneTitleArray.count) ? YES:NO;
                [cell loadDataWithTitleString:_sectionOneTitleArray[indexPath.row-1]
                            placeHolderString:_placeHolderArray[indexPath.row-1]
                                       isLast:isLast];
                switch (indexPath.row) {
                    case 1:
                        _amountTF = cell.cellTF;
                        cell.isShowCanlendar = NO;
                        break;
                    case 2:
                        cell.isShowCanlendar = YES;
                        cell.delgate = self;
                        break;
                    case 3:
                        cell.isShowCanlendar = NO;
                        _commentTF = cell.cellTF;
                        break;
                    default:
                        break;
                }
                return cell;
                
            }
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
                [self.tableOne reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        cell.PublishBlock = ^{
            [self publishAction];
        };
        
        return cell;
        
    }else{
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                Publish_FactoryOrderType_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier6 forIndexPath:indexPath];
                cell.typeString = _typeString;
                return cell;
            }else if (indexPath.row > 0){
                Publish_Three_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier4 forIndexPath:indexPath];
                cell.isShowCanlendar = NO;
                BOOL isLast = (indexPath.row == _sectionOneTitleArray.count) ? YES:NO;
                [cell loadDataWithTitleString:_sectionOneTitleArray[indexPath.row-1]
                            placeHolderString:_placeHolderArray[indexPath.row-1]
                                       isLast:isLast];
                switch (indexPath.row) {
                    case 1:
                        _amountTF = cell.cellTF;
                        cell.isShowCanlendar = NO;
                        break;
                    case 2:
                        cell.isShowCanlendar = YES;
                        cell.delgate = self;
                        break;
                    case 3:
                        cell.isShowCanlendar = NO;
                        _commentTF = cell.cellTF;
                        break;
                    default:
                        break;
                }
                return cell;
                
            }
        }
        
        Publish_AddPhoto_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier5 forIndexPath:indexPath];
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
                [self.tableOne reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        cell.PublishBlock = ^{
            //[self publishAction];
        };
        return cell;
    }
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
        [self.tableOne reloadData];
    }];
}


#pragma mark - privite

- (void)publishAction{
    
    if (_typeString.length != 2 || _amountTF.text.length == 0 || [Tools isBlankString:_amountTF.text] == YES || [_timeString isEqualToString:@"请选择订单期限"]) {
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

- (void)buttonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    [UIView animateWithDuration:0.2 animations:^{
        _lineLB.frame = CGRectMake(button.frame.origin.x+15, 42, 70, 2);
    }];
    [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    if (button.tag == 1) {
        UIButton *lastButton = (UIButton *)[_bgView viewWithTag:2];
        [lastButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else if (button.tag == 2){
        UIButton *lastButton = (UIButton *)[_bgView viewWithTag:1];
        [lastButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
    _scrollView.contentOffset = CGPointMake(kScreenW*(button.tag-1), 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //DLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    [UIView animateWithDuration:0.2 animations:^{
        
        _lineLB.frame = CGRectMake((kScreenW-200)/3.f+(scrollView.contentOffset.x/scrollView.frame.size.width)*(80+(kScreenW-200)/3.f)+15, 42, 70, 2);
    } completion:^(BOOL finished) {
        if (scrollView.contentOffset.x == scrollView.frame.size.width) {
            [self initParam:_tableTwo];
        }else{
            [self initParam:_tableOne];
        }
    }];
    
    UIButton *buttonOne = (UIButton *)_buttonArray[0];
    UIButton *buttonTwo = (UIButton *)_buttonArray[1];
    
    if (scrollView.contentOffset.x == 0) {
        [buttonOne setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [buttonTwo setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else if (scrollView.contentOffset.x == scrollView.frame.size.width){
        [buttonTwo setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [buttonOne setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    
}

- (void)initParam:(UITableView *)table{
    _typeString = nil;
    _amountTF.text = nil;
    _timeString = nil;
    _commentTF.text = nil;
    [table reloadData];
}

- (void)typeAction{
    [ZFPopupMenu setMenuBackgroundColorWithRed:0 green:0 blue:0 aphla:0.2];
    [ZFPopupMenu setTextColorWithRed:1 green:1 blue:1 aphla:1.0];
    ZFPopupMenu *popupMenu = [[ZFPopupMenu alloc] initWithItems:[self menuItems]];
    [popupMenu showInView:self.navigationController.view fromRect:CGRectMake(kScreenW - 60, 5, 40, 40) layoutType:Vertical];
    [self.navigationController.view addSubview:popupMenu];
    
    DLog(@"%@",_typeString);
    
}

-(void)test:(ZFPopupMenuItem *)item{
    if (item.tag == 1) {
        _typeString = @"针织";
        [_tableOne reloadData];
    }else{
        _typeString = @"梭织";
        [_tableOne reloadData];
    }
}


@end
