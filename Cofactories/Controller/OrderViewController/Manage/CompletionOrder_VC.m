//
//  CompletionOrder_VC.m
//  ChildVC
//
//  Created by GTF on 15/12/3.
//  Copyright © 2015年 GUY. All rights reserved.
//

#import "CompletionOrder_VC.h"
#import "CompletionOrder_TVC.h"
#import "OrderDetail_Supp_VC.h"
#import "OrderDetail_Design_VC.h"
#import "OrderDetail_Fac_VC.h"
@interface CompletionOrder_VC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSMutableArray  *_dataArray;

}
@property(nonatomic,strong)UserModel *userModel;
@end
static NSString *const reuseIdentifier = @"reuseIdentifier";
@implementation CompletionOrder_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.userModel = [[UserModel alloc] getMyProfile];
    _dataArray = [@[] mutableCopy];
    [self initTableView];
    
    [HttpClient getAllMyOrdersWithOrderStatus:@"1" page:@1 WithCompletionBlock:^(NSDictionary *dictionary) {
        DLog(@"%@",dictionary);
        _dataArray = dictionary[@"message"];
        [_tableView reloadData];
        
    }];
    
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-44-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    [_tableView registerClass:[CompletionOrder_TVC class] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CompletionOrder_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    ProcessingAndComplitonOrderModel *dataModel = _dataArray[indexPath.row];
    [cell layoutWithDataModel:dataModel userModel:_userModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProcessingAndComplitonOrderModel *dataModel = _dataArray[indexPath.row];
    CompletionOrder_TVC *cell  = [tableView cellForRowAtIndexPath:indexPath];
    
    DLog(@"%d",cell.isMark);
    
    if (cell.isMark) {
        kTipAlert(@"该订单您已评过分!");
    }else if (!cell.isMark){
        
        // 评分
        
        if ([dataModel.orderType isEqualToString:@"加工订单"]) {
            
            OrderDetail_Fac_VC *vc = [OrderDetail_Fac_VC new];
            vc.enterType = kOrderDetail_Fac_TypeJudge;
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
            
            
        }else if ([dataModel.orderType isEqualToString:@"设计师订单"]) {
            
            OrderDetail_Design_VC *vc = [OrderDetail_Design_VC new];
            vc.enterType = kOrderDetail_Design_TypeJudge;
            [HttpClient getDesignOrderDetailWithID:dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
                DesignOrderModel *model = [DesignOrderModel getDesignOrderModelWithDictionary:dictionary];
                vc.orderID = model.ID;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
        }else if ([dataModel.orderType isEqualToString:@"供应商订单"]) {
            
            OrderDetail_Supp_VC *vc = [OrderDetail_Supp_VC new];
            vc.enterType = kOrderDetail_Supp_TypeJudge;
            [HttpClient getSupplierOrderDetailWithID:dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
                SupplierOrderModel *model = [SupplierOrderModel getSupplierOrderModelWithDictionary:dictionary];
                vc.orderID = model.ID;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
        }else if ([dataModel.orderType isEqualToString:@"投标订单"]) {
            
            // 自己中标
            DLog(@"==>>%ld",_userModel.UserType);
            
            switch (_userModel.UserType) {
                case UserType_supplier:{
                    
                    OrderDetail_Supp_VC *vc = [OrderDetail_Supp_VC new];
                    vc.enterType = kOrderDetail_Supp_TypeJudge;
                    [HttpClient getSupplierOrderDetailWithID:dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
                        SupplierOrderModel *model = [SupplierOrderModel getSupplierOrderModelWithDictionary:dictionary];
                        vc.orderID = model.ID;
                        [self.navigationController pushViewController:vc animated:YES];
                    }];
                }
                    break;
                case UserType_processing:{
                    
                    OrderDetail_Fac_VC *vc = [OrderDetail_Fac_VC new];
                    vc.enterType = kOrderDetail_Fac_TypeJudge;
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
                    
                    break;
                case UserType_designer:{
                    
                    OrderDetail_Design_VC *vc = [OrderDetail_Design_VC new];
                    vc.enterType = kOrderDetail_Design_TypeJudge;
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
}


@end
