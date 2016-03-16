//
//  OrderDetail_Design_VC.h
//  Cofactories
//
//  Created by GTF on 16/3/16.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, kOrderDetail_Design_Type) {
    kOrderDetail_Design_TypeDefault,        //设计师订单列表进入
    kOrderDetail_Design_TypeBid,            //设计师订单管理投标进入
    kOrderDetail_Design_TypePublic         //设计师订单管理发布进入
};

@interface OrderDetail_Design_VC : UIViewController
@property (nonatomic,assign) kOrderDetail_Design_Type enterType;
@property (nonatomic,copy)NSString *orderID;
@end
