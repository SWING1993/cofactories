//
//  SupplierOrderDetail_VC.h
//  Cofactories
//
//  Created by GTF on 15/12/1.
//  Copyright © 2015年 宋国华. All rights reserved.
//

typedef NS_ENUM(NSInteger, SupplierOrderDetailBidStatus) {
    
    SupplierOrderDetailBidStatus_Common,          // 普通状态订单详情
    SupplierOrderDetailBidStatus_BidOver,         // 已投标订单详情
    SupplierOrderDetailBidStatus_BidManagement  // 投标管理订单详情
    
};

#import <UIKit/UIKit.h>

@interface SupplierOrderDetail_VC : UIViewController
@property (nonatomic,strong)SupplierOrderModel  *dataModel;
@property (nonatomic,strong)OthersUserModel     *otherUserModel;
@property (nonatomic,assign)SupplierOrderDetailBidStatus supplierOrderDetailBidStatus;
@end
