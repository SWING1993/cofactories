//
//  MarkOrder_TVC.h
//  Cofactories
//
//  Created by GTF on 15/12/5.
//  Copyright © 2015年 宋国华. All rights reserved.
//


typedef NS_ENUM(NSInteger, MarkOrderType) {
    
    MarkOrderType_Supplier,        // 评分供应商订单
    MarkOrderType_Factory,         // 评分工厂订单
    MarkOrderType_Design,          // 评分设计订单
    
};

#import <UIKit/UIKit.h>

@interface MarkOrder_VC : UITableViewController
@property (nonatomic,assign)MarkOrderType  markOrderType;
@property (nonatomic,copy)NSString   *orderID;
@end
