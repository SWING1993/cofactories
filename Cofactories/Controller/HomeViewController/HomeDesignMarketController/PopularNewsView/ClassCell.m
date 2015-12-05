//
//  ClassCell.m
//  美团下拉菜单
//
//  Created by 赵广印 on 15/11/20.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "ClassCell.h"

@implementation ClassCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.sub_imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 20, 20)];
//        
//        [self addSubview:self.sub_imgV];
        self.sub_titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW/3, 44)];
        self.sub_titleLb.textColor = [UIColor colorWithRed:38.0f/255.0f green:38.0f/255.0f blue:38.0f/255.0f alpha:1.0f];
        self.sub_titleLb.font = [UIFont systemFontOfSize:13];
        self.sub_titleLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.sub_titleLb];
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.3, kScreenW/3, 0.3)];
        myView.backgroundColor = kLineGrayCorlor;
        [self addSubview:myView];
        self.rightView = [[UIView alloc] initWithFrame:CGRectMake(kScreenW/3 - 0.5, 0, 0.3, 44)];
        self.rightView.backgroundColor = kLineGrayCorlor;
        [self addSubview:self.rightView];
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
