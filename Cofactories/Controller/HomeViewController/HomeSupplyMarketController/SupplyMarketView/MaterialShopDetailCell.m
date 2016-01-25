//
//  MaterialShopDetailCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/5.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MaterialShopDetailCell.h"
#define kMargin 15

@implementation MaterialShopDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.materialLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, 10*kZGY, kScreenW - 2*kMargin, 30*kZGY)];
        self.materialLabel.font = [UIFont boldSystemFontOfSize:15];
        self.materialLabel.textColor = [UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
        [self addSubview:self.materialLabel];
        self.salePriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, CGRectGetMaxY(self.materialLabel.frame), kScreenW - 2*kMargin, 30*kZGY)];
        self.salePriceLabel.font = [UIFont systemFontOfSize:14];
        self.salePriceLabel.textColor = GRAYCOLOR(135.0);
        [self addSubview:self.salePriceLabel];

        self.marketPriceLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, CGRectGetMaxY(self.salePriceLabel.frame), 40*kZGY, 30*kZGY)];
        self.marketPriceLeftLabel.textColor = GRAYCOLOR(135.0);
        self.marketPriceLeftLabel.font = [UIFont systemFontOfSize:13*kZGY];
        [self addSubview:self.marketPriceLeftLabel];
        self.marketPriceRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.marketPriceLeftLabel.frame), CGRectGetMaxY(self.salePriceLabel.frame), 60*kZGY, 30*kZGY)];
        self.marketPriceRightLabel.font = [UIFont systemFontOfSize:13];
        self.marketPriceRightLabel.textColor = GRAYCOLOR(135.0);
        [self addSubview:self.marketPriceRightLabel];
        self.leaveCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.marketPriceRightLabel.frame), CGRectGetMaxY(self.salePriceLabel.frame), kScreenW - 2*kMargin - 120*kZGY, 30*kZGY)];
        self.leaveCountLabel.textColor = GRAYCOLOR(135.0);
        self.leaveCountLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.leaveCountLabel];
        
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
