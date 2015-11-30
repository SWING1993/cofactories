//
//  SupplyMarketButton.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/30.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "SupplyMarketButton.h"

@implementation SupplyMarketButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
        [self addSubview:self.photoView];
        self.supplyTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.photoView.frame) + 10, self.frame.size.height/4, self.frame.size.width - self.frame.size.height, self.frame.size.height/5)];
        self.supplyTitle.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.supplyTitle];
        self.supplyDetail = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.supplyTitle.frame), 3*self.frame.size.height/5, CGRectGetWidth(self.supplyTitle.frame), CGRectGetHeight(self.supplyTitle.frame))];
        self.supplyDetail.font = [UIFont systemFontOfSize:13];
        self.supplyDetail.textColor = [UIColor lightGrayColor];
        [self addSubview:self.supplyDetail];
    }
    return self;
}




@end
