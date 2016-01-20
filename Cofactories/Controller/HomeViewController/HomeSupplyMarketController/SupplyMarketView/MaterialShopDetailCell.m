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
        self.materialLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, 10, kScreenW - 2*kMargin, 30)];
        self.materialLabel.font = [UIFont boldSystemFontOfSize:15];
        self.materialLabel.textColor = [UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
        [self addSubview:self.materialLabel];
        self.priceLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, CGRectGetMaxY(self.materialLabel.frame), kScreenW - 2*kMargin, 30)];
        self.priceLeftLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.priceLeftLabel];

        self.marketPriceLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, CGRectGetMaxY(self.priceLeftLabel.frame), 40, 30)];
        self.marketPriceLeftLabel.textColor = kLightGaryColor;
        self.marketPriceLeftLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.marketPriceLeftLabel];
        self.marketPriceRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.marketPriceLeftLabel.frame), CGRectGetMaxY(self.priceLeftLabel.frame), 60, 30)];
        self.marketPriceRightLabel.font = [UIFont systemFontOfSize:13];
        self.marketPriceRightLabel.textColor = kLightGaryColor;
        [self addSubview:self.marketPriceRightLabel];
        self.leaveCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.marketPriceRightLabel.frame), CGRectGetMaxY(self.priceLeftLabel.frame), kScreenW - 2*kMargin - 120, 30)];
        self.leaveCountLabel.textColor = kLightGaryColor;
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
