//
//  HistoryOrderDetailCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/17.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "HistoryOrderDetailCell.h"

@implementation HistoryOrderDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 60)];
        self.photoView.layer.cornerRadius = 5;
        self.photoView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoView.clipsToBounds = YES;
        [self addSubview:self.photoView];
        self.orderTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoView.frame) + 10, 10, kScreenW - 20 - 70 - 80, 20)];
        self.orderTitleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.orderTitleLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 10 - 70, 10, 70, 20)];
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        self.priceLabel.textColor = [UIColor lightGrayColor];
        self.priceLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.priceLabel];
        
        self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoView.frame) + 10, CGRectGetMaxY(self.orderTitleLabel.frame), kScreenW - 20 - 70 - 80, 20)];
        self.categoryLabel.font = [UIFont systemFontOfSize:13];
        self.categoryLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.categoryLabel];
        
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 10 - 70, CGRectGetMaxY(self.orderTitleLabel.frame), 70, 20)];
        self.numberLabel.font = [UIFont systemFontOfSize:13];
        self.numberLabel.textAlignment = NSTextAlignmentRight;
        self.numberLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.numberLabel];
        
        self.totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoView.frame) + 10, CGRectGetMaxY(self.numberLabel.frame), kScreenW - 20 - 80 - 10, 30)];
        self.totalPriceLabel.textAlignment = NSTextAlignmentRight;
        self.totalPriceLabel.textColor = [UIColor grayColor];
        self.totalPriceLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.totalPriceLabel];
        
        
        
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
