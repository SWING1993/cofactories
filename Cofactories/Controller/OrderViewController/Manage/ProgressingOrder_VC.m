//
//  ProgressingOrder_VC.m
//  ChildVC
//
//  Created by GTF on 15/12/3.
//  Copyright © 2015年 GUY. All rights reserved.
//

#import "ProgressingOrder_VC.h"
#import "ProgressingOrder_TVC.h"
#import "SupplierOrderDetail_VC.h"
#import "FactoryOrderDetail_VC.h"
#import "DesignOrderDetail_VC.h"

@interface ProgressingOrder_VC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView     *_tableView;
    NSMutableArray  *_dataArray;
}
@property(nonatomic,strong)UserModel *userModel;
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
        
        FactoryOrderDetail_VC *vc = [FactoryOrderDetail_VC new];
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
        backItem.title=@"返回";
        backItem.tintColor=[UIColor whiteColor];
        self.navigationItem.backBarButtonItem = backItem;
        //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        [HttpClient getFactoryOrderDetailWithID:dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
            FactoryOrderMOdel *dataModel = [FactoryOrderMOdel getSupplierOrderModelWithDictionary:dictionary];
            vc.dataModel = dataModel;
            vc.factoryOrderDetailBidStatus = FactoryOrderDetailBidStatus_BidManagement;
            [HttpClient getOtherIndevidualsInformationWithUserID:dataModel.userUid WithCompletionBlock:^(NSDictionary *dictionary) {
                OthersUserModel *model = dictionary[@"message"];
                vc.otherUserModel = model;
                [self.navigationController pushViewController:vc animated:YES];
                
            }];
        }];

        
    }else if ([dataModel.orderType isEqualToString:@"设计师订单"]) {
        
        DesignOrderDetail_VC *vc = [DesignOrderDetail_VC new];
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
        backItem.title=@"返回";
        backItem.tintColor=[UIColor whiteColor];
        self.navigationItem.backBarButtonItem = backItem;
        //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        [HttpClient getDesignOrderDetailWithID:dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
            DesignOrderModel *dataModel = [DesignOrderModel getDesignOrderModelWithDictionary:dictionary];
            vc.dataModel = dataModel;
            vc.designOrderDetailBidStatus = DesignOrderDetailBidStatus_BidManagement;
            [HttpClient getOtherIndevidualsInformationWithUserID:dataModel.userUid WithCompletionBlock:^(NSDictionary *dictionary) {
                OthersUserModel *model = dictionary[@"message"];
                vc.otherUserModel = model;
                [self.navigationController pushViewController:vc animated:YES];
                
            }];
        }];

        
    }else if ([dataModel.orderType isEqualToString:@"供应商订单"]) {
        
        SupplierOrderDetail_VC *vc = [SupplierOrderDetail_VC new];
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
        backItem.title=@"返回";
        backItem.tintColor=[UIColor whiteColor];
        self.navigationItem.backBarButtonItem = backItem;
        //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        [HttpClient getSupplierOrderDetailWithID:dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
            SupplierOrderModel *dataModel = [SupplierOrderModel getSupplierOrderModelWithDictionary:dictionary];
            vc.dataModel = dataModel;
            vc.supplierOrderDetailBidStatus = SupplierOrderDetailBidStatus_BidManagement;
            [HttpClient getOtherIndevidualsInformationWithUserID:dataModel.userUid WithCompletionBlock:^(NSDictionary *dictionary) {
                OthersUserModel *model = dictionary[@"message"];
                vc.otherUserModel = model;
                [self.navigationController pushViewController:vc animated:YES];
            }];
        }];


    }else if ([dataModel.orderType isEqualToString:@"投标订单"]) {
        
        // 自己投过标
        DLog(@"==>>%d",_userModel.UserType);
        
        switch (_userModel.UserType) {
            case UserType_supplier:{
                
                SupplierOrderDetail_VC *vc = [SupplierOrderDetail_VC new];
                UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
                backItem.title=@"返回";
                backItem.tintColor=[UIColor whiteColor];
                self.navigationItem.backBarButtonItem = backItem;
                //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                
                [HttpClient getSupplierOrderDetailWithID:dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
                    SupplierOrderModel *dataModel = [SupplierOrderModel getSupplierOrderModelWithDictionary:dictionary];
                    vc.dataModel = dataModel;
                    vc.supplierOrderDetailBidStatus = SupplierOrderDetailBidStatus_BidOver;
                    [HttpClient getOtherIndevidualsInformationWithUserID:dataModel.userUid WithCompletionBlock:^(NSDictionary *dictionary) {
                        OthersUserModel *model = dictionary[@"message"];
                        vc.otherUserModel = model;
                        [self.navigationController pushViewController:vc animated:YES];
                    }];
                }];
            }
                
                break;
            case UserType_processing:{
                
                
                FactoryOrderDetail_VC *vc = [FactoryOrderDetail_VC new];
                UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
                backItem.title=@"返回";
                backItem.tintColor=[UIColor whiteColor];
                self.navigationItem.backBarButtonItem = backItem;
                //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                
                [HttpClient getFactoryOrderDetailWithID:dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
                    FactoryOrderMOdel *dataModel = [FactoryOrderMOdel getSupplierOrderModelWithDictionary:dictionary];
                    vc.dataModel = dataModel;
                    vc.factoryOrderDetailBidStatus = FactoryOrderDetailBidStatus_BidOver;
                    [HttpClient getOtherIndevidualsInformationWithUserID:dataModel.userUid WithCompletionBlock:^(NSDictionary *dictionary) {
                        OthersUserModel *model = dictionary[@"message"];
                        vc.otherUserModel = model;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }];
                }];
            }

                break;
            case UserType_designer:{
                
                
                DesignOrderDetail_VC *vc = [DesignOrderDetail_VC new];
                UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
                backItem.title=@"返回";
                backItem.tintColor=[UIColor whiteColor];
                self.navigationItem.backBarButtonItem = backItem;
                //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                
                [HttpClient getDesignOrderDetailWithID:dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
                    DesignOrderModel *dataModel = [DesignOrderModel getDesignOrderModelWithDictionary:dictionary];
                    vc.dataModel = dataModel;
                    vc.designOrderDetailBidStatus = DesignOrderDetailBidStatus_BidOver;
                    [HttpClient getOtherIndevidualsInformationWithUserID:dataModel.userUid WithCompletionBlock:^(NSDictionary *dictionary) {
                        OthersUserModel *model = dictionary[@"message"];
                        vc.otherUserModel = model;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }];
                }];
            }

                break;

            default:
                break;
        }

    }

}


@end
