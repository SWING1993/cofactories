//
//  OrderDetail_Supp_VC.m
//  Cofactories
//
//  Created by GTF on 16/3/22.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#define kHeaderHeight 130
#import "OrderDetail_Supp_VC.h"

#import "OrderDetail_Supp_TVC.h"
#import "OrderDetail_Supp_HeaderView.h"
#import "OrderPhotoViewController.h"
#import "IMChatViewController.h"
#import "OrderBid_Supplier_VC.h"
#import "BidManage_Supplier_VC.h"

@interface OrderDetail_Supp_VC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView   *tableView;
@property (nonatomic,strong)SupplierOrderModel *suppModel;
@property (nonatomic,strong)OthersUserModel  *otherUserModel;
@property (nonatomic,strong)UserModel *userModel;
@property (nonatomic,assign)BOOL    isMyselfOrder;
@property (nonatomic,assign)BOOL    isCompletion;
@property (nonatomic,assign)BOOL    isAlreadyBid;
@property (nonatomic,copy)NSArray   *bidAmountArray;

@end

static NSString *const reuseIdentifier1 = @"reuseIdentifier1";
static NSString *const reuseIdentifier2 = @"reuseIdentifier2";
@implementation OrderDetail_Supp_VC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!self.userModel) {
        self.userModel = [[UserModel alloc] getMyProfile];
    }
    
    [HttpClient getSupplierOrderDetailWithID:_orderID WithCompletionBlock:^(NSDictionary *dictionary) {
        SupplierOrderModel *dataModel = [SupplierOrderModel getSupplierOrderModelWithDictionary:dictionary];
        _suppModel = dataModel;
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
        
        [HttpClient getSupplierOrderBidUserAmountWithOrderID:dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
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
    
    [self setupTable];
}

#pragma mark - baseSet
- (void)setupTable{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    [_tableView registerClass:[OrderDetail_Supp_TVC class] forCellReuseIdentifier:reuseIdentifier1];
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
        OrderDetail_Supp_TVC*cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1 forIndexPath:indexPath];
        cell.model = _suppModel;
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
        OrderDetail_Supp_HeaderView *header = [[OrderDetail_Supp_HeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kHeaderHeight)];
        header.model = _suppModel;
        header.enterType = _enterType;
        header.userName = _otherUserModel.name;
        header.userAddress = [NSString stringWithFormat:@"地址: %@",_otherUserModel.address];
        [view addSubview:header];
        
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
            
        };
        __weak typeof(self) weakSelf = self;
        header.BidBtnBlock = ^{
            switch (weakSelf.enterType) {
                case kOrderDetail_Supp_TypeDefault:{
                    if (!_isMyselfOrder) {
                        if (!_isCompletion) {
                            if (!_isAlreadyBid) {
                                OrderBid_Supplier_VC *vc = [OrderBid_Supplier_VC new];
                                vc.orderID = _suppModel.ID;
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
                    
                case kOrderDetail_Supp_TypeBid:{
                    kTipAlert(@"该订单您已投过标");
                }
                    break;
                    
                case kOrderDetail_Supp_TypePublic:{
                    if (_bidAmountArray.count == 0) {
                        kTipAlert(@"该订单暂无商家投标");
                    }else{
                        BidManage_Supplier_VC *vc = [BidManage_Supplier_VC new];
                        vc.orderID = _suppModel.ID;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
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
     CGSize textSize=[_suppModel.descriptions boundingRectWithSize:CGSizeMake(kScreenW-90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size;
        return 140+20+textSize.height;
    }
    return 40;
}

@end
