//
//  OrderDetail_Supp_VC.h
//  Cofactories
//
//  Created by GTF on 16/3/22.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, kOrderDetail_Supp_Type) {
    kOrderDetail_Supp_TypeDefault,        //订单列表进入
    kOrderDetail_Supp_TypeBid,            //订单管理投标进入
    kOrderDetail_Supp_TypePublic,         //订单管理发布进入
    kOrderDetail_Supp_TypeJudge          //订单管理完成评分进入

};

@interface OrderDetail_Supp_VC : UIViewController
@property (nonatomic,assign) kOrderDetail_Supp_Type enterType;
@property (nonatomic,copy)NSString *orderID;
@end
