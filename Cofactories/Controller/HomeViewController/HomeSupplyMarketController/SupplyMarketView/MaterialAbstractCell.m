//
//  MaterialAbstractCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/5.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MaterialAbstractCell.h"

@implementation MaterialAbstractCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.AbstractTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenW - 30, 30)];
        self.AbstractTitleLabel.font = [UIFont systemFontOfSize:15];
        self.AbstractTitleLabel.textColor =[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
        [self addSubview:self.AbstractTitleLabel];
        self.AbstractDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.AbstractTitleLabel.frame), kScreenW - 60, 500)];
        self.AbstractDetailLabel.textColor = [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1.0];
        self.AbstractDetailLabel.font = [UIFont systemFontOfSize:13];
        self.AbstractDetailLabel.numberOfLines = 0;
        self.AbstractDetailLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:self.AbstractDetailLabel];
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
