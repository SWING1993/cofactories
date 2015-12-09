//
//  ShoppingCarCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/8.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "ShoppingCarCell.h"

@implementation ShoppingCarCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10*kZGY)];
        bigView.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0];
        [self addSubview:bigView];
        self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectButton.frame = CGRectMake(10*kZGY, 47.5*kZGY, 20*kZGY, 20*kZGY);
        [self addSubview:self.selectButton];
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(40*kZGY, 20*kZGY, 85*kZGY, 75*kZGY)];
        self.photoView.layer.cornerRadius = 5*kZGY;
        self.photoView.clipsToBounds = YES;
        [self addSubview:self.photoView];
        self.shopCarTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoView.frame) + 10*kZGY, 20*kZGY, kScreenW - 155*kZGY, 25*kZGY)];
        self.shopCarTitle.textColor = [UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
        self.shopCarTitle.font = [UIFont systemFontOfSize:15*kZGY];
        [self addSubview:self.shopCarTitle];
        self.shopCarColor = [[UILabel alloc] initWithFrame:CGRectMake(self.shopCarTitle.frame.origin.x, CGRectGetMaxY(self.shopCarTitle.frame), kScreenW - 155*kZGY, 25*kZGY)];
//        self.shopCarColor.backgroundColor = [UIColor yellowColor];
        self.shopCarColor.textColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
        self.shopCarColor.font = [UIFont systemFontOfSize:13*kZGY];
        [self addSubview:self.shopCarColor];
        self.shopCarPrice = [[UILabel alloc] initWithFrame:CGRectMake(self.shopCarTitle.frame.origin.x, CGRectGetMaxY(self.shopCarColor.frame), CGRectGetWidth(self.shopCarTitle.frame), 25*kZGY)];
        self.shopCarPrice.textColor = [UIColor colorWithRed:251.0/255.0 green:40.0/255.0 blue:10.0/255.0 alpha:1.0];
        self.shopCarPrice.font = [UIFont systemFontOfSize:13*kZGY];
        [self addSubview:self.shopCarPrice];
//        self.numberView = [[ShoppingCarNumberView alloc] initWithFrame:CGRectMake(kScreenW - 120, CGRectGetMaxY(self.shopCarTitle.frame), 100, 20)];
//        [self addSubview:self.numberView];
        self.cutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cutButton.frame = CGRectMake(kScreenW - 130*kZGY, self.shopCarColor.frame.origin.y, 25*kZGY, 25*kZGY);
        self.cutButton.layer.cornerRadius = 12.5*kZGY;
        self.cutButton.clipsToBounds = YES;
        [self.cutButton setTitle:@"-" forState:UIControlStateNormal];
        self.cutButton.backgroundColor = [UIColor colorWithRed:72.0/255.0 green:126.0/255.0 blue:207.0/255.0 alpha:1.0];
        self.cutButton.titleLabel.font = [UIFont systemFontOfSize:20*kZGY];
        [self addSubview:self.cutButton];
        
        self.myTextfield = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cutButton.frame), self.cutButton.frame.origin.y, 60*kZGY, 25*kZGY)];
        self.myTextfield.keyboardType = UIKeyboardTypeNumberPad;
        self.myTextfield.textAlignment = NSTextAlignmentCenter;
        self.myTextfield.textColor = [UIColor colorWithRed:98.0/255.0 green:98.0/255.0 blue:98.0/255.0 alpha:1.0];
        [self addSubview:self.myTextfield];
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addButton.frame = CGRectMake(kScreenW - 45*kZGY, self.shopCarColor.frame.origin.y, 25*kZGY, 25*kZGY);
        self.addButton.layer.cornerRadius = 12.5*kZGY;
        self.addButton.clipsToBounds = YES;
        [self.addButton setTitle:@"+" forState:UIControlStateNormal];
        self.addButton.backgroundColor = [UIColor colorWithRed:72.0/255.0 green:126.0/255.0 blue:207.0/255.0 alpha:1.0];
        self.addButton.titleLabel.font = [UIFont systemFontOfSize:20*kZGY];
        [self addSubview:self.addButton];

        
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
