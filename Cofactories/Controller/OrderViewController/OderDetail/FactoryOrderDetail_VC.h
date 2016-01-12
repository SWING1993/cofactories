//
//  FactoryOrderDetail_VC.h
//  Cofactories
//
//  Created by GTF on 15/11/30.
//  Copyright © 2015年 宋国华. All rights reserved.
//

typedef NS_ENUM(NSInteger, FactoryOrderDetailBidStatus) {
   
    FactoryOrderDetailBidStatus_Common,          // 普通状态订单详情
    FactoryOrderDetailBidStatus_BidOver,         // 已投标订单详情
    FactoryOrderDetailBidStatus_BidManagement,   // 投标管理订单详情
    FactoryOrderDetailBidStatus_BidMark           // 评分订单详情
};

#import <UIKit/UIKit.h>

@interface FactoryOrderDetail_VC : UIViewController
@property (nonatomic,strong)FactoryOrderMOdel  *dataModel;
@property (nonatomic,strong)OthersUserModel    *otherUserModel;
@property (nonatomic,assign)FactoryOrderDetailBidStatus factoryOrderDetailBidStatus;
@property (nonatomic,assign)BOOL               isRescrit; // 是否为限制订单
@end
