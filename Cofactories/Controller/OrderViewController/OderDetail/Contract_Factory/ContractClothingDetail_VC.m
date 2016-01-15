//
//  ContractClothingDetail_VC.m
//  Cofactories
//
//  Created by GTF on 16/1/13.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "ContractClothingDetail_VC.h"
#import "OrderPhotoViewController.h"
#import "PersonalMessage_Factory_VC.h"
#import "PersonalMessage_Clothing_VC.h"
#import "PersonalMessage_Design_VC.h"
#import "IMChatViewController.h"
#import "UILabel+extension.h"
#import "TimeAxis_TVC.h"
#import "AddOrderMessage_VC.h"
@interface ContractClothingDetail_VC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView         *_tableView;
    NSString            *_descriptionString;
    NSInteger            _sectionFooterHeight;
    NSMutableArray      *_timeAxisMutableArray;
}
@property (nonatomic,strong)FactoryOrderMOdel  *dataModel;
@property (nonatomic,strong)OthersUserModel    *otherUserModel;
@end
static NSString *const reuseIdentifier1 = @"reuseIdentifier1";
static NSString *const reuseIdentifier2 = @"reuseIdentifier2";

@implementation ContractClothingDetail_VC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!_timeAxisMutableArray) {
        _timeAxisMutableArray = [@[] mutableCopy];
    }
    
    [HttpClient getFactoryOrderDetailWithID:_modelID WithCompletionBlock:^(NSDictionary *dictionary) {
        FactoryOrderMOdel *dataModel = [FactoryOrderMOdel getSupplierOrderModelWithDictionary:dictionary];
        _dataModel = dataModel;
        [HttpClient getOtherIndevidualsInformationWithUserID:dataModel.userUid WithCompletionBlock:^(NSDictionary *dictionary) {
            OthersUserModel *model = dictionary[@"message"];
            _otherUserModel = model;
            [_tableView reloadData];
        }];
        
        [HttpClient getOrderMessageWithOrderID:_dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
            if ([dictionary[@"statusCode"] isEqualToString:@"200"]) {
                NSMutableArray *responseArray = dictionary[@"message"];
                if (responseArray.count == 0) {
                    [_timeAxisMutableArray addObject:@"订单状态更新 点此更新"];
                }else{
                    _timeAxisMutableArray = responseArray;
                    NSInteger index = [_timeAxisMutableArray indexOfObject:[_timeAxisMutableArray lastObject]];
                    [_timeAxisMutableArray insertObject:@"订单状态更新" atIndex:index+1];                }
            }
            [_tableView reloadData];
        }];
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"订单详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _descriptionString = [NSString stringWithFormat:@"备注信息: %@",_dataModel.descriptions];
    [self initTable];
    
}

- (void)initTable{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 35;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier1];
    [_tableView registerClass:[TimeAxis_TVC class] forCellReuseIdentifier:reuseIdentifier2];

    [self.view addSubview:_tableView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }
    return _timeAxisMutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1 forIndexPath:indexPath];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"  类型:   %@",_dataModel.type];
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"  数量:   %@件",_dataModel.amount];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"  下单时间:   %@",_dataModel.createdAt];
                
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"  交货日期:   %@",_dataModel.deadline];
                
                break;
            case 4:
                cell.textLabel.text = [NSString stringWithFormat:@"  担保金额:   %@元",_dataModel.creditMoney];
                
                break;
            default:
                break;
        }

        return cell;
    }
    
    TimeAxis_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier2 forIndexPath:indexPath];
    
    BOOL isFirst = indexPath.row == 0;
    BOOL isLast = indexPath.row == _timeAxisMutableArray.count - 1;
    BOOL isOnlyOne = _timeAxisMutableArray.count == 1;
    [cell setData:_timeAxisMutableArray[indexPath.row] isFirst:isFirst isLast:isLast isOnlyOne:isOnlyOne];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 44;
    }
    CGSize size = [TimeAxis_TVC getCellHeightWithString:_timeAxisMutableArray[indexPath.row]];
    return size.height + 40;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 175;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIButton *headerView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 175)];
        headerView.backgroundColor = [UIColor whiteColor];
        headerView.userInteractionEnabled = YES;
        [headerView addTarget:self action:@selector(userDetailClick) forControlEvents:UIControlEventTouchUpInside];

        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        imageButton.frame = CGRectMake(15,10, 80, 65);
        imageButton.layer.masksToBounds = YES;
        imageButton.layer.cornerRadius = 5;
        if (_dataModel.photoArray.count > 0) {
            [imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,[_dataModel.photoArray firstObject]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
        }else{
            [imageButton setBackgroundImage:[UIImage imageNamed:@"placeHolderImage"] forState:UIControlStateNormal];
        }
        [imageButton addTarget:self action:@selector(imageDetailClick) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:imageButton];
        
        UILabel *nameLB = [[UILabel alloc] initWithFrame:CGRectMake(105, 10, kScreenW-120, 30)];
        nameLB.font = [UIFont systemFontOfSize:14];
        nameLB.text = _otherUserModel.name;
        [headerView addSubview:nameLB];
        
        UILabel *addressLB = [[UILabel alloc] initWithFrame:CGRectMake(105, 40, kScreenW-120, 30)];
        addressLB.font = [UIFont systemFontOfSize:12];
        addressLB.text = [NSString stringWithFormat:@"地址: %@",_otherUserModel.address];
        addressLB.textColor = [UIColor grayColor];
        [headerView addSubview:addressLB];
        
        CALayer *lineLayer = [CALayer layer];
        lineLayer.backgroundColor = MAIN_COLOR.CGColor;
        lineLayer.frame = CGRectMake(15,85, kScreenW-30, 0.5);
        [headerView.layer addSublayer:lineLayer];
        
        NSArray *buttonArray = @[@"chatImage",@"manageBid"];
        for (int i=0; i<buttonArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*kScreenW/2.f, 86, kScreenW/2.f, 40);
            [button setBackgroundImage:[UIImage imageNamed:buttonArray[i]] forState:UIControlStateNormal];
            button.tag = i+1;
            [button addTarget:self action:@selector(chatBidClick:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:button];
        }
        
        CALayer *lineLayer1 = [CALayer layer];
        lineLayer1.backgroundColor = GRAYCOLOR(233).CGColor;
        lineLayer1.frame = CGRectMake(0,126, kScreenW, 14);
        [headerView.layer addSublayer:lineLayer1];
        
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 140, kScreenW, 35)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 15, 20)];
        imageView.image = [UIImage imageNamed:@"dd.png"];
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50-2, 8, 100, 25)];
        label.textColor = MAIN_COLOR;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"订单信息";
        [view addSubview:label];
        
        UILabel *numberLB = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-160, 8, 150, 27)];
        numberLB.text = [NSString stringWithFormat:@"订单编号: %@",_dataModel.ID];
        numberLB.textColor = [UIColor grayColor];
        numberLB.textAlignment = NSTextAlignmentRight;
        numberLB.font = [UIFont systemFontOfSize:12];
        [view addSubview:numberLB];

        [headerView addSubview:view];
        
        return headerView;
    }
    
    return nil;
}

