//
//  Order_Factory_TVC.h
//  Cofactories
//
//  Created by GTF on 15/11/30.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FactoryOrderMOdel;

@interface Order_Factory_TVC : UITableViewCell
@property (nonatomic,strong)UIButton *imageButton;
- (void)laoutWithDataModel:(FactoryOrderMOdel *)dataModel;
@end
