//
//  MeHistoryOrderDetail_VC.h
//  Cofactories
//
//  Created by 赵广印 on 15/12/15.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeHistoryOrderModel.h"

@interface MeHistoryOrderDetail_VC : UITableViewController

@property (nonatomic, strong) MeHistoryOrderModel *orderModel;
@property (nonatomic, assign) BOOL isBuy;
@end
