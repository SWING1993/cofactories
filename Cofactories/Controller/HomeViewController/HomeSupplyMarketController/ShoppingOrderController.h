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


@end
