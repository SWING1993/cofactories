//
//  MallOrderPay_VC.h
//  Cofactories
//
//  Created by 赵广印 on 16/1/29.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeHistoryOrderModel.h"

@interface MallOrderPay_VC : UITableViewController

@property (nonatomic, strong) MeHistoryOrderModel *goodsModel;
@property (nonatomic, assign) BOOL isMeMallOrder;

@end
