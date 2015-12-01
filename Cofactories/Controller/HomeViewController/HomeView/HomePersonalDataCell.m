//
//  HomePersonalDataCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/21.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "HomePersonalDataCell.h"

@implementation HomePersonalDataCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.personalDataLeftImage = [[UIImageView alloc] initWithFrame:CGRectMake(10*kZGY, 15*kZGY, 50*kZGY, 50*kZGY)];
        self.personalDataLeftImage.layer.cornerRadius = 25*kZGY;
        self.personalDataLeftImage.layer.masksToBounds = YES;
        [self addSubview:self.personalDataLeftImage];
        
        self.personNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.personalDataLeftImage.frame) + 15*kZGY, 15*kZGY, kScreenW/2 - 75*kZGY, 20*kZGY)];
        self.personNameLabel.font = [UIFont boldSystemFontOfSize:14*kZGY];
        self.personNameLabel.textColor = [UIColor colorWithRed:68.0f/255.0f green:68.0f/255.0f blue:68.0f/255.0f alpha:1.0f];
        [self addSubview:self.personNameLabel];
        
        self.personStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.personNameLabel.frame.origin.x, CGRectGetMaxY(self.personNameLabel.frame) + 2.5*kZGY, 200*kZGY, 15*kZGY)];
        self.personStatusLabel.font = [UIFont systemFontOfSize:10*kZGY];
        self.personStatusLabel.textColor = [UIColor colorWithRed:167.0f/255.0f green:167.0f/255.0f blue:167.0f/255.0f alpha:1.0f];
        [self addSubview:self.personStatusLabel];
        
        self.personWalletLeft = [[UILabel alloc] initWithFrame:CGRectMake(self.personNameLabel.frame.origin.x, CGRectGetMaxY(self.personStatusLabel.frame), 200*kZGY, 15*kZGY)];
        self.personWalletLeft.font = [UIFont systemFontOfSize:10*kZGY];
        self.personWalletLeft.textColor = [UIColor colorWithRed:167.0f/255.0f green:167.0f/255.0f blue:167.0f/255.0f alpha:1.0f];
        [self addSubview:self.personWalletLeft];
        
        self.personAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.personAddressButton.frame = CGRectMake(10*kZGY, CGRectGetMaxY(self.personWalletLeft.frame) + 2.5*kZGY, kScreenW/2 - 10*kZGY, 25*kZGY);
        self.personAddressButton.titleLabel.font = [UIFont systemFontOfSize:11*kZGY];
        [self.personAddressButton setTitleColor:[UIColor colorWithRed:112.0f/255.0f green:112.0f/255.0f blue:112.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        
        [self addSubview:self.personAddressButton];
//        self.personAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10*kZGY, CGRectGetMaxY(self.personWalletLeft.frame) + 2.5*kZGY, kScreenW/2 - 10*kZGY, 25*kZGY)];
//        self.personAddressLabel.font = [UIFont systemFontOfSize:11*kZGY];
//        self.personAddressLabel.textColor = [UIColor colorWithRed:112.0f/255.0f green:112.0f/255.0f blue:112.0f/255.0f alpha:1.0f];
//        [self addSubview:self.personAddressLabel];
        
        self.personStyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW/2 + 10*kZGY, 20*kZGY, kScreenW/4 - 20*kZGY, 20*kZGY)];
        self.personStyleLabel.textAlignment = NSTextAlignmentCenter;
        self.personStyleLabel.font = [UIFont systemFontOfSize:12*kZGY];
        self.personStyleLabel.text = @"个人身份";
        self.personStyleLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
        [self addSubview:self.personStyleLabel];
        self.personalDataMiddleImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW/2 + 20*kZGY, CGRectGetMaxY(self.personStyleLabel.frame) + 15*kZGY, kScreenW/4 - 40*kZGY, 18*kZGY)];
        [self addSubview:self.personalDataMiddleImage];
        
        self.personalDataRightImage = [[UIImageView alloc] initWithFrame:CGRectMake(3*kScreenW/4 + 30*kZGY, 20*kZGY, kScreenW/4 - 60*kZGY, 40*kZGY)];
        
        self.personalDataRightImage.image = [UIImage imageNamed:@"Home-聚"];
        [self addSubview:self.personalDataRightImage];
        self.authenticationLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*kScreenW/4 + 10*kZGY, 70*kZGY, kScreenW/4 - 20*kZGY, 20*kZGY)];
        self.authenticationLabel.font = [UIFont systemFontOfSize:11*kZGY];
        self.authenticationLabel.textAlignment = NSTextAlignmentCenter;
        self.authenticationLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
        [self addSubview:self.authenticationLabel];
        self.authenticationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.authenticationButton.frame = CGRectMake(3*kScreenW/4, 0, kScreenW/4, 105*kZGY);
        [self addSubview:self.authenticationButton];
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW / 2, 20*kZGY, 0.3, 65*kZGY)];
        leftLabel.backgroundColor = [UIColor grayColor];
        [self addSubview:leftLabel];
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*kScreenW / 4, 20*kZGY, 0.3, 65*kZGY)];
        rightLabel.backgroundColor = [UIColor grayColor];
        [self addSubview:rightLabel];
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
