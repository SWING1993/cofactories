//
//  WalletHistoryTableViewCell.m
//  Cofactories
//
//  Created by 宋国华 on 15/12/9.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "WalletHistoryTableViewCell.h"

@implementation WalletHistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withRowSize:(CGSize)rowSize{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, rowSize.width-40, rowSize.height*2/3)];
        _typeLabel.font = [UIFont boldSystemFontOfSize:15.5f];
        _typeLabel.numberOfLines = 1;
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.textColor = [UIColor blackColor];
        [self addSubview:_typeLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, rowSize.height*2/3, rowSize.width-40, rowSize.height/3)];
        _timeLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _timeLabel.numberOfLines = 1;
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = [UIColor grayColor];
        [self addSubview:_timeLabel];
        
        _feeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, rowSize.width - 20, rowSize.height)];
        _feeLabel.textAlignment = NSTextAlignmentRight;
        _feeLabel.numberOfLines = 1;
        _feeLabel.font = [UIFont boldSystemFontOfSize:15.5f];
        [self addSubview:_feeLabel];
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
