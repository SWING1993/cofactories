//
//  HistoryOrderListCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/14.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "HistoryOrderListCell.h"

@implementation HistoryOrderListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
        lineView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
        [self addSubview:lineView];
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenW - 80, 30)];
        self.timeLabel.textColor = [UIColor lightGrayColor];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.timeLabel];
        self.payStatus = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 70, 10, 60, 30)];
        self.payStatus.font = [UIFont boldSystemFontOfSize:14];
        self.payStatus.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.payStatus];
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.timeLabel.frame), 80, 60)];
        self.photoView.layer.cornerRadius = 5;
        self.photoView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoView.clipsToBounds = YES;
        [self addSubview:self.photoView];
        self.orderTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoView.frame) + 10, CGRectGetMaxY(self.timeLabel.frame), kScreenW - 20 - 70 - 80, 20)];
        self.orderTitleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.orderTitleLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 10 - 70, CGRectGetMaxY(self.timeLabel.frame), 70, 20)];
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
