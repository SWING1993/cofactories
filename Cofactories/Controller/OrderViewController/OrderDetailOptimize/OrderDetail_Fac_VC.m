//
//  OrderDetail_Fac_VC.m
//  Cofactories
//
//  Created by GTF on 16/3/24.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//
#define kHeaderHeight 130
#import "OrderDetail_Fac_VC.h"

#import "OrderDetail_Fac_HeaderView.h"
#import "OrderDetail_Fac_TVC.h"
#import "OrderDetail_FacMark_TVC.h"
#import "OrderPhotoViewController.h"
#import "IMChatViewController.h"
#import "OrderBid_Factory_VC.h"
#import "BidManage_Factory_VC.h"
#import "MarkOrder_VC.h"
#import "Contract_VC.h"
#import "PersonalMessage_Factory_VC.h"

@interface OrderDetail_Fac_VC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView   *tableView;
@property (nonatomic,strong)FactoryOrderMOdel *facModel;
@property (nonatomic,strong)OthersUserModel  *otherUserModel;
@property (nonatomic,strong)UserModel *userModel;
@property (nonatomic,assign)BOOL    isMyselfOrder;
@property (nonatomic,assign)BOOL    isCompletion;
@property (nonatomic,assign)BOOL    isAlreadyBid;
@property (nonatomic,copy)NSArray   *bidAmountArray;
@property (nonatomic,strong)NSMutableArray   *cellArray;


@end
static NSString *const reuseIdentifier1 = @"reuseIdentifier1";
static NSString *const reuseIdentifier2 = @"reuseIdentifier2";
static NSString *const reuseIdentifier3 = @"reuseIdentifier3";

@implementation OrderDetail_Fac_VC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.userModel = [[UserModel alloc] getMyProfile];
    
    DLog(@"-------%@------",_userModel.uid);

    [HttpClient getFactoryOrderDetailWithID:_orderID WithCompletionBlock:^(NSDictionary *dictionary) {
        FactoryOrderMOdel *dataModel = [FactoryOrderMOdel getSupplierOrderModelWithDictionary:dictionary];
        _facModel = dataModel;

        if ([dataModel.userUid isEqualToString:_userModel.uid]) {
            _isMyselfOrder = YES;
        }else{
            _isMyselfOrder = NO;
        }
        if ([dataModel.status isEqualToString:@"0"]) {
            _isCompletion = NO;
        }else if ([dataModel.status isEqualToString:@"1"]){
            _isCompletion = YES;
        }
        
        [HttpClient getOtherIndevidualsInformationWithUserID:dataModel.userUid WithCompletionBlock:^(NSDictionary *dictionary) {
            OthersUserModel *model = dictionary[@"message"];
            _otherUserModel = model;
            [_tableView reloadData];
        }];
        
        [HttpClient getFactoryOrderBidUserAmountWithOrderID:dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
            _bidAmountArray = dictionary[@"message"];
            [_bidAmountArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                NSString *uID = [NSString stringWithFormat:@"%@",dic[@"uid"]];
                if ([uID isEqualToString:_userModel.uid]) {
                    _isAlreadyBid = YES;
                }else{
                    _isAlreadyBid = NO;
                }if (_isAlreadyBid) {
                    *stop = YES;
                }
            }];
            [_tableView reloadData];
        }];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _cellArray = [@[] mutableCopy];
    OrderDetail_Fac_TVC *cell = [[OrderDetail_Fac_TVC alloc] init];
    [_cellArray addObject:cell];
    [self setupTable];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
//    footerView.backgroundColor = GRAYCOLOR(242);
    _tableView.tableFooterView = footerView;
    self.userModel = [[UserModel alloc] getMyProfile];

    DLog(@"+++++++++======%@-----????-%@-----%@",_contractStatus,_winnerID,_userModel.uid);
    
    if ([_contractStatus isEqualToString:@"甲方签署合同"]&&[_winnerID isEqualToString:_userModel.uid]){
        footerView.hidden = NO;
    }else{
        footerView.hidden = YES;
    }
    
    UILabel *infoLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, kScreenW, 25)];
    infoLB.text = @"恭喜您已中标,请签署担保协议";
    infoLB.textAlignment = NSTextAlignmentCenter;
    infoLB.font = [UIFont systemFontOfSize:13];
    infoLB.textColor = MAIN_COLOR;
    [footerView addSubview:infoLB];
    
    UIButton *signContractButton = [UIButton buttonWithType:UIButtonTypeCustom];
    signContractButton.frame = CGRectMake(15, 60, kScreenW-30, 40);
    signContractButton.backgroundColor = MAIN_COLOR;
    [signContractButton setTitle:@"确定" forState:UIControlStateNormal];
    signContractButton.layer.masksToBounds = YES;
    signContractButton.layer.cornerRadius = 5;
    [signContractButton addTarget:self action:@selector(signClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:signContractButton];

}

