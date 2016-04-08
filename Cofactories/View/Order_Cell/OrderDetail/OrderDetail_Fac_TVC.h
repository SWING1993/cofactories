//
//  OrderDetail_Fac_TVC.h
//  Cofactories
//
//  Created by GTF on 16/3/24.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetail_Fac_TVC : UITableViewCell
@property (nonatomic,strong)FactoryOrderMOdel *model;
@property (nonatomic,assign)BOOL isRestrict;

@end
