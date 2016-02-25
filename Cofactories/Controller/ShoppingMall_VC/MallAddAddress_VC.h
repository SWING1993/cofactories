//
//  MallAddAddress_VC.h
//  Cofactories
//
//  Created by 赵广印 on 16/1/28.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MallAddAddress_VC : UITableViewController {
    UIPickerView *picker;
    UIButton *button;
    
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    NSString *selectedProvince;
    NSString *addressString;
}
@property (nonatomic, assign) BOOL haveAddress;

@end
