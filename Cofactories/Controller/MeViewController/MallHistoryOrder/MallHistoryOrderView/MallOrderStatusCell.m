//
//  MallOrderStatusCell.m
//  Cofactories
//
//  Created by 赵广印 on 16/2/17.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallOrderStatusCell.h"

@implementation MallOrderStatusCell

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
        self.payTime = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.orderNum.frame), kScreenW - 20, 20)];
        self.payTime.font = [UIFont systemFontOfSize:13];
        self.payTime.textColor = [UIColor lightGrayColor];
        [self addSubview:self.payTime];
        self.sendTime = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.payTime.frame), kScreenW - 20, 20)];
        self.sendTime.font = [UIFont systemFontOfSize:13];
        self.sendTime.textColor = [UIColor lightGrayColor];
        [self addSubview:self.sendTime];
        self.receiveTime = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.sendTime.frame), kScreenW - 20, 20)];
        self.receiveTime.font = [UIFont systemFontOfSize:13];
        self.receiveTime.textColor = [UIColor lightGrayColor];
        [self addSubview:self.receiveTime];
    }
    return self;
}

@end
