//
//  materialShopDetailController.h
//  Cofactories
//
//  Created by 赵广印 on 15/12/4.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface materialShopDetailController : UIViewController
@property (nonatomic, strong) NSString *shopID;

@property (nonatomic, assign) NSInteger myAmount;//购物车里选择的数量， 默认1
@property (nonatomic, strong) NSString *myColorString;//购物车里选择的颜色，默认不选

@end