- (void)imageDetailClick{
    if (_dataModel.photoArray.count == 0) {
        kTipAlert(@"用户未上传图片");
    }else{
        OrderPhotoViewController *vc = [[OrderPhotoViewController alloc] initWithPhotoArray:_dataModel.photoArray];
        vc.titleString = @"订单图片";
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)userDetailClick{
    if ([_otherUserModel.role isEqualToString:@"加工配套"]) {
        PersonalMessage_Factory_VC *vc = [PersonalMessage_Factory_VC new];
        vc.userModel = _otherUserModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([_otherUserModel.role isEqualToString:@"服装企业"]){
        PersonalMessage_Clothing_VC *vc = [PersonalMessage_Clothing_VC new];
        vc.userModel = _otherUserModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        // 设计师、供应商
        PersonalMessage_Design_VC *vc = [PersonalMessage_Design_VC new];
        vc.userModel = _otherUserModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

- (void)chatBidClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 1) {
        IMChatViewController *conversationVC = [[IMChatViewController alloc]init];
        conversationVC.conversationType = ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        conversationVC.targetId = self.otherUserModel.uid; // 接收者的 targetId，这里为举例。
        conversationVC.userName = self.otherUserModel.name; // 接受者的 username，这里为举例。
        conversationVC.title = self.otherUserModel.name; // 会话的 title。
        conversationVC.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController.navigationBar setHidden:NO];
        [self.navigationController pushViewController:conversationVC animated:YES];
        
    }else if (button.tag == 2){
        kTipAlert(@"该订单已完成投标");
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        CGSize size = [Tools getSize:_descriptionString andFontOfSize:13.f andWidthMake:kScreenW-40];
        _sectionFooterHeight = size.height +20;
        return _sectionFooterHeight;
    }
    
    return 140;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, _sectionFooterHeight)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *LB1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW-40, 100)];
        LB1.font = [UIFont systemFontOfSize:13.f];
        LB1.numberOfLines = 0;
        LB1.textColor = [UIColor grayColor];
        LB1.frame = CGRectMake(20, 0, kScreenW-40, _sectionFooterHeight);
        LB1.text = _descriptionString;
        [LB1 setRowSpace:5];
        [view addSubview:LB1];
        
        CALayer *lineLayer1 = [CALayer layer];
        lineLayer1.backgroundColor = GRAYCOLOR(200).CGColor;
        lineLayer1.frame = CGRectMake(0,_sectionFooterHeight - 1, kScreenW, 0.5);
        [view.layer addSublayer:lineLayer1];

        return view;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 140)];
    view.backgroundColor = [UIColor whiteColor];
    
    CALayer *lineLayer1 = [CALayer layer];
    lineLayer1.backgroundColor = GRAYCOLOR(200).CGColor;
    lineLayer1.frame = CGRectMake(0,0, kScreenW, 0.5);
    [view.layer addSublayer:lineLayer1];

    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == _timeAxisMutableArray.count - 1) {
//            [HttpClient addOrderMessageWithOrderID:_dataModel.ID message:@"么么么么我是你大爷" WithCompletionBlock:^(NSDictionary *dictionary) {
//                
//            }];
            AddOrderMessage_VC *vc = [AddOrderMessage_VC new];
            vc.isClothingEnter = YES;
            vc.orderID = _dataModel.ID;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

@end
