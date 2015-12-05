//
//  BidManage_Design_TVC.h
//  Cofactories
//
//  Created by GTF on 15/12/5.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BidManage_Design_TVC : UITableViewCell
@property (nonatomic,strong)UIButton *selectButton;
- (void)layoutDataWithModel:(BidManage_Design_Model *)model;
@end
