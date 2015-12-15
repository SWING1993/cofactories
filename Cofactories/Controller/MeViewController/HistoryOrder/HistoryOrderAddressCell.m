//
//  HistoryOrderAddressCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/15.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import "HistoryOrderAddressCell.h"

@implementation HistoryOrderAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
//        myView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
//        [self addSubview:myView];
        self.addressView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 34, 25, 32)];
        self.addressView.image = [UIImage imageNamed:@"Me-历史订单地址"];
        [self addSubview:self.addressView];
        self.personName = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, kScreenW - 80, 20)];
        self.personName.font = [UIFont systemFontOfSize:14];
        self.personName.textColor = [UIColor grayColor];
        [self addSubview:self.personName];
        self.personPhoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(self.personName.frame.origin.x, CGRectGetMaxY(self.personName.frame), CGRectGetWidth(self.personName.frame), 20)];
        self.personPhoneNumber.font = [UIFont systemFontOfSize:14];
        self.personPhoneNumber.textColor = [UIColor grayColor];
        [self addSubview:self.personPhoneNumber];
        self.personAddress = [[UILabel alloc] initWithFrame:CGRectMake(self.personName.frame.origin.x, CGRectGetMaxY(self.personPhoneNumber.frame), CGRectGetWidth(self.personName.frame), 40)];
        self.personAddress.numberOfLines = 2;
        self.personAddress.font = [UIFont systemFontOfSize:14];
        self.personAddress.textColor = [UIColor grayColor];
        [self addSubview:self.personAddress];
        
        
        
        
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
