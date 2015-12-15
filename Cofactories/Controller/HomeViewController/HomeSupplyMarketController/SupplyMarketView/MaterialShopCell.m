//
//  MaterialShopCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/4.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MaterialShopCell.h"

@implementation MaterialShopCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = kLineGrayCorlor.CGColor;
        self.layer.borderWidth = 0.3;
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        self.photoView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoView.clipsToBounds = YES;
        [self addSubview:self.photoView];
        self.materialTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.photoView.frame) + 5, self.frame.size.width - 10, 40)];
        self.materialTitle.numberOfLines = 2;
        self.materialTitle.font = [UIFont systemFontOfSize:15];
        self.materialTitle.textColor = [UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
        [self addSubview:self.materialTitle];
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.materialTitle.frame), self.frame.size.width - 10, 25)];
        self.priceLabel.textColor = [UIColor colorWithRed:251.0/255.0 green:39.0/255.0 blue:10.0/255.0 alpha:1.0];
        self.priceLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.priceLabel];
        self.saleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.priceLabel.frame), 100, 30)];
        self.saleLabel.textColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
        self.saleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.saleLabel];
        self.placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 65, CGRectGetMaxY(self.priceLabel.frame), 60, 25)];
        self.placeLabel.textColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
        self.placeLabel.font = [UIFont systemFontOfSize:14];
        self.placeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.placeLabel];
    }
    return self;
}



@end
