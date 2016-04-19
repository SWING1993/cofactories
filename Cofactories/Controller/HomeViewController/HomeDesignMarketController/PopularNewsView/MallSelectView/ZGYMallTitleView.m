//
//  ZGYMallTitleView.m
//  MallOfCofactories
//
//  Created by 赵广印 on 16/4/16.
//  Copyright © 2016年 聚工科技. All rights reserved.
//

#import "ZGYMallTitleView.h"

@implementation ZGYMallTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
        self.myTitleLabel.font = [UIFont systemFontOfSize:15];
        self.myTitleLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:self.myTitleLabel];
    }
    return self;
}

@end