- (void)signClick{
    
    Contract_VC *vc = [[Contract_VC alloc] init];
    vc.isClothing = NO;
    vc.orderID = _facModel.ID;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - baseSet
- (void)setupTable{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    [_tableView registerClass:[OrderDetail_Fac_TVC class] forCellReuseIdentifier:reuseIdentifier1];
    [_tableView registerClass:[OrderDetail_FacMark_TVC class] forCellReuseIdentifier:reuseIdentifier3];

    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier2];
    [self.view addSubview:_tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (_enterType == kOrderDetail_Fac_TypeJudge) {
            OrderDetail_FacMark_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier3 forIndexPath:indexPath];
            cell.model = _facModel;
            cell.isRestrict = _isRestrict;
            
            return cell;
        }
        
        OrderDetail_Fac_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1 forIndexPath:indexPath];
        cell.isRestrict = _isRestrict;
        cell.model = _facModel;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier2 forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" 已参与投标的厂商有%zi家",_bidAmountArray.count]];
    NSString *lengthString = [NSString stringWithFormat:@"%lu",(unsigned long)_bidAmountArray.count];
    NSInteger length = lengthString.length;
    [labelText addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(10,length)];
    cell.textLabel.attributedText = labelText;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return kHeaderHeight+20;
    }
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kHeaderHeight)];
        OrderDetail_Fac_HeaderView *header = [[OrderDetail_Fac_HeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kHeaderHeight)];
        header.model = _facModel;
        header.enterType = _enterType;
        header.userName = _otherUserModel.name;
        header.userAddress = [NSString stringWithFormat:@"地址: %@",_otherUserModel.address];
        [view addSubview:header];
        
        header.UserDetailBlock = ^{
            PersonalMessage_Factory_VC *vc = [PersonalMessage_Factory_VC new];
            vc.userModel = _otherUserModel;
            [self.navigationController pushViewController:vc animated:YES];
        };
        
        header.ImageBtnBlock = ^(NSArray *imagesArray){
            if (imagesArray.count == 0) {
                kTipAlert(@"用户未上传图片");
            }else{
                DLog(@"----111---");
                OrderPhotoViewController *vc = [[OrderPhotoViewController alloc] initWithPhotoArray:imagesArray];
                vc.titleString = @"订单图片";
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        header.ChatBtnBlock = ^{
            IMChatViewController *conversationVC = [[IMChatViewController alloc]init];
            conversationVC.conversationType = ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
            conversationVC.targetId = self.otherUserModel.uid; // 接收者的 targetId，这里为举例。
            conversationVC.title = self.otherUserModel.name; // 会话的 title。
            conversationVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController.navigationBar setHidden:NO];
            [self.navigationController pushViewController:conversationVC animated:YES];
            
            [HttpClient statisticsWithKey:@"IMChat" withUid:_userModel.uid andBlock:^(NSInteger statusCode) {
                DLog(@"------------%ld--------",(long)statusCode);
            }];
        };
        __weak typeof(self) weakSelf = self;
        header.BidBtnBlock = ^{
            switch (weakSelf.enterType) {
                case kOrderDetail_Fac_TypeDefault:{
                    if (!_isMyselfOrder) {
                        if (!_isCompletion) {
                            if (!_isAlreadyBid) {
                                OrderBid_Factory_VC *vc = [OrderBid_Factory_VC new];
                                vc.orderID = _facModel.ID;
                                vc.orderTypeString = @"FactoryOrder";
                                [self.navigationController pushViewController:vc animated:YES];
                            }else{
                                kTipAlert(@"该订单您已投过标");
                            }
                        }else{
                            kTipAlert(@"该订单已完成投标");
                        }
                    }else{
                        kTipAlert(@"不可投标自己的订单");
                    }
                }
                    break;
                    
                case kOrderDetail_Fac_TypeBid:{
                    kTipAlert(@"该订单您已投过标");
                }
                    break;
                    
                case kOrderDetail_Fac_TypePublic:{
                    if (_bidAmountArray.count == 0) {
                        kTipAlert(@"该订单暂无商家投标");
                    }else{
                        BidManage_Factory_VC *vc = [BidManage_Factory_VC new];
                        vc.orderID = _facModel.ID;
                        vc.isRestrict = _isRestrict;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }
                    break;
                    
                case kOrderDetail_Fac_TypeJudge:{
                    MarkOrder_VC *vc = [MarkOrder_VC new];
                    vc.markOrderType = MarkOrderType_Factory;
                    vc.orderID = _facModel.ID;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                default:
                    break;
            }
        };
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGSize textSize=[_facModel.descriptions boundingRectWithSize:CGSizeMake(kScreenW-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size;
        
        if (_enterType == kOrderDetail_Fac_TypeJudge) {
            
            if (_isRestrict) {
                return  220+textSize.height+15;
            }else{
                return 195+textSize.height+15;
            }

        }else{
            if (_isRestrict) {
               return  170+textSize.height+15;
            }else{
                return 145+textSize.height+15;
            }
        }

    }
    return 40;
}


@end
