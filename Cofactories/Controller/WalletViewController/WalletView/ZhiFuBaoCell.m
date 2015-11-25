//
//  ZhiFuBaoCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/24.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "ZhiFuBaoCell.h"

@implementation ZhiFuBaoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 50)];
        [self addSubview:self.photoView];
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
