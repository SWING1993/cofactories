//
//  MaterialShopDetailCell.h
//  Cofactories
//
//  Created by 赵广印 on 15/12/5.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaterialShopDetailCell : UITableViewCell

@property (nonatomic, strong) UILabel *materialLabel;
@property (nonatomic, strong) UILabel *priceLeftLabel;
@property (nonatomic, strong) UILabel *priceRightLabel;
@property (nonatomic, strong) UIImageView *stylePhoto;
@property (nonatomic, strong) UILabel *marketPriceLeftLabel;
@property (nonatomic, strong) UILabel *marketPriceRightLabel;
@property (nonatomic, strong) UILabel *leaveCountLabel;

@end
