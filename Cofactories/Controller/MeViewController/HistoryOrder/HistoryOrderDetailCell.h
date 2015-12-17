//
//  HistoryOrderDetailCell.h
//  Cofactories
//
//  Created by 赵广印 on 15/12/17.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryOrderDetailCell : UITableViewCell


@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *orderTitleLabel;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *totalPriceLabel;
@end
