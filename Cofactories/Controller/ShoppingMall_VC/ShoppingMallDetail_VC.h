//
//  ShoppingMallDetail_VC.h
//  Cofactories
//
//  Created by 赵广印 on 16/1/27.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingMallDetail_VC : UIViewController
@property (nonatomic, strong) NSString *shopID;

@property (nonatomic, assign) NSInteger myAmount;//购物车里选择的数量， 默认1
@property (nonatomic, strong) NSString *myColorString;//购物车里选择的颜色，默认不选
@end
