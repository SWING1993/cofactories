//
//  MallAddressCell.m
//  Cofactories
//
//  Created by 赵广印 on 16/1/26.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MallAddressCell.h"

@implementation MallAddressCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CALayer *line = [CALayer layer];
        line.frame = CGRectMake(0, 0, kScreenW, 0.5);
        line.backgroundColor = kLineGrayCorlor.CGColor;
        [self.layer addSublayer:line];
        
        self.personNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenW/2 - 10, 40)];
        self.personNameLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:self.personNameLabel];
        self.phoneNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW/2, 0, kScreenW/2 - 40, 40)];
        self.phoneNumberLabel.textAlignment = NSTextAlignmentRight;
        self.phoneNumberLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.phoneNumberLabel];
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.personNameLabel.frame), kScreenW - 20, 20)];
        self.addressLabel.font = [UIFont systemFontOfSize:12];
        self.addressLabel.numberOfLines = 0;
        [self addSubview:self.addressLabel];
        
    }
    return self;
}


@end
