//
//  ShoppingOrderController.h
//  Cofactories
//
//  Created by 赵广印 on 15/12/9.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingOrderController : UITableViewController {
    UIPickerView *picker;
    UIButton *button;
    
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    NSString *selectedProvince;
    NSString *addressString;
}

@property (nonatomic, strong) NSMutableDictionary *goodsDic;//商品分类和数量的数组
@property (nonatomic, strong) NSString *goodsID;//来判断剩余多少件商品
@property (nonatomic, assign) NSInteger goodsNumber;//购买商品数量

@end
