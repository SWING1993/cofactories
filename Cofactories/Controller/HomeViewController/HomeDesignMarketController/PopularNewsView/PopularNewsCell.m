//
//  PopularNewsCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/26.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "PopularNewsCell.h"

@implementation PopularNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 56, 56)];
        [self addSubview:self.photoView];
        self.newstitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoView.frame) + 10, 15, kScreenW - 80, 20)];
        self.newstitle.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.newstitle];
        self.newsDetail = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.newstitle.frame), CGRectGetMaxY(self.newstitle.frame), CGRectGetWidth(self.newstitle.frame), 20)];
        self.newsDetail.font = [UIFont systemFontOfSize:12];
        self.newsDetail.textColor = [UIColor lightGrayColor];
        [self addSubview:self.newsDetail];
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70 - 0.3, kScreenW - 10, 0.3)];
        lineLabel.backgroundColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:207.0f/255.0f alpha:1.0f];
        [self addSubview:lineLabel];
        
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
