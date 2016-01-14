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
        self.personalDataLeftImage.contentMode = UIViewContentModeScaleAspectFill;
        self.personalDataLeftImage.clipsToBounds = YES;
        [self addSubview:self.personalDataLeftImage];
        
        self.personStatusImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.personalDataLeftImage.frame) + 10*kZGY, 17.5*kZGY, 15*kZGY, 15*kZGY)];
        
        [self addSubview:self.personStatusImage];
        self.personNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.personStatusImage.frame) + 5*kZGY, 15*kZGY, kScreenW/2 - 90*kZGY, 20*kZGY)];
        self.personNameLabel.font = [UIFont boldSystemFontOfSize:14*kZGY];
        self.personNameLabel.textColor = [UIColor colorWithRed:68.0f/255.0f green:68.0f/255.0f blue:68.0f/255.0f alpha:1.0f];
        [self addSubview:self.personNameLabel];
        
        self.personScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.personStatusImage.frame.origin.x, CGRectGetMaxY(self.personNameLabel.frame) + 2.5*kZGY, kScreenW/2 - 70*kZGY, 15*kZGY)];
        self.personScoreLabel.font = [UIFont systemFontOfSize:10*kZGY];
        self.personScoreLabel.textColor = [UIColor colorWithRed:167.0f/255.0f green:167.0f/255.0f blue:167.0f/255.0f alpha:1.0f];
        [self addSubview:self.personScoreLabel];
        
        self.personWalletLeft = [[UILabel alloc] initWithFrame:CGRectMake(self.personStatusImage.frame.origin.x, CGRectGetMaxY(self.personScoreLabel.frame), kScreenW/2 - 70*kZGY, 15*kZGY)];
        self.personWalletLeft.font = [UIFont systemFontOfSize:10*kZGY];
        self.personWalletLeft.textColor = [UIColor colorWithRed:167.0f/255.0f green:167.0f/255.0f blue:167.0f/255.0f alpha:1.0f];
        [self addSubview:self.personWalletLeft];
        
        self.personAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.personAddressButton.frame = CGRectMake(10*kZGY, CGRectGetMaxY(self.personWalletLeft.frame) , kScreenW/2 - 20*kZGY, 25*kZGY);
        self.personAddressButton.titleLabel.font = [UIFont systemFontOfSize:11*kZGY];
        [self.personAddressButton setTitleColor:[UIColor colorWithRed:112.0f/255.0f green:112.0f/255.0f blue:112.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        
        [self addSubview:self.personAddressButton];
        
        self.personStyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW/2 + 10*kZGY, 20*kZGY, kScreenW/4 - 20*kZGY, 20*kZGY)];
        self.personStyleLabel.textAlignment = NSTextAlignmentCenter;
        self.personStyleLabel.font = [UIFont systemFontOfSize:12*kZGY];
        self.personStyleLabel.text = @"个人身份";
        self.personStyleLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
        [self addSubview:self.personStyleLabel];
        self.personalDataMiddleImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW/2 + 18*kZGY, CGRectGetMaxY(self.personStyleLabel.frame) + 15*kZGY, kScreenW/4 - 36*kZGY, 18*kZGY)];
        self.personalDataMiddleImage.contentMode = UIViewContentModeScaleAspectFill;
        self.personalDataMiddleImage.clipsToBounds = YES;
        [self addSubview:self.personalDataMiddleImage];
        
        self.personalDataRightImage = [[UIImageView alloc] initWithFrame:CGRectMake(3*kScreenW/4 + 30*kZGY, 20*kZGY, kScreenW/4 - 60*kZGY, 40*kZGY)];
        
        self.personalDataRightImage.image = [UIImage imageNamed:@"Home-聚"];
        self.personalDataRightImage.contentMode = UIViewContentModeScaleAspectFill;
        self.personalDataRightImage.clipsToBounds = YES;
        [self addSubview:self.personalDataRightImage];
        self.authenticationLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*kScreenW/4 + 10*kZGY, 70*kZGY, kScreenW/4 - 20*kZGY, 20*kZGY)];
        self.authenticationLabel.font = [UIFont systemFontOfSize:11*kZGY];
        self.authenticationLabel.textAlignment = NSTextAlignmentCenter;
        self.authenticationLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
        [self addSubview:self.authenticationLabel];
        self.authenticationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.authenticationButton.frame = CGRectMake(3*kScreenW/4, 0, kScreenW/4, 100*kZGY);
        [self addSubview:self.authenticationButton];
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW / 2, 20*kZGY, 0.3, 65*kZGY)];
        leftLabel.backgroundColor = kLineGrayCorlor;
        [self addSubview:leftLabel];
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(3*kScreenW / 4, 20*kZGY, 0.3, 65*kZGY)];
        rightLabel.backgroundColor = kLineGrayCorlor;
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
