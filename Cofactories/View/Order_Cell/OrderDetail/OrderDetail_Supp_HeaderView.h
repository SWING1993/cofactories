//
//  OrderDetail_Supp_HeaderView.h
//  Cofactories
//
//  Created by GTF on 16/3/22.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetail_Supp_HeaderView : UIView
@property (nonatomic,strong)SupplierOrderModel *model;
@property (nonatomic,copy)NSString *userAddress;
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,assign)NSInteger enterType;
@property (nonatomic,copy)void(^ImageBtnBlock)(NSArray *imagsArray);
@property (nonatomic,copy)void(^ChatBtnBlock)(void);
@property (nonatomic,copy)void(^BidBtnBlock)(void);
@end
