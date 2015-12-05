//
//  BidManage_FD_TVC.h
//  Cofactories
//
//  Created by GTF on 15/12/4.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BidManage_Factory_TVC : UITableViewCell
@property (nonatomic,strong)UIButton *selectButton;
- (void)layoutDataWithModel:(BidManage_Factory_Model *)model;
@end
