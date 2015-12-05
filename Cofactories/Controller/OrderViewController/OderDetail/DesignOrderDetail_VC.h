//
//  DesignOrderDetail_VC.h
//  Cofactories
//
//  Created by GTF on 15/12/2.
//  Copyright © 2015年 宋国华. All rights reserved.
//


typedef NS_ENUM(NSInteger, DesignOrderDetailBidStatus) {
    
    DesignOrderDetailBidStatus_Common,          // 普通状态订单详情
    DesignOrderDetailBidStatus_BidOver,         // 已投标订单详情
    DesignOrderDetailBidStatus_BidManagement,   // 投标管理订单详情
    DesignOrderDetailBidStatus_BidMark           // 评分订单详情
};


#import <UIKit/UIKit.h>

@interface DesignOrderDetail_VC : UIViewController
@property (nonatomic,strong)DesignOrderModel   *dataModel;
@property (nonatomic,strong)OthersUserModel     *otherUserModel;
@property (nonatomic,assign)DesignOrderDetailBidStatus designOrderDetailBidStatus;

@end
