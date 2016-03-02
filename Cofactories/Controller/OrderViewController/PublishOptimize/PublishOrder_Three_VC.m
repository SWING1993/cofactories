//
//  PublishOrder_Three_VC.m
//  Cofactories
//
//  Created by GTF on 16/2/29.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "PublishOrder_Three_VC.h"
#import "Publish_Three_TVC.h"
#import "Publish_AddPhoto_TVC.h"

@interface PublishOrder_Three_VC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSArray *sectionOneTitleArray;
@property (nonatomic,copy)NSArray *placeHolderArray;
@property (nonatomic,strong)UITextField *titleTF;
@property (nonatomic,strong)UITextField *amountTF;
@property (nonatomic,strong)UITextField *unitTF;
@property (nonatomic,strong)UITextField *commentTF;
@end
static NSString *const reuseIdentifier1 = @"reuseIdentifier1";
static NSString *const reuseIdentifier2 = @"reuseIdentifier2";

@implementation PublishOrder_Three_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    switch (_orderType) {
        case PublishOrderTypeFabric:
            self.navigationItem.title = @"求购面料";
            break;
        case PublishOrderTypeAccessory:
            self.navigationItem.title = @"求购辅料";
            break;
            
        case PublishOrderTypeMachine:
            self.navigationItem.title = @"求购机械设备";
            break;
        default:
            break;
    }
    
    _sectionOneTitleArray = @[@"标题",@"数量",@"单位",@"备注"];
    _placeHolderArray = @[@"请填写订单标题",
                          @"请填写订单数量",
                          @"请填写单位",
                          @"特殊要求请备注说明"];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        Publish_Three_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1 forIndexPath:indexPath];
        [cell loadDataWithTitleString:_sectionOneTitleArray[indexPath.row]
                    placeHolderString:_placeHolderArray[indexPath.row]
                             indexRow:indexPath.row];
        switch (indexPath.row) {
            case 0:
                _titleTF = cell.cellTF;
                break;
            case 1:
                _amountTF = cell.cellTF;
                break;
            case 2:
                _unitTF = cell.cellTF;
                break;
            case 3:
                _commentTF = cell.cellTF;
                break;
            default:
                break;
        }
        return cell;
    }
    
    Publish_AddPhoto_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier2 forIndexPath:indexPath];
    cell.PhotoViewBlock = ^{
        NSLog(@"1234567890");
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
        return 140;
    }
    
}

@end
