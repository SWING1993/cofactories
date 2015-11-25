//
//  SetaddressViewController.h
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/16.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetaddressViewController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource>{

    UIPickerView *picker;
    UIButton *button;

    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;

    NSString *selectedProvince;
    NSString *addressString;
}

@end
