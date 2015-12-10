//
//  PersonalShop_TVC.h
//  Cofactories
//
//  Created by GTF on 15/12/10.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalShop_TVC : UITableViewCell
@property (nonatomic,strong)UIButton *buttonLeft;
@property (nonatomic,strong)UIButton *buttonRight;
- (void)layoutDataWithArray:(NSArray *)array indexPath:(NSIndexPath*)indexPath;
@end
