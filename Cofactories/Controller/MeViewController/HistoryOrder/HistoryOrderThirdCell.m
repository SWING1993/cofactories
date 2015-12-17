//
//  HistoryOrderThirdCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/17.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "HistoryOrderThirdCell.h"

@implementation HistoryOrderThirdCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.creatTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreenW - 20, 20)];
        self.creatTime.font = [UIFont systemFontOfSize:13];
        self.creatTime.textColor = [UIColor lightGrayColor];
        [self addSubview:self.creatTime];
        self.orderNum = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.creatTime.frame), kScreenW - 20, 20)];
        self.orderNum.font = [UIFont systemFontOfSize:13];
        self.orderNum.textColor = [UIColor lightGrayColor];
        [self addSubview:self.orderNum];
        self.payType = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.orderNum.frame), kScreenW - 20, 20)];
        self.payType.font = [UIFont systemFontOfSize:13];
        self.payType.textColor = [UIColor lightGrayColor];
        [self addSubview:self.payType];
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
