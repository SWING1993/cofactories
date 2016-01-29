//
//  ContractFactoryDetail_VC.m
//  Cofactories
//
//  Created by GTF on 16/1/13.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "ContractFactoryDetail_VC.h"
#import "OrderPhotoViewController.h"
#import "PersonalMessage_Factory_VC.h"
#import "PersonalMessage_Clothing_VC.h"
#import "PersonalMessage_Design_VC.h"
#import "IMChatViewController.h"
#import "UILabel+extension.h"
#import "TimeAxis_TVC.h"
#import "AlertWithTF.h"

@interface ContractFactoryDetail_VC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    UITableView         *_tableView;
    NSString            *_descriptionString;
    NSInteger            _sectionFooterHeight;
    NSMutableArray      *_timeAxisMutableArray;
}
@property (nonatomic,strong)FactoryOrderMOdel  *dataModel;
@property (nonatomic,strong)OthersUserModel    *otherUserModel;
@property (nonatomic,assign)BOOL                isDriveContract;   // 是否导出合同
@end
static NSString *const reuseIdentifier1 = @"reuseIdentifier1";
static NSString *const reuseIdentifier2 = @"reuseIdentifier2";




@implementation ContractFactoryDetail_VC

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
    self.navigationItem.title = @"订单详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
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
        
        NSArray *buttonArray = @[@"chatImage",@"alreadyBid"];
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
        kTipAlert(@"该订单您已投标");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        CGSize size = [Tools getSize:_descriptionString andFontOfSize:13.f andWidthMake:kScreenW-40];
        _sectionFooterHeight = size.height +20;
        return _sectionFooterHeight;
    }
    
    return 120;
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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
    view.backgroundColor = [UIColor whiteColor];
    
    CALayer *lineLayer1 = [CALayer layer];
    lineLayer1.backgroundColor = GRAYCOLOR(200).CGColor;
    lineLayer1.frame = CGRectMake(0,0, kScreenW, 0.5);
    [view.layer addSublayer:lineLayer1];
    
    UIButton *contractButton = [UIButton buttonWithType:UIButtonTypeCustom];
    contractButton.frame = CGRectMake(20, 20, 20, 20);
    contractButton.layer.cornerRadius = 10;
    contractButton.layer.borderWidth = 1;
    [contractButton addTarget:self action:@selector(contractClick:) forControlEvents:UIControlEventTouchUpInside];
    contractButton.layer.borderColor = [[UIColor grayColor] CGColor];
    [view addSubview:contractButton];
    
    UILabel *contractLB = [[UILabel alloc] initWithFrame:CGRectMake(45, 20, 100, 20)];
    contractLB.text = @"《用户担保协议》";
    contractLB.font = [UIFont systemFontOfSize:12];
    [view addSubview:contractLB];
    
    UIButton *driveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    driveButton.frame = CGRectMake(145, 10, 40, 40);
    driveButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [driveButton setTitle:@"导出" forState:UIControlStateNormal];
    [driveButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [driveButton addTarget:self action:@selector(driveClick) forControlEvents:UIControlEventTouchUpInside];
    driveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [view addSubview:driveButton];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 60,kScreenW-40,40);
    [button setTitle:@"订单完成" forState:UIControlStateNormal];
    button.backgroundColor = MAIN_COLOR;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == _timeAxisMutableArray.count - 1) {
            
            AlertWithTF *alertTF = [[AlertWithTF alloc] init];
            [alertTF loadAlertViewInVC:self withTitle:@"发布订单状态更新" message:nil textFieldPlaceHolder:@"请输入更新内容" handelTitle:@[@"取消",@"确定"] tfText:^(NSDictionary *dictionary) {
                DLog(@"%@,%@",dictionary[@"index"],dictionary[@"text"]);
                NSNumber *stausNumber = dictionary[@"index"];
                NSString *publishString = dictionary[@"text"];
                if ([stausNumber compare:@1] == NSOrderedSame) {
                    if (publishString.length == 0 || [Tools isBlankString:publishString]) {
                        kTipAlert(@"请先输入需要发布的内容!");
                    }else{
                        [HttpClient addOrderMessageWithOrderID:_dataModel.ID message:publishString WithCompletionBlock:^(NSDictionary *dictionary) {
                            if ([dictionary[@"statusCode"] isEqualToString:@"200"]) {
                                
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

                                
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"订单发布更新成功!" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                [alert show];
                            }
                        }];

                    }
                }
            }];
        }
    }
}

- (void)confirmClick{
    NSLog(@"111");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"货款已收完全收到?确认本次交易完成?双方订单完成并评分后,保证金将返还到双方钱包!" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1){
        //  发送确认成功的请求
        [HttpClient finishRestrictOrderWithOrderID:_modelID WithCompletionBlock:^(NSDictionary *dictionary) {
            NSString *statusCode = dictionary[@"statusCode"];
            if ([statusCode isEqualToString:@"200"]) {
                kTipAlert(@"订单完成,请去评分以解冻保证金!");
            }else{
                kTipAlert(@"订单完成失败,请检查网络,是否登陆");
            }
        }];

    }
}

- (void)contractClick:(UIButton *)button{
    
    _isDriveContract = !_isDriveContract;
    if (_isDriveContract) {
        [button setBackgroundImage:[UIImage imageNamed:@"leftBtn_Selected.png"] forState:UIControlStateNormal];
    }else{
        [button setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

- (void)driveClick{
    if (_isDriveContract) {
        NSLog(@"243423");
        [self saveImageToMyAlbumWithOrderID:_dataModel.ID];
    }else{
        kTipAlert(@"请勾选左侧合同导出按钮!");
    }
    
}

- (void)saveImageToMyAlbumWithOrderID:(NSString *)orderID{
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@",kBaseUrl,@"/order/factory/contract/",orderID,@"?access_token=",[HttpClient getToken].accessToken]]];
    DLog(@"%@",[NSString stringWithFormat:@"%@%@%@%@%@",kBaseUrl,@"/order/factory/contract/",orderID,@"?access_token=",[HttpClient getToken].accessToken]);
    UIImage *image = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        kTipAlert(@"保存失败,请检查你的网络!");
    }else{
        kTipAlert(@"保存成功,请自行去相册查看!");
    }
}

@end
