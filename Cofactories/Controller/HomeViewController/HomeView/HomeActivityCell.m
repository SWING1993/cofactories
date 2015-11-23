//
//  HomeActivityCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/21.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "HomeActivityCell.h"

@implementation HomeActivityCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.activityPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.4*kScreenW)];
        self.activityPhoto.userInteractionEnabled = YES;
        [self addSubview:self.activityPhoto];
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
