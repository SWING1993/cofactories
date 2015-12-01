//
//  Order_Supplier_TVC.h
//  Cofactories
//
//  Created by GTF on 15/12/1.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Order_Supplier_TVC : UITableViewCell
@property (nonatomic,strong)UIButton *imageButton;
- (void)laoutWithDataModel:(SupplierOrderModel *)dataModel;
@end
