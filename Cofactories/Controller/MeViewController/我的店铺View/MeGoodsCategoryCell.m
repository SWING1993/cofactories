//
//  MeGoodsCategoryCell.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/12.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MeGoodsCategoryCell.h"

@implementation MeGoodsCategoryCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.goodsCategory = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width , self.frame.size.height)];
        self.goodsCategory.font = [UIFont systemFontOfSize:14];
        self.goodsCategory.textAlignment = NSTextAlignmentCenter;
        self.goodsCategory.textColor = [UIColor whiteColor];
        self.goodsCategory.backgroundColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0];
        self.goodsCategory.layer.cornerRadius = self.frame.size.height/2;
        self.goodsCategory.clipsToBounds = YES;
        [self addSubview:self.goodsCategory];
    }
    return self;
}

@end
