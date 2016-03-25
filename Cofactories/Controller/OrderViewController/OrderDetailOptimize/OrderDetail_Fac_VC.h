//
//  OrderDetail_Fac_VC.h
//  Cofactories
//
//  Created by GTF on 16/3/24.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, kOrderDetail_Fac_Type) {
    kOrderDetail_Fac_TypeDefault,        //订单列表进入
    kOrderDetail_Fac_TypeBid,            //订单管理投标进入
    kOrderDetail_Fac_TypePublic,         //订单管理发布进入
    kOrderDetail_Fac_TypeJudge          //订单管理完成评分进入
};

@interface OrderDetail_Fac_VC : UIViewController
@property (nonatomic,assign) kOrderDetail_Fac_Type enterType;
@property (nonatomic,copy)NSString *orderID;
@property (nonatomic,copy)NSString *contractStatus;
@property (nonatomic,copy)NSString *winnerID;
@property (nonatomic,assign)BOOL isRestrict;
@end
