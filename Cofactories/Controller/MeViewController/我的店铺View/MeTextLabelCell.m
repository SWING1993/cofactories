//
//  MeTextLabelCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/11.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MeTextLabelCell.h"

@implementation MeTextLabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.shangPinTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 75, 40)];
        self.shangPinTitle.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.shangPinTitle];
        self.shangPinDetail = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.shangPinTitle.frame) + 10, 0, kScreenW - 115, 40)];
        self.shangPinDetail.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.shangPinDetail];
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
