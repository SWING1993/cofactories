//
//  MeShopCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/10.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MeShopCell.h"

@implementation MeShopCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kScreenW - 10)/3, (kScreenW - 10)/3)];
        [self addSubview:self.photoView];
        self.shopTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.photoView.frame), self.frame.size.width - 10, 40)];
        self.shopTitle.numberOfLines = 2;
        self.shopTitle.font = [UIFont systemFontOfSize:15];
        self.shopTitle.textColor = [UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
        [self addSubview:self.shopTitle];
        self.saleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.shopTitle.frame), self.frame.size.width - 10, 20)];
        self.saleLabel.font = [UIFont systemFontOfSize:13];
        self.saleLabel.textColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
        [self addSubview:self.saleLabel];
        
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton.frame = CGRectMake(self.frame.size.width - 40, 0, 40, 40);
        [self addSubview:self.deleteButton];
        
    }
    return self;
}


@end
