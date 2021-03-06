//
//  ProgressingOrder_VC.m
//  ChildVC
//
//  Created by GTF on 15/12/3.
//  Copyright © 2015年 GUY. All rights reserved.
//

#import "ProgressingOrder_VC.h"
#import "ProgressingOrder_TVC.h"
#import "OrderDetail_Design_VC.h"
#import "OrderDetail_Supp_VC.h"
#import "OrderDetail_Fac_VC.h"

#import "ContractClothingDetail_VC.h"
#import "ContractFactoryDetail_VC.h"
#import "MJRefresh.h"

@interface ProgressingOrder_VC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView     *_tableView;
    NSMutableArray  *_dataArray;
    int              _refrushCount;
}
@property(nonatomic,strong)UserModel *userModel;
@property(nonatomic,copy)NSString    *contractStatus;
@end
static NSString *const reuseIdentifier = @"reuseIdentifier";

@implementation ProgressingOrder_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.userModel = [[UserModel alloc] getMyProfile];
    _dataArray = [@[] mutableCopy];
    [self initTableView];
    
    [HttpClient getAllMyOrdersWithOrderStatus:@"0" page:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
        DLog(@"%@",dictionary);
        _dataArray = dictionary[@"message"];
        [_tableView reloadData];
        
    }];
    [self setupRefresh];
}

- (void)setupRefresh
{
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText = @"加载中...";
}

- (void)footerRereshing
{
    _refrushCount++;
    DLog(@"_refrushCount==%d",_refrushCount);
    [HttpClient getAllMyOrdersWithOrderStatus:@"0" page:@(_refrushCount) WithCompletionBlock:^(NSDictionary *dictionary){
        NSArray *array = dictionary[@"message"];;
        
        for (int i=0; i<array.count; i++)
        {
            FactoryOrderMOdel *model = array[i];
            
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
        
    }];
    [_tableView footerEndRefreshing];
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-44-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    [_tableView registerClass:[ProgressingOrder_TVC class] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProgressingOrder_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    ProcessingAndComplitonOrderModel *dataModel = _dataArray[indexPath.row];
    [cell laoutWithDataModel:dataModel userModel:_userModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProcessingAndComplitonOrderModel *dataModel = _dataArray[indexPath.row];
    
    if ([dataModel.orderType isEqualToString:@"加工订单"]) {
        
        if ([dataModel.contractStaus isEqualToString:@"双方签署合同"]) {
            
            ContractClothingDetail_VC *vc = [[ContractClothingDetail_VC alloc] init];
            UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
            backItem.title=@"返回";
            backItem.tintColor=[UIColor whiteColor];
            self.navigationItem.backBarButtonItem = backItem;
            
            vc.modelID = dataModel.ID;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{

            OrderDetail_Fac_VC *vc = [OrderDetail_Fac_VC new];
            vc.enterType = kOrderDetail_Fac_TypePublic;
            [HttpClient getFactoryOrderDetailWithID:dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
                FactoryOrderMOdel *model = [FactoryOrderMOdel getSupplierOrderModelWithDictionary:dictionary];
                vc.orderID = model.ID;
                if ([model.credit isEqualToString:@"担保订单"]) {
                    vc.isRestrict = YES;
                }else{
                    vc.isRestrict = NO;
                }

                [self.navigationController pushViewController:vc animated:YES];
            }];
        }
        
    }else if ([dataModel.orderType isEqualToString:@"设计师订单"]) {
        
        OrderDetail_Design_VC *vc = [OrderDetail_Design_VC new];
        vc.enterType = kOrderDetail_Design_TypePublic;
        [HttpClient getDesignOrderDetailWithID:dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
            DesignOrderModel *model = [DesignOrderModel getDesignOrderModelWithDictionary:dictionary];
            vc.orderID = model.ID;
            [self.navigationController pushViewController:vc animated:YES];
        }];

        
    }else if ([dataModel.orderType isEqualToString:@"供应商订单"]) {
        
        OrderDetail_Supp_VC *vc = [OrderDetail_Supp_VC new];
        vc.enterType = kOrderDetail_Supp_TypePublic;
        [HttpClient getSupplierOrderDetailWithID:dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
            SupplierOrderModel *model = [SupplierOrderModel getSupplierOrderModelWithDictionary:dictionary];
            vc.orderID = model.ID;
            [self.navigationController pushViewController:vc animated:YES];
        }];

    }else if ([dataModel.orderType isEqualToString:@"投标订单"]) {
        
        // 自己投过标
        DLog(@"==>>%ld",(long)_userModel.UserType);
        
        switch (_userModel.UserType) {
            case UserType_supplier:{
                OrderDetail_Supp_VC *vc = [OrderDetail_Supp_VC new];
                vc.enterType = kOrderDetail_Supp_TypeBid;
                [HttpClient getSupplierOrderDetailWithID:dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
                    SupplierOrderModel *model = [SupplierOrderModel getSupplierOrderModelWithDictionary:dictionary];
                    vc.orderID = model.ID;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }
                break;
            case UserType_processing:{
                
                _contractStatus = dataModel.contractStaus;  // 合同的状态
                
                DLog(@"_contractStatus == %@",_contractStatus);
                
                if ([_contractStatus isEqualToString:@"双方签署合同"]) {
                    
                    ContractFactoryDetail_VC *vc = [[ContractFactoryDetail_VC alloc] init];
                    vc.modelID = dataModel.ID;
                    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
                    backItem.title=@"返回";
                    backItem.tintColor=[UIColor whiteColor];
                    self.navigationItem.backBarButtonItem = backItem;
                    
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    
                    OrderDetail_Fac_VC *vc = [OrderDetail_Fac_VC new];
                    vc.enterType = kOrderDetail_Fac_TypeBid;
                    [HttpClient getFactoryOrderDetailWithID:dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
                        FactoryOrderMOdel *model = [FactoryOrderMOdel getSupplierOrderModelWithDictionary:dictionary];
                        vc.orderID = model.ID;
                        vc.contractStatus = _contractStatus;
                        vc.winnerID = model.orderWinnerID;
                        if ([model.credit isEqualToString:@"担保订单"]) {
                            vc.isRestrict = YES;
                        }else{
                            vc.isRestrict = NO;
                        }
                        
                        [self.navigationController pushViewController:vc animated:YES];
                    }];
                }
            }

                break;
            case UserType_designer:{
                OrderDetail_Design_VC *vc = [OrderDetail_Design_VC new];
                vc.enterType = kOrderDetail_Design_TypeBid;
                [HttpClient getDesignOrderDetailWithID:dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
                    DesignOrderModel *model = [DesignOrderModel getDesignOrderModelWithDictionary:dictionary];
                    vc.orderID = model.ID;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }
                break;

            default:
                break;
        }

    }

}


@end
